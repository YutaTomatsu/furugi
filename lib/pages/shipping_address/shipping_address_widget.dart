import 'package:furugi_with_template/backend/api_requests/api_calls.dart';
import 'package:furugi_with_template/components/nav_bar12_widget.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'shipping_address_model.dart';

class ShippingAddressWidget extends StatefulWidget {
  const ShippingAddressWidget({Key? key}) : super(key: key);

  @override
  _ShippingAddressWidgetState createState() => _ShippingAddressWidgetState();
}

class _ShippingAddressWidgetState extends State<ShippingAddressWidget>
    with SingleTickerProviderStateMixin {
  // 既存の住所一覧
  List<Map<String, dynamic>> _addresses = [];
  int? _defaultAddressIndex;
  int? _postalCode;

  // バナー関連
  String? _bannerMessage;
  late AnimationController _bannerAnimCtrl;
  late Animation<double> _bannerOpacity;

  // モデル
  late ShippingAddressModel _model;

  // 新規 or 編集用フォームを表示中かどうか
  bool _isEditingAddress = false;
  bool _hasChanges = false;

  // 編集対象のインデックス(nullなら「新規」)
  int? _editingIndex;

  // フォーム関連
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _prefectureController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  // 元の値（編集開始時の値）を保持して変更が戻ったかどうか判定する
  late Map<String, String> _originalValues;

  String? _postalCodeError;

  @override
  void initState() {
    super.initState();
    // モデル
    _model = createModel(context, () => ShippingAddressModel());

    // Firestoreから現在の配送先情報を読み込む
    if (currentUserDocument?.address is List) {
      _addresses =
          List<Map<String, dynamic>>.from(currentUserDocument!.address);
    }
    if (currentUserDocument != null &&
        currentUserDocument!.snapshotData
            .containsKey('default_address_index')) {
      _defaultAddressIndex =
          currentUserDocument!.snapshotData['default_address_index'] as int?;
    }
    if (_defaultAddressIndex == null && _addresses.isNotEmpty) {
      _defaultAddressIndex = 0;
    }

    // バナー用アニメーション
    _bannerAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bannerOpacity =
        Tween<double>(begin: 0.0, end: 1.0).animate(_bannerAnimCtrl);
  }

  @override
  void dispose() {
    _model.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _postalCodeController.dispose();
    _prefectureController.dispose();
    _detailController.dispose();
    _bannerAnimCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveAddressesToFirestore() async {
    await currentUserReference!.update(createUsersRecordData(
      address: _addresses,
      defaultAddressIndex: _defaultAddressIndex,
      postalCode: _postalCode,
    ));
  }

  // バナーをアニメーション表示
  void _showBannerMessage(String msg) async {
    setState(() {
      _bannerMessage = msg;
    });
    // フェードイン
    await _bannerAnimCtrl.forward(from: 0.0);
    // 3秒待つ
    await Future.delayed(const Duration(seconds: 3));
    // フェードアウト
    if (mounted && _bannerMessage == msg) {
      await _bannerAnimCtrl.reverse();
      if (mounted) {
        setState(() {
          _bannerMessage = null;
        });
      }
    }
  }

  // フォーム開始
  void _startEditAddress({int? index}) {
    setState(() {
      _isEditingAddress = true;
      _editingIndex = index;
      _hasChanges = false;
      _postalCodeError = null;

      if (index != null) {
        // 既存アドレスの編集
        final target = _addresses[index];
        final addressText = target['address'] ?? '';

        final splitted = addressText.split(' ');

        if (splitted.length >= 2) {
          _prefectureController.text = splitted.first;
          _detailController.text = splitted.sublist(1).join(' ');
        } else {
          _prefectureController.text = addressText; // または ''
          _detailController.text = '';
        }

        _nameController.text = target['name'] ?? '';
        _emailController.text = target['email'] ?? '';
        _phoneController.text = target['phone'] ?? '';
        _postalCodeController.text = target['postal_code'] ?? '';
      } else {
        // 新規追加
        _nameController.text = currentUserDisplayName;
        _emailController.text = currentUserEmail;
        _phoneController.text = currentPhoneNumber;
        _postalCodeController.clear();
        _prefectureController.clear();
        _detailController.clear();
      }

      // 編集開始時の値を保存
      _originalValues = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'prefecture': _prefectureController.text,
        'detail': _detailController.text,
        'postal_code': _postalCodeController.text,
      };
    });
  }

  // フォーム変更時: 変更されていないかチェック
  void _onFieldChanged() {
    final currentVals = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'prefecture': _prefectureController.text,
      'detail': _detailController.text,
      'postal_code': _postalCodeController.text,
    };
    // 現在値が最初の値と同じなら false
    final hasDiff = currentVals.entries.any((e) {
      return _originalValues[e.key] != e.value;
    });

    setState(() {
      _hasChanges = hasDiff;
    });
  }

  // キャンセル
  void _cancelEditAddress() {
    setState(() {
      _isEditingAddress = false;
      _editingIndex = null;
      _postalCodeError = null;
      _hasChanges = false;
    });
  }

  // 郵便番号バリデーション
  String? _validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return '郵便番号を入力してください';
    }
    if (!RegExp(r'^\d{7}$').hasMatch(value)) {
      return '7桁の数字を入力してください（ハイフンなし）';
    }
    return null;
  }

  // 郵便番号検索
  Future<void> _searchPostalCode() async {
    final error = _validatePostalCode(_postalCodeController.text);
    if (error != null) {
      setState(() {
        _postalCodeError = error;
      });
      return;
    }
    setState(() {
      _postalCodeError = null;
    });

    final apiResult = await ZipcodeAPICall.call(
      zipcode: _postalCodeController.text,
    );
    if ((apiResult?.succeeded ?? false) &&
        getJsonField((apiResult?.jsonBody ?? ''), r'''$.results''') != null) {
      final address1 = getJsonField(
              (apiResult?.jsonBody ?? ''), r'''$.results[0].address1''')
          .toString();
      final address2 = getJsonField(
              (apiResult?.jsonBody ?? ''), r'''$.results[0].address2''')
          .toString();
      final address3 = getJsonField(
              (apiResult?.jsonBody ?? ''), r'''$.results[0].address3''')
          .toString();
      setState(() {
        _prefectureController.text = address1;
        _detailController.text = '$address2$address3';
      });
    } else {
      setState(() {
        _postalCodeError = '正しい郵便番号を入力してください';
      });
    }
  }

  // 保存
  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final fullAddress =
        '${_prefectureController.text} ${_detailController.text}';
    if (_editingIndex != null) {
      // 既存編集
      setState(() {
        _addresses[_editingIndex!] = {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': fullAddress,
          'postal_code': _postalCodeController.text,
        };
      });
      _showBannerMessage('配送先を更新しました');
    } else {
      // 新規追加
      setState(() {
        final newAddress = {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': fullAddress,
          'postal_code': _postalCodeController.text,
        };
        _addresses.add(newAddress);
        if (_defaultAddressIndex == null) {
          _defaultAddressIndex = _addresses.length - 1;
        }
      });
      _showBannerMessage('配送先を追加しました');
    }
    await _saveAddressesToFirestore();
    setState(() {
      _isEditingAddress = false;
      _editingIndex = null;
      _postalCodeError = null;
      _hasChanges = false;
    });
  }

  // デフォルトの配送先
  Future<void> _setDefaultAddress(int index) async {
    setState(() {
      _defaultAddressIndex = index;
    });
    await _saveAddressesToFirestore();
    _showBannerMessage('デフォルトの配送先に指定しました');
  }

  // 削除
  Future<void> _deleteAddress(int index) async {
    setState(() {
      _addresses.removeAt(index);
      if (_defaultAddressIndex != null) {
        if (index == _defaultAddressIndex) {
          _defaultAddressIndex = _addresses.isNotEmpty ? 0 : null;
        } else if (index < _defaultAddressIndex!) {
          _defaultAddressIndex = _defaultAddressIndex! - 1;
        }
      }
    });
    await _saveAddressesToFirestore();
    _showBannerMessage('配送先を削除しました');
  }

  @override
  Widget build(BuildContext context) {
    // アプリバーの色などは AppBar のプロパティで変更可能
    return Scaffold(
      bottomNavigationBar: wrapWithModel(
        model: _model.navBar12Model,
        updateCallback: () => setState(() {}),
        child: const NavBar12Widget(),
      ),
      appBar: AppBar(
        title: Text(
          '配送先の変更',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Inter',
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w500,
              ),
        ),
        backgroundColor: Colors.white, // ←ヘッダー背景色
        foregroundColor: Colors.black, // ←ヘッダーテキスト色
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Stack(
        children: [
          // メイン領域
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (_addresses.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _addresses.length,
                    itemBuilder: (context, index) {
                      final addr = _addresses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                addr['address'] ?? '',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                  '名前: ${addr['name']}\nメール: ${addr['email']}\n電話: ${addr['phone']}'),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // 住所を編集ボタンの色などはこちらで変更
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white, // 背景色
                                      foregroundColor: Colors.black, // テキスト色
                                    ),
                                    onPressed: () =>
                                        _startEditAddress(index: index),
                                    child: const Text('住所を編集'),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: FlutterFlowTheme.of(context)
                                            .furugiMainColor),
                                    onPressed: () => _deleteAddress(index),
                                  ),
                                ],
                              ),
                              if (_defaultAddressIndex != index)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => _setDefaultAddress(index),
                                    child: const Text('デフォルトの配送先に指定'),
                                  ),
                                )
                              else
                                const Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('【既定の配送先】'),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else
                  const Text('配送先が登録されていません'),
                const SizedBox(height: 20.0),
                if (!_isEditingAddress)
                  FFButtonWidget(
                    onPressed: () => _startEditAddress(index: null),
                    text: '新しい配送先を追加',
                    options: FFButtonOptions(
                      height: 40,
                      // ボタンのバックグラウンド色
                      color: FlutterFlowTheme.of(context).furugiMainColor,
                      // ボタンテキスト色
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                              ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                const SizedBox(height: 120.0), // フッター部分の余白
              ],
            ),
          ),
          // 画面下部に「編集・追加」フォームを固定表示
          if (_isEditingAddress)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF7F7F7),
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  onChanged: _onFieldChanged,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _editingIndex == null ? '新しい配送先' : '配送先を編集',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Inter',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: '名前'),
                        validator: (val) =>
                            (val == null || val.isEmpty) ? '名前を入力してください' : null,
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'メールアドレス'),
                        validator: (val) => (val == null || val.isEmpty)
                            ? 'メールアドレスを入力してください'
                            : null,
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: '電話番号'),
                        keyboardType: TextInputType.phone,
                        validator: (val) => (val == null || val.isEmpty)
                            ? '電話番号を入力してください'
                            : null,
                      ),
                      const SizedBox(height: 8.0),
                      // 郵便番号検索
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _postalCodeController,
                              decoration: const InputDecoration(
                                labelText: '郵便番号 (7桁)',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(7),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          FFButtonWidget(
                            onPressed: _searchPostalCode,
                            text: '検索',
                            options: FFButtonOptions(
                              height: 40,
                              color:
                                  FlutterFlowTheme.of(context).furugiMainColor,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                  ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                      if (_postalCodeError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(_postalCodeError!,
                              style: const TextStyle(color: Colors.red)),
                        ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _prefectureController,
                        decoration: const InputDecoration(labelText: '都道府県'),
                        validator: (val) => (val == null || val.isEmpty)
                            ? '都道府県を入力してください'
                            : null,
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _detailController,
                        decoration: const InputDecoration(labelText: '住所詳細'),
                        maxLines: 2,
                        validator: (val) =>
                            (val == null || val.isEmpty) ? '住所を入力してください' : null,
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _cancelEditAddress,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red, // キャンセルボタン色
                            ),
                            child: const Text('キャンセル'),
                          ),
                          // 保存ボタン
                          ElevatedButton(
                            onPressed: _hasChanges ? _saveAddress : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _hasChanges
                                  ? FlutterFlowTheme.of(context)
                                      .furugiMainColor // 有効時の背景色
                                  : Colors.grey.shade400, // 無効時の背景色
                              foregroundColor: Colors.white, // テキスト色
                            ),
                            child: const Text('保存'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // バナーフェードアニメーション
          if (_bannerMessage != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: _bannerAnimCtrl,
                builder: (context, child) {
                  return Opacity(
                    opacity: _bannerOpacity.value,
                    child: child,
                  );
                },
                child: Container(
                  width: double.infinity,
                  color: Colors.black87, // バナーの背景色
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _bannerMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
