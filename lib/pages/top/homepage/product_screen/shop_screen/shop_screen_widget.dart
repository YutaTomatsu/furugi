import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/header_widget.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'shop_screen_model.dart';
export 'shop_screen_model.dart';

class ShopScreenWidget extends StatefulWidget {
  const ShopScreenWidget({
    Key? key,
    required this.shopRef,
  }) : super(key: key);

  final DocumentReference? shopRef;

  @override
  State<ShopScreenWidget> createState() => _ShopScreenWidgetState();
}

class _ShopScreenWidgetState extends State<ShopScreenWidget> {
  late ShopScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShopScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ShopsRecord>(
      stream: ShopsRecord.getDocument(widget.shopRef!),
      builder: (context, snapshot) {
        // ローディング中の表示
        if (!snapshot.hasData) {
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

        // 実際の店舗データ
        final shopRecord = snapshot.data!;

        return Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: Stack(
            children: [
              // ===== メインコンテンツ部分 =====
              SingleChildScrollView(
                child: Column(
                  children: [
                    // ヘッダー
                    wrapWithModel(
                      model: _model.headerModel,
                      updateCallback: () => setState(() {}),
                      child: const HeaderWidget(),
                    ),

                    // 本文
                    _buildShopContent(shopRecord),
                  ],
                ),
              ),

              // ===== いいね(ToggleIcon)などアクションバー =====
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildLikeToggle(shopRecord),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ショップの画像・情報をまとめたウィジェット
  Widget _buildShopContent(ShopsRecord shopRecord) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 戻るボタン
          const SizedBox(height: 8),
          Row(
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
          const SizedBox(height: 16),

          // カルーセル画像
          _buildImageCarousel(shopRecord),

          const SizedBox(height: 16),

          // ショップ名、特徴、HP
          _buildShopHeaderInfo(shopRecord),

          // グレー背景で住所や電話番号など複数情報をまとめる
          const SizedBox(height: 16),
          _buildShopDetailsSection(shopRecord),

          // マップ表示
          const SizedBox(height: 16),
          _buildMapSection(shopRecord),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// 店舗画像カルーセル
  Widget _buildImageCarousel(ShopsRecord shopRecord) {
    final maxImages =
        shopRecord.images.length > 10 ? 10 : shopRecord.images.length;

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _model.pageViewController ??=
                PageController(initialPage: 0),
            itemCount: maxImages,
            itemBuilder: (context, index) {
              final imageUrl = shopRecord.images[index];
              return InkWell(
                onTap: () async {
                  // 画像をタップしたら拡大表示
                  await Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: FlutterFlowExpandedImageView(
                        image: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                        allowRotation: false,
                        tag: imageUrl,
                        useHeroAnimation: true,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'shop_${shopRecord.reference.id}_$index',
                  transitionOnUserGestures: true,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 店舗名・特徴・HPなどのざっくり紹介
  Widget _buildShopHeaderInfo(ShopsRecord shopRecord) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          shopRecord.name,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Inter',
                color: const Color(0xFF4E97A7),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 5),
        // 特徴
        if (shopRecord.features.isNotEmpty)
          Text(
            shopRecord.features,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: const Color(0xFF666666),
                  fontSize: 12,
                ),
          ),
        const SizedBox(height: 5),
        // HP
        Text(
          shopRecord.hp.isNotEmpty ? shopRecord.hp : 'No Website',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Plus Jakarta Sans',
                color: const Color(0xFF333333),
                fontSize: 14,
              ),
        ),
      ],
    );
  }

  /// 住所/電話/郵便番号などをまとめたセクション
  Widget _buildShopDetailsSection(ShopsRecord shopRecord) {
    // shop_register_confirm_widget.dart で登録されているデータ例:
    // postalCode, prefecture, address, tel, priceRange, payment, closedDays, genders, parking etc.
    // ここで全て表示できるように
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA), // 薄い背景色を付けて区切る例
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildDetailRow('郵便番号', shopRecord.post),
          _buildDetailRow('都道府県', shopRecord.prefecture),
          _buildDetailRow('住所', shopRecord.address),
          _buildDetailRow('価格帯', shopRecord.priceRange),
          if (shopRecord.payment.isNotEmpty)
            _buildDetailRow(
              '支払い方法',
              shopRecord.payment.join(', '),
            ),
          if (shopRecord.closedDay.isNotEmpty)
            _buildDetailRow(
              '定休日',
              shopRecord.closedDay.join(', '),
            ),
          if (shopRecord.genders.isNotEmpty)
            _buildDetailRow(
              'ジェンダー',
              shopRecord.genders.join(', '),
            ),
          if (shopRecord.parking.isNotEmpty)
            _buildDetailRow(
              '駐車場',
              shopRecord.parking.join(', '),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Google Map のセクション
  Widget _buildMapSection(ShopsRecord shopRecord) {
    if (shopRecord.location == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '店舗の場所',
            style: FlutterFlowTheme.of(context).titleMedium,
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: FlutterFlowGoogleMap(
              controller: _model.googleMapsController,
              onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
              initialLocation: _model.googleMapsCenter ??= shopRecord.location!,
              markers: [
                FlutterFlowMarker(
                    shopRecord.reference.path, shopRecord.location!),
              ],
              markerColor: GoogleMarkerColor.violet,
              mapType: MapType.normal,
              style: GoogleMapStyle.standard,
              initialZoom: 14,
              allowInteraction: true,
              allowZoom: true,
              showZoomControls: true,
              showLocation: true,
              showCompass: false,
              showMapToolbar: false,
              showTraffic: false,
              centerMapOnMarkerTap: true,
            ),
          ),
        ],
      ),
    );
  }

  /// いいね(ToggleIcon) 表示
  Widget _buildLikeToggle(ShopsRecord shopRecord) {
    return Container(
      width: 48,
      height: 42,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryText,
        ),
      ),
      child: Center(
        child: ToggleIcon(
          onPressed: () async {
            final likeElement = currentUserReference;
            final likeUpdate = shopRecord.like.contains(likeElement)
                ? FieldValue.arrayRemove([likeElement])
                : FieldValue.arrayUnion([likeElement]);

            await shopRecord.reference.update(
              mapToFirestore({'like': likeUpdate}),
            );
            setState(() {});
          },
          value: shopRecord.like.contains(currentUserReference),
          onIcon: Icon(
            Icons.favorite_border,
            color: FlutterFlowTheme.of(context).error,
            size: 25,
          ),
          offIcon: Icon(
            Icons.favorite,
            color: FlutterFlowTheme.of(context).error,
            size: 25,
          ),
        ),
      ),
    );
  }
}
