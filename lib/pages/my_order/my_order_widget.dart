import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/header_widget.dart';
import '/components/nav_bar12_widget.dart';

class MyOrderWidget extends StatefulWidget {
  const MyOrderWidget({Key? key}) : super(key: key);

  @override
  State<MyOrderWidget> createState() => _MyOrderWidgetState();
}

class _MyOrderWidgetState extends State<MyOrderWidget> {
  late NavBar12Model _navBar12Model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _navBar12Model = createModel(context, () => NavBar12Model());
  }

  @override
  void dispose() {
    _navBar12Model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      bottomNavigationBar: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 2.0,
              color: Color(0x20000000),
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: wrapWithModel(
          model: _navBar12Model,
          updateCallback: () => setState(() {}),
          child: const NavBar12Widget(),
        ),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            // タイトルなどヘッダー部分
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    child: Image.asset(
                      'assets/images/Action_Icon.png',
                      width: 34,
                      height: 34,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '購入履歴',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 34),
                ],
              ),
            ),

            // 購入履歴リスト部分
            Expanded(
              child: StreamBuilder<List<PurchasesRecord>>(
                stream: queryPurchasesRecord(
                  queryBuilder: (purchasesQuery) => purchasesQuery
                      .where('user', isEqualTo: currentUserReference)
                      .orderBy('time_stamp', descending: true),
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final purchasesList = snapshot.data!;
                  if (purchasesList.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('まだ購入履歴がありません。'),
                    );
                  }

                  return ListView.builder(
                    itemCount: purchasesList.length,
                    itemBuilder: (context, index) {
                      final purchase = purchasesList[index];
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: const Color(0xFFF1F1F1),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Builder(builder: (context) {
                                    final productRefs =
                                        purchase.product.toList();
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: productRefs.length,
                                      itemBuilder: (context, productIndex) {
                                        final productRef =
                                            productRefs[productIndex];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: StreamBuilder<ProductsRecord>(
                                            stream: ProductsRecord.getDocument(
                                                productRef),
                                            builder: (context, productSnap) {
                                              if (!productSnap.hasData) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              final productRecord =
                                                  productSnap.data!;
                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.network(
                                                      productRecord
                                                              .images.isNotEmpty
                                                          ? productRecord
                                                              .images.first
                                                          : 'https://via.placeholder.com/150',
                                                      width: 70,
                                                      height: 70,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          productRecord.name,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Inter',
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          productRecord
                                                              .shippingDays,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: const Color(
                                                                    0xFF666666),
                                                                fontSize: 12,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'サイズ: ${productRecord.size}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium,
                                                            ),
                                                            Text(
                                                              '${productRecord.price} 円',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                  const Divider(
                                    color: Color(0xFFE8E8E8),
                                    thickness: 1,
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '合計金額',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                      Text('${purchase.price} 円'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '購入日時',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                      ),
                                      Text(
                                        dateTimeFormat(
                                          'yMMMd',
                                          purchase.timeStamp!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 10.0,
                            color: Color(0xFFF1F1F1),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
