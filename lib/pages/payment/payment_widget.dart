import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:furugi_with_template/auth/firebase_auth/auth_util.dart';
import 'package:furugi_with_template/backend/schema/notifications_record.dart';
import 'package:furugi_with_template/backend/schema/purchases_record.dart';
import 'package:furugi_with_template/backend/schema/util/firestore_util.dart';
import '/flutter_flow/flutter_flow_util.dart'; // FFAppState使う場合

// ★ 追加: Cloud Functions を使うため
import 'package:cloud_functions/cloud_functions.dart';

class PaymentWidget extends StatefulWidget {
  const PaymentWidget({Key? key}) : super(key: key);

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  bool _paymentInProgress = false;
  late int _amount;
  List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    // FFAppState から取得
    _cartItems = FFAppState().paymentCartItems;
    _amount = FFAppState().paymentTotalPrice;
  }

  // -------------------------------------------
  // ① Firebase Functions: createPaymentIntent
  // -------------------------------------------
  Future<String?> _createPaymentIntentViaCloudFunctions() async {
    try {
      // createPaymentIntent (v2) を呼び出し
      final callable =
          FirebaseFunctions.instance.httpsCallable('createPaymentIntent');
      final result = await callable.call({
        'amount': _amount,
        'currency': 'jpy',
      });
      // result.data は Map
      final data = Map<String, dynamic>.from(result.data);
      return data['clientSecret'] as String?;
    } catch (e) {
      debugPrint('Error calling createPaymentIntent: $e');
      return null;
    }
  }

  // -------------------------------------------
  // ② Firebase Functions: sendPurchaseMail
  // -------------------------------------------
  Future<void> _sendPurchaseMail({
    required String buyerEmail,
    required String sellerEmail,
  }) async {
    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable('sendPurchaseMail');
      await callable.call({
        'buyerEmail': buyerEmail,
        'sellerEmail': sellerEmail,
      });
      debugPrint('メール送信成功');
    } catch (e) {
      debugPrint('メール送信失敗: $e');
    }
  }

  // -------------------------------------------
  // ③ Stripe決済フロー → Firestore → メール送信
  // -------------------------------------------
  Future<void> _handlePaymentWithCard() async {
    setState(() => _paymentInProgress = true);

    try {
      // 1) PaymentIntent取得 (Firebase Functions)
      final clientSecret = await _createPaymentIntentViaCloudFunctions();
      if (clientSecret == null) {
        throw Exception('Failed to create PaymentIntent via Cloud Functions');
      }

      // 2) PaymentSheet 初期化 & 表示
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'My Shop',
          style: ThemeMode.light,
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      // 3) Firestore 保存 & メール送信
      if (mounted) {
        // 購入履歴
        final purchasesDocRef = PurchasesRecord.collection.doc();
        await purchasesDocRef.set({
          ...createPurchasesRecordData(
            user: currentUserReference,
            price: FFAppState().cartSum,
          ),
          ...mapToFirestore({
            'product': FFAppState().cartItems,
            'time_stamp': FieldValue.serverTimestamp(),
          }),
        });

        // 購入者(ログインユーザー)メール
        final buyerEmail = currentUserEmail ?? '';
        final Set<String> sellerEmails = {};

        // 通知レコード & 出品者メール収集
        for (final item in _cartItems) {
          final sellerRef = item['user'] as DocumentReference?;
          final productName = item['name'] ?? '商品名不明';

          // 購入者向け通知
          await NotificationsRecord.collection.doc().set({
            ...createNotificationsRecordData(
              user: currentUserReference,
              detail: '「$productName」を購入しました！出品者に連絡しましょう。',
              about: 'product purchased',
            ),
            ...mapToFirestore({
              'product': [item],
              'time_stamp': FieldValue.serverTimestamp(),
            }),
          });

          // 出品者向け通知
          if (sellerRef != null) {
            final sellerSnap = await sellerRef.get();
            final sellerData = sellerSnap.data() as Map<String, dynamic>?;
            final sellerEmail = sellerData?['email'] ?? '';
            if (sellerEmail.isNotEmpty) {
              sellerEmails.add(sellerEmail);
            }

            await NotificationsRecord.collection.doc().set({
              ...createNotificationsRecordData(
                user: sellerRef,
                detail: 'あなたの「$productName」が購入されました！',
                about: 'product purchased',
              ),
              ...mapToFirestore({
                'product': [item],
                'time_stamp': FieldValue.serverTimestamp(),
              }),
            });
          }
        }

        // (C) メール送信
        // 購入者
        if (buyerEmail.isNotEmpty) {
          // Functions経由で送信
          await _sendPurchaseMail(
            buyerEmail: buyerEmail,
            sellerEmail: '', // 購入者には sellerEmail 必要ない場合はスキップか空で
          );
        }
        // 出品者 (複数いる場合あり)
        for (final sEmail in sellerEmails) {
          await _sendPurchaseMail(
            buyerEmail: '', // 出品者へのメールなので buyerEmail は空
            sellerEmail: sEmail,
          );
        }

        // 画面遷移 & ダイアログ
        context.pushNamed(
          'PurchasedConversation',
          queryParameters: {
            'productInfo': serializeParam(
              FFAppState().cartItems,
              ParamType.DocumentReference,
              isList: true,
            ),
          }.withoutNulls,
        );

        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: const Text('success!!'),
              content: const Text('購入が完了しました'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    } on StripeException catch (e) {
      debugPrint('StripeException: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('決済がキャンセルされました')),
        );
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('エラーが発生しました')),
        );
      }
    } finally {
      setState(() => _paymentInProgress = false);
    }
  }

  // -------------------------------------------
  // ④ UI
  // -------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment: カートデータ & Stripe決済 (via Firebase)'),
      ),
      body: _paymentInProgress
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // カート内商品
                  if (_cartItems.isNotEmpty)
                    ListView.builder(
                      itemCount: _cartItems.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        final imageUrl = item['image'] as String? ?? '';
                        final name = item['name'] as String? ?? 'No name';
                        final price = item['price'] ?? 0;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('¥$price'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  else
                    const Text('カートが空です'),

                  const SizedBox(height: 16),
                  // 合計
                  Text(
                    '合計: $_amount 円',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 決済ボタン
                  ElevatedButton(
                    onPressed: _handlePaymentWithCard,
                    child: const Text('クレジットカードで支払う'),
                  ),
                ],
              ),
            ),
    );
  }
}
