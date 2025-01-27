import 'package:flutter/material.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/nav_bar12_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'profile_model.dart';
export 'profile_model.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget>
    with TickerProviderStateMixin {
  late ProfileModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// アニメーションマップ
  final animationsMap = <String, AnimationInfo>{};

  /// /Users/xxx/products/yyy の xxx == currentUserReference.id かを判定
  bool _hasCurrentUserId(List<DocumentReference>? productRefs) {
    if (productRefs == null) return false;
    for (final ref in productRefs) {
      final segments = ref.path.split('/');
      if (segments.length > 1) {
        final userId = segments[1]; // "xxx"
        if (userId == currentUserReference?.id) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());

    // タブコントローラ
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() {
        setState(() {});
      });

    // アニメーションの登録
    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 80.ms,
            duration: 330.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.ms,
            duration: 210.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'rowOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 175.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 175.ms,
            duration: 600.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 175.ms,
            duration: 600.ms,
            begin: const Offset(0.0, 20.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.ms,
            duration: 600.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.ms,
            duration: 600.ms,
            begin: const Offset(0.0, 50.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.ms,
            duration: 600.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.ms,
            duration: 600.ms,
            begin: const Offset(0.0, 50.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// レビュー件数を取得するためのウィジェット
  Widget _buildTabBarWithReviewCount() {
    return StreamBuilder<List<ReviewsRecord>>(
      stream: queryReviewsRecord(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final allReviews = snapshot.data!;
        // ログインユーザーが出品した商品に対するレビュー
        final filteredReviews =
            allReviews.where((r) => _hasCurrentUserId(r.product)).toList();
        final reviewCount = filteredReviews.length;

        return FlutterFlowButtonTabBar(
          isScrollable: true,
          labelColor: FlutterFlowTheme.of(context).primaryText,
          unselectedLabelColor: FlutterFlowTheme.of(context).primaryText,
          borderColor: FlutterFlowTheme.of(context).primary,
          borderWidth: 2.0,
          borderRadius: 12.0,
          labelPadding: const EdgeInsetsDirectional.fromSTEB(25, 0, 25, 0),
          tabs: [
            const Tab(text: '出品中'),
            // レビュー件数を表示
            Tab(text: 'レビュー($reviewCount)'),
          ],
          controller: _model.tabBarController,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Profile',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Readex Pro',
                ),
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          constraints: const BoxConstraints(maxWidth: 1170.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // プロフィール (アイコン + ユーザー名 + レーティング)
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 8, 12, 8),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: AuthUserStreamWidget(
                                          builder: (context) => ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                            child: Image.network(
                                              valueOrDefault<String>(
                                                valueOrDefault(
                                                  currentUserDocument?.image,
                                                  '',
                                                ),
                                                'https://firebasestorage.googleapis.com/v0/b/furugi-with-template-40pf0j.appspot.com/o/users%2Fdefault_image%2Fuser_no_image.png?alt=media&token=624ae0c5-c31b-4908-82e8-c79e0e996d7a',
                                              ),
                                              width: 50.0,
                                              height: 50.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AuthUserStreamWidget(
                                              builder: (context) => Row(
                                                children: [
                                                  Text(
                                                    currentUserDisplayName,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .headlineLarge
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          fontSize: 20.0,
                                                        ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      context.pushNamed(
                                                          'Myaccount');
                                                    },
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                StreamBuilder<
                                                    List<ReviewsRecord>>(
                                                  stream: queryReviewsRecord(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                    final allReviews =
                                                        snapshot.data!;
                                                    // ログインユーザーが /Users/xxx/products の 'xxx' な商品に対するレビューだけ抽出
                                                    final filteredReviews =
                                                        allReviews.where((r) {
                                                      return _hasCurrentUserId(
                                                          r.product);
                                                    }).toList();
                                                    // レーティング平均
                                                    final double? ratingValue =
                                                        filteredReviews
                                                                .isNotEmpty
                                                            ? functions
                                                                .ratingAvarage(
                                                                filteredReviews
                                                                    .map((e) =>
                                                                        e.evaluation)
                                                                    .toList(),
                                                              )
                                                            : 0.0;
                                                    return RatingBarIndicator(
                                                      rating:
                                                          ratingValue ?? 0.0,
                                                      itemCount: 5,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              const Icon(
                                                        Icons.star_rounded,
                                                        color:
                                                            Color(0xFF4A9190),
                                                      ),
                                                      unratedColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent2,
                                                      itemSize: 20.0,
                                                    );
                                                  },
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          16, 4, 0, 0),
                                                  child: Text(
                                                    '240 Sales',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Inter',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ).animateOnPageLoad(
                                      animationsMap['rowOnPageLoadAnimation']!),
                                ),
                                // タブバー
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 12, 0, 0),
                                    child: Column(
                                      children: [
                                        if (_model.tabBarController != null)
                                          _buildTabBarWithReviewCount()
                                        else
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        if (_model.tabBarController != null)
                                          Expanded(
                                            child: TabBarView(
                                              controller:
                                                  _model.tabBarController,
                                              children: [
                                                // --- タブ1: 出品中 ---
                                                // purchases と products を両方取得し、sold 判定と画面遷移を行う
                                                StreamBuilder<
                                                    List<ProductsRecord>>(
                                                  stream: queryProductsRecord(
                                                    parent:
                                                        currentUserReference,
                                                  ),
                                                  builder: (context, snapProd) {
                                                    if (!snapProd.hasData) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                    final products =
                                                        snapProd.data!;
                                                    return StreamBuilder<
                                                        List<PurchasesRecord>>(
                                                      stream:
                                                          queryPurchasesRecord(),
                                                      builder:
                                                          (context, snapPurch) {
                                                        if (!snapPurch
                                                            .hasData) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }
                                                        final allPurchases =
                                                            snapPurch.data!;
                                                        return MasonryGridView
                                                            .builder(
                                                          gridDelegate:
                                                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 3,
                                                          ),
                                                          itemCount:
                                                              products.length,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final product =
                                                                products[index];
                                                            final imageUrl = (product
                                                                    .images
                                                                    .isNotEmpty)
                                                                ? product.images
                                                                    .first
                                                                : 'https://via.placeholder.com/300';

                                                            // sold 判定（該当商品のDocumentReferenceが購入済かどうか）
                                                            final isSold =
                                                                allPurchases
                                                                    .any(
                                                              (purchase) => purchase
                                                                  .product
                                                                  .contains(product
                                                                      .reference),
                                                            );

                                                            return InkWell(
                                                              onTap: () async {
                                                                // 商品詳細ページに遷移
                                                                context
                                                                    .pushNamed(
                                                                  'ProductScreen',
                                                                  queryParameters:
                                                                      {
                                                                    'productInfo':
                                                                        serializeParam(
                                                                      product
                                                                          .reference,
                                                                      ParamType
                                                                          .DocumentReference,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    width:
                                                                        200.0,
                                                                    margin: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        4,
                                                                        12,
                                                                        4,
                                                                        0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              2.0),
                                                                      child: Image
                                                                          .network(
                                                                        imageUrl,
                                                                        fit: BoxFit
                                                                            .fitWidth,
                                                                      ),
                                                                    ),
                                                                  ).animateOnPageLoad(
                                                                    animationsMap[
                                                                        'containerOnPageLoadAnimation1']!,
                                                                  ),
                                                                  if (isSold)
                                                                    Positioned(
                                                                      top: 12,
                                                                      right: 4,
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              6,
                                                                          vertical:
                                                                              2,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.red,
                                                                          borderRadius:
                                                                              BorderRadius.circular(0),
                                                                        ),
                                                                        child:
                                                                            const Text(
                                                                          'sold',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                                // --- タブ2: レビュー ---
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 12, 0, 0),
                                                  child: StreamBuilder<
                                                      List<ReviewsRecord>>(
                                                    // ここで全件取得
                                                    stream:
                                                        queryReviewsRecord(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }
                                                      // もとの listViewReviewsRecordList
                                                      var listViewReviewsRecordList =
                                                          snapshot.data!;

                                                      // ここで「product 内に /Users/xxx の xxx == currentUserId が含まれるか」フィルタ
                                                      listViewReviewsRecordList =
                                                          listViewReviewsRecordList
                                                              .where((review) =>
                                                                  _hasCurrentUserId(
                                                                      review
                                                                          .product))
                                                              .toList();

                                                      if (listViewReviewsRecordList
                                                          .isEmpty) {
                                                        return const Center(
                                                          child: Text(
                                                              'まだレビューはありません。'),
                                                        );
                                                      }

                                                      return ListView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        itemCount:
                                                            listViewReviewsRecordList
                                                                .length,
                                                        itemBuilder: (context,
                                                            listViewIndex) {
                                                          final listViewReviewsRecord =
                                                              listViewReviewsRecordList[
                                                                  listViewIndex];
                                                          if (listViewReviewsRecord
                                                                  .product ==
                                                              null) {
                                                            return const ListTile(
                                                              title: Text(
                                                                  '商品データなし'),
                                                            );
                                                          }
                                                          // product配列が空の場合の対策
                                                          if (listViewReviewsRecord
                                                              .product
                                                              .isEmpty) {
                                                            return const ListTile(
                                                              title: Text(
                                                                  '商品データなし'),
                                                            );
                                                          }
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        12.0),
                                                            child: FutureBuilder<
                                                                ProductsRecord>(
                                                              future: ProductsRecord
                                                                  .getDocumentOnce(
                                                                      listViewReviewsRecord
                                                                          .product
                                                                          .first),
                                                              builder: (context,
                                                                  snapProd) {
                                                                if (!snapProd
                                                                    .hasData) {
                                                                  return const SizedBox(
                                                                    height: 50,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          CircularProgressIndicator(),
                                                                    ),
                                                                  );
                                                                }
                                                                final product =
                                                                    snapProd
                                                                        .data!;
                                                                final imageUrl = (product
                                                                        .images
                                                                        .isNotEmpty)
                                                                    ? product
                                                                        .images
                                                                        .first
                                                                    : 'https://via.placeholder.com/300';

                                                                // ↓ レビューしたユーザー(投稿者)を取得してアイコン + 名前表示
                                                                return StreamBuilder<
                                                                    UsersRecord>(
                                                                  stream: UsersRecord
                                                                      .getDocument(
                                                                    listViewReviewsRecord
                                                                            .user ??
                                                                        currentUserReference!,
                                                                  ),
                                                                  builder: (
                                                                    context,
                                                                    userSnap,
                                                                  ) {
                                                                    if (!userSnap
                                                                        .hasData) {
                                                                      return const SizedBox(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              CircularProgressIndicator(),
                                                                        ),
                                                                      );
                                                                    }
                                                                    final userRecord =
                                                                        userSnap
                                                                            .data!;

                                                                    return Container(
                                                                      width: double
                                                                          .infinity,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        boxShadow: const [
                                                                          BoxShadow(
                                                                            blurRadius:
                                                                                2.0,
                                                                            color:
                                                                                Color(0x520E151B),
                                                                            offset:
                                                                                Offset(0, 1),
                                                                          )
                                                                        ],
                                                                        borderRadius:
                                                                            BorderRadius.circular(12.0),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            4.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    // ユーザー名＋アイコン
                                                                                    Row(
                                                                                      children: [
                                                                                        ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(100),
                                                                                          child: Image.network(
                                                                                            userRecord.image.isNotEmpty ? userRecord.image : 'https://firebasestorage.googleapis.com/v0/b/furugi-with-template-40pf0j.appspot.com/o/users%2Fdefault_image%2Fuser_no_image.png?alt=media&token=624ae0c5-c31b-4908-82e8-c79e0e996d7a',
                                                                                            width: 30,
                                                                                            height: 30,
                                                                                            fit: BoxFit.cover,
                                                                                          ),
                                                                                        ),
                                                                                        const SizedBox(width: 8),
                                                                                        Text(
                                                                                          userRecord.displayName,
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    // 商品名
                                                                                    Text(
                                                                                      product.name,
                                                                                      style: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                            fontFamily: 'Inter',
                                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                                            fontSize: 14.0,
                                                                                            letterSpacing: 0.0,
                                                                                          ),
                                                                                    ),
                                                                                    // 価格
                                                                                    Text(
                                                                                      product.price.toString(),
                                                                                      style: FlutterFlowTheme.of(context).labelMedium,
                                                                                    ),
                                                                                    const SizedBox(height: 8),
                                                                                    // 評価
                                                                                    Text(
                                                                                      '評価: ${listViewReviewsRecord.evaluation}',
                                                                                      style: FlutterFlowTheme.of(context).labelMedium,
                                                                                    ),
                                                                                    // コメント
                                                                                    Text(
                                                                                      'コメント: ${listViewReviewsRecord.review}',
                                                                                      style: FlutterFlowTheme.of(context).labelMedium,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                              child: Image.network(
                                                                                imageUrl,
                                                                                width: 80,
                                                                                height: 80,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ).animateOnPageLoad(
                                                                        animationsMap[
                                                                            'containerOnPageLoadAnimation2']!);
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        else
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ).animateOnPageLoad(animationsMap['columnOnPageLoadAnimation']!),
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: Container(
                  decoration: const BoxDecoration(),
                  child: wrapWithModel(
                    model: _model.navBar12Model,
                    updateCallback: () => setState(() {}),
                    child: const NavBar12Widget(),
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
