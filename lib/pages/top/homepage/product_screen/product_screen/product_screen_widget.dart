import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/header_widget.dart';
import '/components/nav_bar12_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'product_screen_model.dart';
export 'product_screen_model.dart';

class ProductScreenWidget extends StatefulWidget {
  const ProductScreenWidget({
    Key? key,
    required this.productInfo,
  }) : super(key: key);

  final DocumentReference? productInfo;

  @override
  State<ProductScreenWidget> createState() => _ProductScreenWidgetState();
}

class _ProductScreenWidgetState extends State<ProductScreenWidget> {
  late ProductScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PageController? _pageController; // 画像カルーセル用コントローラー

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductScreenModel());

    // 2枚以上の画像がある場合に、2枚目がちらっと見えるようにするため
    // viewportFractionを設定したPageControllerを用意
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _model.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProductsRecord>(
      stream: ProductsRecord.getDocument(widget.productInfo!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // ローディング中の表示
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        final productRecord = snapshot.data!;
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Stack(
              children: [
                // ===== コンテンツ部分 =====
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // ヘッダー
                      wrapWithModel(
                        model: _model.headerModel,
                        updateCallback: () => setState(() {}),
                        child: const HeaderWidget(),
                      ),
                      // 戻るボタン & カルーセル画像
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        child: _buildTopSection(productRecord),
                      ),
                      // 商品説明
                      _buildDescriptionSection(productRecord),
                      // サイズ・配送情報
                      _buildDetailAttributes(productRecord),
                      // 出品者情報
                      _buildUserSection(productRecord),
                      // コメント一覧とコメントボタン
                      _buildCommentsSection(productRecord),
                      const SizedBox(height: 150), // 最下部の余白
                    ],
                  ),
                ),
                // ===== 画面下部のアクションボタン =====
                Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: Padding(
                    // ナビゲーションバーと重ならないようにマージン
                    padding: const EdgeInsets.only(bottom: 75),
                    child: _buildBottomActionBar(context, productRecord),
                  ),
                ),
                // ===== 共通ナビゲーションバー =====
                Align(
                  alignment: const AlignmentDirectional(0, 1),
                  child: wrapWithModel(
                    model: _model.navBar12Model,
                    updateCallback: () => setState(() {}),
                    child: const NavBar12Widget(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 戻るボタン + 画像カルーセル + 商品名/価格
  Widget _buildTopSection(ProductsRecord productRecord) {
    final images = productRecord.images;
    final imagesCount = images.length;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // 戻るボタン
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => context.pop(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/Action_Icon.png',
                      width: 34,
                      height: 34,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 画像表示: 1枚 or 2枚以上
          if (imagesCount == 1)
            // ▼ 画像が1枚の場合（カルーセルは表示しない）
            Container(
              width: MediaQuery.sizeOf(context).width * 0.9,
              height: 300, // 画像を少し小さめに
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  images.first,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            // ▼ 画像が2枚以上の場合
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.9,
              height: 300, // 画像を少し小さめに
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    children: images.map((imageUrl) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  // カルーセル下のページインジケータ
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: smooth_page_indicator.SmoothPageIndicator(
                        controller: _pageController!,
                        count: imagesCount,
                        axisDirection: Axis.horizontal,
                        onDotClicked: (i) async {
                          await _pageController!.animateToPage(
                            i,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                          setState(() {});
                        },
                        effect: smooth_page_indicator.SlideEffect(
                          spacing: 8,
                          radius: 8,
                          dotWidth: 8,
                          dotHeight: 8,
                          dotColor: FlutterFlowTheme.of(context).accent1,
                          activeDotColor: FlutterFlowTheme.of(context).primary,
                          paintStyle: PaintingStyle.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // 商品名と価格 (左揃え)
          Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productRecord.name,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: const Color(0xFF4E97A7),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '¥${productRecord.price}',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: const Color(0xFF333333),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 商品の説明
  Widget _buildDescriptionSection(ProductsRecord productRecord) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 左揃え
          children: [
            Text(
              '商品の説明',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              productRecord.detail,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: const Color(0xFF555555),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// サイズ / 配送日数 / 送料負担 / 配送元地域
  Widget _buildDetailAttributes(ProductsRecord productRecord) {
    // セクションをまとめて少し背景色を付与
    return Container(
      color: const Color(0xFFF9FAFB), // 薄いグレー色
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          _buildRowAttribute('サイズ', productRecord.size),
          _buildRowAttribute('配送までの日数', productRecord.shippingDays),
          _buildRowAttribute('発送料の負担', productRecord.shippingCost),
          _buildRowAttribute('配送元地域', productRecord.prefecture),
        ],
      ),
    );
  }

  Widget _buildRowAttribute(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
          Text(
            value,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }

  /// 出品者情報
  Widget _buildUserSection(ProductsRecord productRecord) {
    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(productRecord.parentReference),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('ユーザー情報の取得でエラーが発生しました'));
        }
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        final userRecord = snapshot.data!;
        return InkWell(
          onTap: () {
            // 出品者ならProfile、他人ならUserProfileへ遷移
            if (userRecord.reference == currentUserReference) {
              context.pushNamed('Profile');
            } else {
              context.pushNamed(
                'UserProfile',
                queryParameters: {
                  'userRef': serializeParam(
                    userRecord.reference,
                    ParamType.DocumentReference,
                  ),
                }.withoutNulls,
              );
            }
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.only(top: 16, bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 左: アイコン + 名前
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        userRecord.image.isNotEmpty
                            ? userRecord.image
                            : 'https://firebasestorage.googleapis.com/v0/b/furugi-with-template-40pf0j.appspot.com/o/users%2Fdefault_image%2Fuser_no_image.png?alt=media&token=624ae0c5-c31b-4908-82e8-c79e0e996d7a',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      userRecord.displayName,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            letterSpacing: 0,
                          ),
                    ),
                  ],
                ),
                // 右: 矢印アイコン
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 8,
                  buttonSize: 40,
                  fillColor: FlutterFlowTheme.of(context).primary,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: FlutterFlowTheme.of(context).info,
                    size: 20,
                  ),
                  onPressed: () {
                    // 必要に応じて遷移等の動作を設定
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// コメント一覧 + コメントボタン
  Widget _buildCommentsSection(ProductsRecord productRecord) {
    return Column(
      children: [
        // コメント一覧
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: StreamBuilder<List<CommentsRecord>>(
            stream: queryCommentsRecord(
              queryBuilder: (commentsRecord) => commentsRecord
                  .where('product', isEqualTo: widget.productInfo)
                  .orderBy('time_stamp'),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                );
              }

              final comments = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final commentRecord = comments[index];
                  return _buildCommentItem(
                      context, commentRecord, productRecord);
                },
              );
            },
          ),
        ),
        // コメントするボタン
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: FFButtonWidget(
            onPressed: () {
              context.pushNamed(
                'Comment',
                queryParameters: {
                  'productInfo': serializeParam(
                    widget.productInfo,
                    ParamType.DocumentReference,
                  ),
                }.withoutNulls,
              );
            },
            text: 'コメントする',
            options: FFButtonOptions(
              width: MediaQuery.sizeOf(context).width,
              height: 40,
              color: FlutterFlowTheme.of(context).primary,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter',
                    color: const Color(0xFF507583),
                    fontWeight: FontWeight.w500,
                  ),
              elevation: 0,
              borderSide: const BorderSide(
                color: Color(0xFF507583),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  /// 個別コメント表示
  Widget _buildCommentItem(
    BuildContext context,
    CommentsRecord comment,
    ProductsRecord productRecord,
  ) {
    final isOwner = (comment.user == productRecord.parentReference);

    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(comment.user!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        final user = snapshot.data!;
        if (isOwner) {
          // ▼ 出品者コメント（右揃え）
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 名前 + アイコン (右)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      user.displayName,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(width: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        user.image.isNotEmpty
                            ? user.image
                            : 'https://firebasestorage.googleapis.com/v0/b/furugi-with-template-40pf0j.appspot.com/o/users%2Fdefault_image%2Fuser_no_image.png?alt=media&token=624ae0c5-c31b-4908-82e8-c79e0e996d7a',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                // コメント本文
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  child: Text(
                    comment.comment,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 16,
                        ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // ▼ 購入者 or 他ユーザーコメント（左揃え）
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // アイコン + 名前 (左)
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        user.image.isNotEmpty
                            ? user.image
                            : 'https://firebasestorage.googleapis.com/v0/b/furugi-with-template-40pf0j.appspot.com/o/users%2Fdefault_image%2Fuser_no_image.png?alt=media&token=624ae0c5-c31b-4908-82e8-c79e0e996d7a',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.displayName,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                // コメント本文
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  child: Text(
                    comment.comment,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 16,
                        ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  /// 画面下部のアクションバー
  Widget _buildBottomActionBar(BuildContext context, ProductsRecord product) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 66,
      color: FlutterFlowTheme.of(context).secondaryBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // お気に入りトグルボタン
          Container(
            width: 48,
            height: 42,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Center(
              child: ToggleIcon(
                onPressed: () async {
                  final likeElement = currentUserReference;
                  final likeUpdate = product.like.contains(likeElement)
                      ? FieldValue.arrayRemove([likeElement])
                      : FieldValue.arrayUnion([likeElement]);

                  await product.reference.update({
                    ...mapToFirestore({'like': likeUpdate}),
                  });
                  setState(() {});
                },
                value: product.like.contains(currentUserReference),
                onIcon: Icon(
                  Icons.favorite,
                  color: FlutterFlowTheme.of(context).like,
                  size: 25,
                ),
                offIcon: Icon(
                  Icons.favorite_border,
                  color: FlutterFlowTheme.of(context).unlike,
                  size: 25,
                ),
              ),
            ),
          ),
          // カートに入れるボタン
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.6,
            height: 42,
            child: FFButtonWidget(
              onPressed: () {
                FFAppState().addToCartItems(product.reference);
                FFAppState().cartSum = FFAppState().cartSum + product.price;
                FFAppState().productUser = product.parentReference;
                setState(() {});
                context.pushNamed('Cart');
              },
              text: 'カートに入れる',
              options: FFButtonOptions(
                height: 42,
                color: const Color(0xFF333333),
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                elevation: 3,
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
