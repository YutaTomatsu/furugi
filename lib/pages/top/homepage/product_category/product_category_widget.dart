import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'product_category_model.dart';
export 'product_category_model.dart';

class ProductCategoryWidget extends StatefulWidget {
  const ProductCategoryWidget({super.key});

  @override
  State<ProductCategoryWidget> createState() => _ProductCategoryWidgetState();
}

class _ProductCategoryWidgetState extends State<ProductCategoryWidget> {
  late ProductCategoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductCategoryModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// サブカテゴリーがあるかどうかをチェックして
  /// もしあれば _SubCategorySelectionPage へ遷移し、選択された文字列を返す
  Future<String?> _navigateToSubCategory(
    BuildContext context,
    DocumentReference categoryRef,
  ) async {
    final subCollectionRef = categoryRef.collection('sub_collections');
    final subCollectionSnapshot = await subCollectionRef.limit(1).get();

    if (subCollectionSnapshot.docs.isNotEmpty) {
      // サブカテゴリー選択画面へ遷移
      final selectedCategory = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => _SubCategorySelectionPage(
            parentCategoryRef: categoryRef,
          ),
        ),
      );
      return selectedCategory;
    } else {
      // サブコレクションがなければ null を返す（呼び出し元で直接 pushNamed へ）
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'カテゴリーから探す',
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: 'Readex Pro',
                  fontSize: 20.0,
                ),
          ),
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // タイトルなど（任意）
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'メインカテゴリーを選択してください',
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                          fontFamily: 'Inter',
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ),
              // メインカテゴリー一覧
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: StreamBuilder<List<CategoriesRecord>>(
                  stream: queryCategoriesRecord(
                      // queryBuilder: (c) => c.orderBy('sort_no'),  // 必要に応じて
                      ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final categoriesList = snapshot.data!;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      shrinkWrap: true,
                      itemCount: categoriesList.length,
                      itemBuilder: (context, index) {
                        final categoryRecord = categoriesList[index];
                        return Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              16, 0, 16, 8),
                          child: InkWell(
                            onTap: () async {
                              // カテゴリー名を保存
                              FFAppState().category =
                                  categoryRecord.categoryName;
                              setState(() {});

                              // サブカテゴリーがあるかどうかチェック
                              final selectedSubCategoryOrNull =
                                  await _navigateToSubCategory(
                                context,
                                categoryRecord.reference,
                              );

                              // サブカテゴリーが選択された場合は上書き
                              if (selectedSubCategoryOrNull != null) {
                                FFAppState().category =
                                    selectedSubCategoryOrNull;
                              }

                              // 絞り込みページへ
                              context.pushNamed(
                                'Products',
                                queryParameters: {
                                  'categoryrRef': serializeParam(
                                    categoryRecord.reference,
                                    ParamType.DocumentReference,
                                  ),
                                }.withoutNulls,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 3.0,
                                    color: Color(0x411D2429),
                                    offset: Offset(0, 1),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // 画像（サンプル）
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: Image.network(
                                        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c'
                                        '?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8'
                                        '&auto=format&fit=crop&w=1760&q=80',
                                        width: 60.0,
                                        height: 60.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // カテゴリー名
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8.0, 8.0, 4.0, 0.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              categoryRecord.categoryName,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // →
                                    const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 4, 0, 0),
                                      child: Icon(
                                        Icons.chevron_right_rounded,
                                        color: Color(0xFF57636C),
                                        size: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// サブカテゴリー選択ページ
class _SubCategorySelectionPage extends StatefulWidget {
  final DocumentReference parentCategoryRef;

  const _SubCategorySelectionPage({
    Key? key,
    required this.parentCategoryRef,
  }) : super(key: key);

  @override
  State<_SubCategorySelectionPage> createState() =>
      __SubCategorySelectionPageState();
}

class __SubCategorySelectionPageState extends State<_SubCategorySelectionPage> {
  @override
  Widget build(BuildContext context) {
    final subCollectionRef =
        widget.parentCategoryRef.collection('sub_collections');

    return Scaffold(
      appBar: AppBar(
        title: const Text('サブカテゴリーを選択'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: subCollectionRef.orderBy('sort_no').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            );
          }
          final subCategories = snapshot.data!.docs;

          return ListView.builder(
            itemCount: subCategories.length,
            itemBuilder: (context, index) {
              final subCategoryDoc = subCategories[index];
              final subCategoryName =
                  subCategoryDoc['category_name'] as String?;

              return Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 8.0),
                child: InkWell(
                  onTap: () async {
                    // 次の階層があるかどうか
                    final nextSubRef =
                        subCategoryDoc.reference.collection('sub_collections');
                    final nextSubSnap = await nextSubRef.limit(1).get();

                    if (nextSubSnap.docs.isNotEmpty) {
                      // さらに下位のサブカテゴリーがあるので潜る
                      final selectedCategory = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _SubCategorySelectionPage(
                            parentCategoryRef: subCategoryDoc.reference,
                          ),
                        ),
                      );
                      if (selectedCategory != null) {
                        Navigator.pop(context, selectedCategory);
                      }
                    } else {
                      // 下位がない→自分のカテゴリー名を返す
                      Navigator.pop(context, subCategoryName);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Color(0x411D2429),
                          offset: Offset(0, 1),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // サブカテゴリ用の画像（今回も共通のサンプル画像）
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1546069901-ba9599a7e63c'
                              '?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8'
                              '&auto=format&fit=crop&w=1760&q=80',
                              width: 60.0,
                              height: 60.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // サブカテゴリー名
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 8, 4, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subCategoryName ?? '',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // →
                          const Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF57636C),
                              size: 24.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
