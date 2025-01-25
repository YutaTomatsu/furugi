import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/header_widget.dart';
// ▼▼▼ ナビゲーションバー用のWidgetをインポート（例: nav_bar12_widget.dart 等）
import '/components/nav_bar12_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
export 'cart_model.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({super.key});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  late CartModel _model;
  // ▼▼▼ ナビゲーションバーのためのModelを用意（NavBar12Widgetの例）
  late NavBar12Model _navBar12Model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CartModel());
    _navBar12Model = createModel(context, () => NavBar12Model());
  }

  @override
  void dispose() {
    _model.dispose();
    _navBar12Model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FFAppState の変更を監視する場合
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        // ▼▼▼ bottomNavigationBar は使わず、profile_widget.dart 同様に Stack で実現
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              // ---- ① メインのコンテンツを SingleChildScrollView + Column で構築 ----
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ヘッダー
                    wrapWithModel(
                      model: _model.headerModel,
                      updateCallback: () => setState(() {}),
                      child: const HeaderWidget(),
                    ),
                    // 中身
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // タイトル等 (「カート」を中央に)
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  0.0,
                                  0.0,
                                  10.0,
                                ),
                                child: Container(
                                  height: 38.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: InkWell(
                                          onTap: () async {
                                            context.pop();
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/Action_Icon.png',
                                              width: 34.0,
                                              height: 34.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'カート',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                fontSize: 16.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // カート一覧表示
                              Builder(
                                builder: (context) {
                                  final cartProductItems =
                                      FFAppState().cartItems.toList();
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: cartProductItems.length,
                                    itemBuilder:
                                        (context, cartProductItemsIndex) {
                                      final cartProductItemsItem =
                                          cartProductItems[
                                              cartProductItemsIndex];
                                      return Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(
                                          10.0,
                                          10.0,
                                          10.0,
                                          10.0,
                                        ),
                                        child: StreamBuilder<ProductsRecord>(
                                          stream: ProductsRecord.getDocument(
                                              cartProductItemsItem),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            final containerProductsRecord =
                                                snapshot.data!;
                                            return Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        1.0,
                                                    decoration:
                                                        const BoxDecoration(),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Image.network(
                                                            containerProductsRecord
                                                                .images.first,
                                                            width: 90.0,
                                                            height: 90.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 220.0,
                                                          decoration:
                                                              const BoxDecoration(),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                              10.0,
                                                              0.0,
                                                              0.0,
                                                              0.0,
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  containerProductsRecord
                                                                      .name,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Inter',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontSize:
                                                                            14.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                    0.0,
                                                                    10.0,
                                                                    0.0,
                                                                    10.0,
                                                                  ),
                                                                  child: Text(
                                                                    containerProductsRecord
                                                                        .shippingDays,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Inter',
                                                                          color:
                                                                              const Color(0xFF666666),
                                                                          fontSize:
                                                                              12.0,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'サイズ: ',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium,
                                                                    ),
                                                                    Text(
                                                                      containerProductsRecord
                                                                          .size,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Inter',
                                                                            color:
                                                                                Colors.black,
                                                                            letterSpacing:
                                                                                0.0,
                                                                          ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        containerProductsRecord
                                                                            .price
                                                                            .toString(),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Plus Jakarta Sans',
                                                                              color: Colors.black,
                                                                              fontSize: 16.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        FFAppState()
                                                                            .removeFromCartItems(
                                                                          containerProductsRecord
                                                                              .reference,
                                                                        );
                                                                        // カート合計の再計算
                                                                        FFAppState()
                                                                            .cartSum = FFAppState()
                                                                                .cartSum +
                                                                            functions.newCustomFunction(FFAppState().cartSum)!;
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        size:
                                                                            24.0,
                                                                      ),
                                                                    ),
                                                                  ].divide(
                                                                    const SizedBox(
                                                                        width:
                                                                            5.0),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ]
                                .divide(const SizedBox(height: 10.0))
                                .addToEnd(const SizedBox(height: 10.0)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 10.0, color: Color(0xFFF1F1F1)),
                    // 金額詳細
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      decoration: const BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '金額詳細',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Retail Price',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: const Color(0xFF555555),
                                      fontSize: 16.0,
                                    ),
                              ),
                              Text(
                                FFAppState().cartSum.toString(),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sale Price',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: const Color(0xFF555555),
                                      fontSize: 16.0,
                                    ),
                              ),
                              Text(
                                '£120', // 仮の値
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ],
                          ),
                        ].divide(const SizedBox(height: 10.0)),
                      ),
                    ),
                    Container(
                      height: 43.0,
                      color: const Color(0xFFEFF4FF),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text('合計金額'),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 10.0, 0.0),
                            child: Text(
                              FFAppState().cartSum.toString(),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 10.0, color: Color(0xFFF1F1F1)),
                    // Addressなど
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Address title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '配送先',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              InkWell(
                                onTap: () async {
                                  context.pushNamed('Editprofile');
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Edit',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            color: const Color(0xFFBDB5AC),
                                          ),
                                    ),
                                    const Icon(Icons.edit),
                                  ].divide(const SizedBox(width: 5.0)),
                                ),
                              ),
                            ],
                          ),
                          AuthUserStreamWidget(
                            builder: (context) => Text(
                              currentUserDisplayName,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          AuthUserStreamWidget(
                            builder: (context) => Text(
                              valueOrDefault(currentUserDocument?.address, ''),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: const Color(0xFF555555),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          AuthUserStreamWidget(
                            builder: (context) => Text(
                              currentPhoneNumber,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: const Color(0xFF555555),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ].divide(const SizedBox(height: 10.0)),
                      ),
                    ),
                  ].addToEnd(const SizedBox(height: 20.0)),
                ),
              ),
              // ---- ② 画面下部に「レジへ進む」ボタン + ナビゲーションバーを固定配置 ----
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: Container(
                  // お好みで色/デコレーションなど調整してください
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 2.0,
                        color: Color(0x20000000),
                        offset: Offset(0, -1),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ▼▼▼ 「レジへ進む」ボタン
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            // 1. カート商品データを作る
                            final cartData = <Map<String, dynamic>>[];
                            for (final productRef in FFAppState().cartItems) {
                              final docSnap =
                                  await ProductsRecord.getDocument(productRef)
                                      .first;
                              if (docSnap != null) {
                                cartData.add({
                                  'image': docSnap.images.first,
                                  'name': docSnap.name,
                                  'price': docSnap.price,
                                });
                              }
                            }

                            // 2. FFAppState に保存
                            FFAppState().paymentCartItems = cartData;
                            FFAppState().paymentTotalPrice =
                                FFAppState().cartSum;

                            // 3. Payment画面へ遷移
                            context.pushNamed('Payment');
                          },
                          text: 'レジへ進む',
                          options: FFButtonOptions(
                            height: 40.0,
                            color: const Color(0xFF333333),
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                ),
                            elevation: 3.0,
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      // ▼▼▼ ナビゲーションバー
                      wrapWithModel(
                        model: _navBar12Model,
                        updateCallback: () => setState(() {}),
                        child: const NavBar12Widget(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
