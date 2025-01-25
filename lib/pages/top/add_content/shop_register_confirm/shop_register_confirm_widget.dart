import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'shop_register_confirm_model.dart';
export 'shop_register_confirm_model.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;

class ShopRegisterConfirmWidget extends StatefulWidget {
  const ShopRegisterConfirmWidget({
    Key? key,
    required this.shopData,
  }) : super(key: key);

  final Map<String, dynamic> shopData;

  @override
  _ShopRegisterConfirmWidgetState createState() =>
      _ShopRegisterConfirmWidgetState();
}

class _ShopRegisterConfirmWidgetState extends State<ShopRegisterConfirmWidget> {
  late ShopRegisterConfirmModel _model;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShopRegisterConfirmModel());
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _model.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    final imageUrls = List<String>.from(widget.shopData['imageUrls'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('古着屋情報の確認'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 画像カルーセル
            if (imageUrls.isNotEmpty)
              SizedBox(
                height: 300,
                child: PageView(
                  controller: _pageController,
                  children: imageUrls.map((url) {
                    return Image.network(
                      url,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                ),
              ),

            // ページインジケータ
            if (imageUrls.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SmoothPageIndicator(
                  controller: _pageController!,
                  count: imageUrls.length,
                  effect: ScrollingDotsEffect(
                    activeDotColor: FlutterFlowTheme.of(context).primary,
                    dotColor: FlutterFlowTheme.of(context).secondaryText,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ),

            // 店名
            ListTile(
              title: const Text('店名'),
              subtitle: Text(widget.shopData['shopName'] ?? ''),
            ),

            // 郵便番号
            ListTile(
              title: const Text('郵便番号'),
              subtitle: Text(widget.shopData['postalCode'] ?? ''),
            ),

            // 都道府県
            ListTile(
              title: const Text('都道府県'),
              subtitle: Text(widget.shopData['prefecture'] ?? ''),
            ),

            // 住所
            ListTile(
              title: const Text('住所'),
              subtitle: Text(widget.shopData['address'] ?? ''),
            ),

            // 電話番号
            ListTile(
              title: const Text('電話番号'),
              subtitle: Text(widget.shopData['tel'] ?? ''),
            ),

            // HP
            ListTile(
              title: const Text('HP'),
              subtitle: Text(widget.shopData['hp'] ?? ''),
            ),

            // 価格帯(複数選択の可能性)
            ListTile(
              title: const Text('価格帯'),
              subtitle: Text(
                (widget.shopData['priceRange'] as List?)?.join(', ') ?? '',
              ),
            ),

            // 支払い方法
            ListTile(
              title: const Text('支払い方法'),
              subtitle: Text(
                (widget.shopData['payment'] as List?)?.join(', ') ?? '',
              ),
            ),

            // 定休日
            ListTile(
              title: const Text('定休日'),
              subtitle: Text(
                (widget.shopData['closedDays'] as List?)?.join(', ') ?? '',
              ),
            ),

            // ジェンダー
            ListTile(
              title: const Text('ジェンダー'),
              subtitle: Text(
                (widget.shopData['genders'] as List?)?.join(', ') ?? '',
              ),
            ),

            // 駐車場
            ListTile(
              title: const Text('駐車場'),
              subtitle: Text(
                (widget.shopData['parking'] as List?)?.join(', ') ?? '',
              ),
            ),

            // 特徴
            ListTile(
              title: const Text('特徴'),
              subtitle: Text(widget.shopData['features'] ?? ''),
            ),

            // ボタン: Firebaseに登録
            Padding(
              padding: const EdgeInsets.all(16),
              child: FFButtonWidget(
                onPressed: () async {
                  // 住所 → 緯度経度取得
                  final geocoding = await GoogleGeocodingAPICall.call(
                    address:
                        '${widget.shopData['prefecture']}${widget.shopData['address']}',
                  );

                  if ((geocoding.succeeded ?? true)) {
                    await ShopsRecord.collection.doc().set({
                      ...createShopsRecordData(
                        location: functions.formatLatLng(
                          getJsonField(geocoding.jsonBody,
                              r'''$.results[0].geometry.location.lat'''),
                          getJsonField(geocoding.jsonBody,
                              r'''$.results[0].geometry.location.lng'''),
                        ),
                        name: widget.shopData['shopName'],
                        address:
                            '${widget.shopData['prefecture']}${widget.shopData['address']}',
                        prefecture: widget.shopData['prefecture'],
                        post: widget.shopData['postalCode'],
                        features: widget.shopData['features'],
                        // priceRange はリストではなく string で保存したいならjoinする
                        // ここでは例として「複数選択を','連結」で保存
                        priceRange: (widget.shopData['priceRange'] as List?)
                            ?.join(', '),
                        hp: widget.shopData['hp'],
                        images: List<String>.from(
                            widget.shopData['imageUrls'] ?? []),
                      ),
                      // Firestoreに配列で保存
                      ...mapToFirestore({
                        'payment': widget.shopData['payment'],
                        'created_time': FieldValue.serverTimestamp(),
                        'closed_day': widget.shopData['closedDays'],
                        'genders': widget.shopData['genders'],
                        'parking': widget.shopData['parking'],
                      }),
                    });

                    // 登録後の画面遷移
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                text: '古着屋を登録する',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50,
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter',
                        color: Colors.black,
                      ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
