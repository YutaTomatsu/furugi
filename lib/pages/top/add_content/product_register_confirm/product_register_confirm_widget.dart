import 'package:furugi_with_template/flutter_flow/nav/nav.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../components/header_default_widget';

class ProductRegisterConfirmWidget extends StatefulWidget {
  final Map<String, dynamic> productData;

  const ProductRegisterConfirmWidget({
    Key? key,
    required this.productData,
  }) : super(key: key);

  @override
  _ProductRegisterConfirmWidgetState createState() =>
      _ProductRegisterConfirmWidgetState();
}

class _ProductRegisterConfirmWidgetState
    extends State<ProductRegisterConfirmWidget> {
  bool isSubmitting = false;

  String get commission {
    final price = int.tryParse(widget.productData['price'] ?? '');
    if (price == null) return "-";
    final fee = (price * 0.1).floor();
    return "¥$fee";
  }

  String get profit {
    final price = int.tryParse(widget.productData['price'] ?? '');
    if (price == null) return "-";
    final fee = (price * 0.1).floor();
    final p = price - fee;
    return "¥$p";
  }

  @override
  Widget build(BuildContext context) {
    final productData = widget.productData;

    final priceStr = productData['price'];
    final priceDisp = (int.tryParse(priceStr ?? '') == null)
        ? "-"
        : "¥${productData['price']}";

    final commissionDisp =
        (int.tryParse(priceStr ?? '') == null) ? "-" : commission;
    final profitDisp = (int.tryParse(priceStr ?? '') == null) ? "-" : profit;

    return Scaffold(
      appBar: const HeaderDefaultWidget(
        title: '入力情報の確認',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isSubmitting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('商品名: ${productData['productName']}'),
                    const SizedBox(height: 8.0),
                    Text('商品詳細: ${productData['productDetail']}'),
                    const SizedBox(height: 8.0),
                    Text('カテゴリー: ${productData['category']}'),
                    const SizedBox(height: 8.0),
                    Text('商品の状態: ${productData['condition']}'),
                    const SizedBox(height: 8.0),
                    Text('サイズ: ${productData['size']}'),
                    const SizedBox(height: 8.0),
                    Text('発送までの日数: ${productData['shippingDays']}'),
                    const SizedBox(height: 8.0),
                    Text('発送元地域: ${productData['prefecture']}'),
                    const SizedBox(height: 8.0),
                    Text('発送料の負担: ${productData['shippingCost']}'),
                    const SizedBox(height: 8.0),
                    Text('価格: $priceDisp'),
                    const SizedBox(height: 8.0),
                    Text('販売手数料（10%）: $commissionDisp'),
                    const SizedBox(height: 8.0),
                    Text('販売利益: $profitDisp'),
                    const SizedBox(height: 8.0),
                    if (productData['imageUrls'] != null &&
                        productData['imageUrls'].isNotEmpty)
                      SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productData['imageUrls'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.network(
                                productData['imageUrls'][index],
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    FFButtonWidget(
                      onPressed: () async {
                        setState(() {
                          isSubmitting = true;
                        });

                        await ProductsRecord.createDoc(currentUserReference!)
                            .set({
                          ...createProductsRecordData(
                            name: productData['productName'],
                            price: int.tryParse(productData['price'] ?? ''),
                            detail: productData['productDetail'],
                            images: List<String>.from(
                                productData['imageUrls'] ?? []),
                            condition: productData['condition'],
                            size: productData['size'],
                            shippingDays: productData['shippingDays'],
                            prefecture: productData['prefecture'],
                            shippingCost: productData['shippingCost'],
                            category: productData['category'],
                          ),
                          ...mapToFirestore(
                            {
                              'created_time': FieldValue.serverTimestamp(),
                            },
                          ),
                        });

                        setState(() {
                          isSubmitting = false;
                        });

                        context.pushNamed('HomePage');
                      },
                      text: '出品する',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        color: const Color(0xFF507583),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                ),
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
