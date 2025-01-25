import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'products_model.dart';
export 'products_model.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({
    Key? key,
    this.categoryrRef,
  }) : super(key: key);

  final DocumentReference? categoryrRef;

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  late ProductsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductsModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. もしログイン必須ならここでチェック
    //    Firestore ルールで request.auth != null が必要な場合は必須
    if (currentUser == null) {
      return const Center(
        child: Text("ログインが必要です"),
      );
    }

    // カテゴリーと検索ワード（FFAppStateに保存されている想定）
    final selectedCategory = FFAppState().category; // 文字列
    final searchText = FFAppState().search; // 検索ワード

    context.watch<FFAppState>(); // FFAppState の変更監視

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SingleChildScrollView(
          // 親が SingleChildScrollView のため MasonryGridView で shrinkWrap など調整必須
          child: Column(
            children: [
              // ---------- ヘッダー ----------
              wrapWithModel(
                model: _model.headerModel,
                updateCallback: () => setState(() {}),
                child: const HeaderWidget(),
              ),

              // ---------- 検索バー ----------
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.9,
                        height: 38.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: const Color(0xFFF2F2F2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    11, 0, 0, 0),
                                child: TextFormField(
                                  controller: _model.textController,
                                  focusNode: _model.textFieldFocusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Search products',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          color: const Color(0xFFA7A5A5),
                                        ),
                                    border: InputBorder.none,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                            ),
                            // 検索ボタン
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 8.0,
                              buttonSize: 40.0,
                              fillColor: FlutterFlowTheme.of(context).primary,
                              icon: Icon(
                                Icons.search,
                                color: FlutterFlowTheme.of(context).info,
                                size: 24.0,
                              ),
                              onPressed: () {
                                // 入力された検索ワードを FFAppState に保存
                                FFAppState().search =
                                    _model.textController.text;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ].divide(const SizedBox(height: 25.0)),
                  ),
                ),
              ),

              // ---------- 商品一覧 (StreamBuilder) ----------
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: StreamBuilder<List<ProductsRecord>>(
                  stream: queryProductsRecord(
                    queryBuilder: (productsRecord) {
                      var q = productsRecord;

                      // カテゴリー絞り込み
                      if (selectedCategory != null &&
                          selectedCategory.isNotEmpty) {
                        // category フィールドが文字列の場合
                        q = q.where('category', isEqualTo: selectedCategory);
                      }

                      // 検索ワード (前方一致の例)
                      if (searchText != null && searchText.isNotEmpty) {
                        q = q
                            .where('name', isGreaterThanOrEqualTo: searchText)
                            .where('name', isLessThan: searchText + '\uf8ff');
                      }

                      return q;
                    },
                  ),
                  builder: (context, snapshot) {
                    // A. Firestore接続待ち
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    // B. エラー発生時
                    if (snapshot.hasError) {
                      // Firestoreルール or インデックス不足などの可能性
                      return Center(
                        child: Text(
                          'エラーが発生しました: ${snapshot.error}',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      );
                    }

                    // C. データがまだ無い
                    if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    // D. クエリ結果あり
                    final productsList = snapshot.data!;
                    if (productsList.isEmpty) {
                      // 0件のとき
                      return const SizedBox(
                        height: 300,
                        child: Center(
                          child: Text('該当する商品はありません'),
                        ),
                      );
                    }

                    // 1件以上ある場合 → 件数表示 + MasonryGrid
                    final count = productsList.length;

                    return Column(
                      children: [
                        // ヒット件数
                        Text(
                          '検索結果：$count 件ヒットしました',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 14.0,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        // MasonryGridView
                        SizedBox(
                          height: 600, // 適度な固定高さ
                          child: MasonryGridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: productsList.length,
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            itemBuilder: (context, index) {
                              final product = productsList[index];

                              return InkWell(
                                onTap: () {
                                  context.pushNamed(
                                    'ProductScreen',
                                    queryParameters: {
                                      'productInfo': serializeParam(
                                        product.reference,
                                        ParamType.DocumentReference,
                                      ),
                                    }.withoutNulls,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  child: Column(
                                    children: [
                                      // 商品画像
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          product.images.isNotEmpty
                                              ? product.images.first
                                              : 'https://via.placeholder.com/150',
                                          width: 130.0,
                                          height: 170.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // 商品名 + いいねボタン
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product.name,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Inter',
                                                        fontSize: 15.0,
                                                      ),
                                            ),
                                          ),
                                          // いいね (ToggleIcon)
                                          ToggleIcon(
                                            onPressed: () async {
                                              final currentUserRef =
                                                  currentUserReference;
                                              final isLiked = product.like
                                                  .contains(currentUserRef);
                                              final updateVal = isLiked
                                                  ? FieldValue.arrayRemove(
                                                      [currentUserRef],
                                                    )
                                                  : FieldValue.arrayUnion(
                                                      [currentUserRef],
                                                    );
                                              await product.reference.update({
                                                'like': updateVal,
                                              });
                                            },
                                            value: product.like
                                                .contains(currentUserReference),
                                            onIcon: Icon(
                                              Icons.favorite,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                            offIcon: Icon(
                                              Icons.favorite_border,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // 他のフィールドなどは省略
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // ---------- 戻るボタン ----------
              FFButtonWidget(
                onPressed: () {
                  context.safePop();
                },
                text: 'Button',
                options: FFButtonOptions(
                  height: 40,
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
