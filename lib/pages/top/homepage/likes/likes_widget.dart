import 'package:provider/provider.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/header_widget.dart';
import '/components/nav_bar12_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'likes_model.dart';
export 'likes_model.dart';

class LikesWidget extends StatefulWidget {
  const LikesWidget({super.key});

  @override
  State<LikesWidget> createState() => _LikesWidgetState();
}

class _LikesWidgetState extends State<LikesWidget>
    with TickerProviderStateMixin {
  late LikesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LikesModel());

    animationsMap.addAll({
      'listViewOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 80.0.ms,
            duration: 330.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 210.0.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        bottomNavigationBar: Consumer<NavBar12Model>(
          builder: (context, model, child) {
            return NavBar12Widget();
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.white, // ← ヘッダー背景色
          foregroundColor: Colors.black, // ← ヘッダーテキスト色
          elevation: 0,
          title: Text(
            'お気に入り',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            // ← 右側にアイコンを配置
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              onPressed: () {
                context.pushNamed('Cart'); // ← カート画面に遷移
              },
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              onPressed: () {
                context.pushNamed('Notification'); // ← お知らせ画面に遷移
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 850.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder<List<ProductsRecord>>(
                        stream: queryProductsRecord(
                          queryBuilder: (productsRecord) =>
                              productsRecord.where(
                            'like',
                            arrayContains: currentUserReference,
                          ),
                        ),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );
                          }
                          List<ProductsRecord> listViewProductsRecordList =
                              snapshot.data!;
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 20.0),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: listViewProductsRecordList.length,
                            itemBuilder: (context, listViewIndex) {
                              final listViewProductsRecord =
                                  listViewProductsRecordList[listViewIndex];
                              return Container(
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                decoration: const BoxDecoration(),
                                alignment: const AlignmentDirectional(.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  1.0,
                                          decoration: const BoxDecoration(),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(0.0),
                                                child: Image.network(
                                                  listViewProductsRecord
                                                      .images.first,
                                                  width: 100.0,
                                                  height: 100.0,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              Container(
                                                width: 220.0,
                                                decoration:
                                                    const BoxDecoration(),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      listViewProductsRecord
                                                          .name,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                    ),
                                                    Text(
                                                      'Size:${listViewProductsRecord.size}',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Inter',
                                                            letterSpacing: 0.0,
                                                          ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          listViewProductsRecord
                                                              .price
                                                              .toString(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Plus Jakarta Sans',
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                FFAppState().addToCartItems(
                                                                    listViewProductsRecord
                                                                        .reference);
                                                                FFAppState()
                                                                    .cartSum = FFAppState()
                                                                        .cartSum +
                                                                    listViewProductsRecord
                                                                        .price;
                                                                safeSetState(
                                                                    () {});

                                                                context
                                                                    .pushNamed(
                                                                        'Cart');
                                                              },
                                                              child: const Icon(
                                                                Icons
                                                                    .add_shopping_cart,
                                                                color: Color(
                                                                    0xFF333333),
                                                                size: 24.0,
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  const AlignmentDirectional(
                                                                      1.0, 0.0),
                                                              child: ToggleIcon(
                                                                onPressed:
                                                                    () async {
                                                                  final likeElement =
                                                                      currentUserReference;
                                                                  final likeUpdate = listViewProductsRecord
                                                                          .like
                                                                          .contains(
                                                                              likeElement)
                                                                      ? FieldValue
                                                                          .arrayRemove([
                                                                          likeElement
                                                                        ])
                                                                      : FieldValue
                                                                          .arrayUnion([
                                                                          likeElement
                                                                        ]);
                                                                  await listViewProductsRecord
                                                                      .reference
                                                                      .update({
                                                                    ...mapToFirestore(
                                                                      {
                                                                        'like':
                                                                            likeUpdate,
                                                                      },
                                                                    ),
                                                                  });
                                                                },
                                                                value: listViewProductsRecord
                                                                    .like
                                                                    .contains(
                                                                        currentUserReference),
                                                                onIcon: Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .like,
                                                                  size: 22.0,
                                                                ),
                                                                offIcon: Icon(
                                                                  Icons
                                                                      .favorite_border,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  size: 22.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ]
                                                      .divide(const SizedBox(
                                                          height: 5.0))
                                                      .addToStart(
                                                          const SizedBox(
                                                              height: 5.0)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]
                                          .divide(const SizedBox(height: 20.0))
                                          .addToEnd(
                                              const SizedBox(height: 10.0)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).animateOnPageLoad(
                              animationsMap['listViewOnPageLoadAnimation']!);
                        },
                      ),
                    ].addToEnd(const SizedBox(height: 10.0)),
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
