import 'dart:async'; // Completerを使うのに必要
import 'package:flutter/material.dart';
import 'package:furugi_with_template/pages/top/map/map_model.dart';
// FlutterFlow の LatLng は使わず、google_maps_flutter の LatLng を用いる。
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:provider/provider.dart';

import '/backend/backend.dart';
import '/components/nav_bar12_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late MapModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // 現在位置
  gmaps.LatLng? currentUserLocationValue;

  // GoogleMapControllerを管理するCompleter
  final Completer<gmaps.GoogleMapController> _mapControllerCompleter =
      Completer<gmaps.GoogleMapController>();

  // 検索フィールド
  final TextEditingController _searchController = TextEditingController();
  List<ShopsRecord> _searchResults = [];
  List<ShopsRecord> _allShops = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MapModel());

    // FlutterFlowの位置取得APIから座標をもらい、google_maps_flutterのLatLngに変換
    getCurrentUserLocation(
      defaultLocation: const LatLng(0.0, 0.0),
      cached: true,
    ).then((locFF) {
      // locFF は FlutterFlow の LatLng
      // google_maps_flutter の LatLng に変換
      final latLng = gmaps.LatLng(locFF.latitude, locFF.longitude);
      setState(() => currentUserLocationValue = latLng);
    });

    // 検索テキスト変更のたびに絞り込みを走らせる
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _model.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// 検索テキストが変化したときの処理
  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _searchResults.clear());
      return;
    }
    if (_allShops.isEmpty) return;

    setState(() {
      _searchResults = _allShops.where((shop) {
        final name = (shop.name ?? '').toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  /// ショップをマップ中心に移動
  Future<void> _moveMapToShop(ShopsRecord shop) async {
    if (shop.location == null) return;

    final googleMapController = await _mapControllerCompleter.future;
    final target = gmaps.LatLng(
      shop.location!.latitude,
      shop.location!.longitude,
    );

    await googleMapController.animateCamera(
      gmaps.CameraUpdate.newLatLng(target),
    );
  }

  /// マーカーが重なっているかの簡易判定
  bool _isOverlap(gmaps.LatLng a, gmaps.LatLng b, double threshold) {
    final latDiff = (a.latitude - b.latitude).abs();
    final lngDiff = (a.longitude - b.longitude).abs();
    return latDiff < threshold && lngDiff < threshold;
  }

  /// ShopsRecord リストから Marker セットを生成
  Set<gmaps.Marker> _buildMarkers(List<ShopsRecord> shops) {
    final markers = <gmaps.Marker>{};
    final usedPositions = <gmaps.LatLng>[];
    const overlapThreshold = 0.0006; // 座標の差がこれ以下なら重なりとみなす

    for (final shop in shops) {
      final location = shop.location;
      if (location == null) {
        continue; // locationがnullならスキップ
      }
      final gLocation = gmaps.LatLng(location.latitude, location.longitude);

      // 重なり判定
      final overlap = usedPositions
          .any((pos) => _isOverlap(pos, gLocation, overlapThreshold));
      usedPositions.add(gLocation);

      // 重なっていなければタイトルを表示、重なっていたらタイトル無し
      final infoWindow = overlap
          ? const gmaps.InfoWindow()
          : gmaps.InfoWindow(title: shop.name ?? '');

      markers.add(
        gmaps.Marker(
          markerId: gmaps.MarkerId(shop.reference.path), // 一意のID
          position: gLocation,
          infoWindow: infoWindow,
          onTap: () {
            // マーカーをタップしたらモーダルを開く
            _showShopBottomSheet(shop);
          },
        ),
      );
    }
    return markers;
  }

  /// マーカータップ時の処理
  Future<void> _showShopBottomSheet(ShopsRecord shop) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) => _ShopBottomSheet(shop: shop),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserLocationValue == null) {
      // 位置情報がまだ取得できていない場合のローディング
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
          ),
        ),
      );
    }

    // Firestore(ShopsRecord) から一覧を取得
    return StreamBuilder<List<ShopsRecord>>(
      stream: queryShopsRecord(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // ローディング
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }

        final shopList = snapshot.data!;
        _allShops = shopList;

        // マーカー生成
        final markers = _buildMarkers(shopList);

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          bottomNavigationBar: Consumer<NavBar12Model>(
            builder: (context, model, child) {
              return NavBar12Widget();
            },
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            // ---- タイトル部分を検索フィールドに置き換え ----
            title: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Container(
                height: 36, // 高さを低く設定
                decoration: BoxDecoration(
                  color: Colors.grey[150], // 背景色
                  borderRadius: BorderRadius.circular(8), // 角を丸く
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 10), // 高さ調整
                    hintText: 'ショップ検索',
                    border: InputBorder.none, // 枠線を消
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: true,
                    fillColor:
                        Colors.grey[150], // `Container` 側で背景を指定するので、ここは透明に

                    // クリアボタン
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color:
                                  FlutterFlowTheme.of(context).furugiMainColor,
                            ),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                  ),
                  style: const TextStyle(fontSize: 14), // 少し文字サイズ小さめに
                ),
              ),
            ),
            centerTitle: false, // 中央寄せを解除（お好みで調整）
            actions: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                onPressed: () {
                  context.pushNamed('Cart');
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
                onPressed: () {
                  context.pushNamed('Notification');
                },
              ),
            ],
          ),
          body: SafeArea(
            top: true,
            child: Column(
              children: [
                // ===== 検索結果候補 =====
                if (_searchResults.isNotEmpty)
                  Container(
                    color: Colors.white,
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final shop = _searchResults[index];
                        return ListTile(
                          title: Text(shop.name ?? ''),
                          subtitle: Text(
                            shop.address ?? '',
                            style: const TextStyle(fontSize: 12.0),
                          ),
                          onTap: () async {
                            // 該当ショップをマップ中央へ移動
                            await _moveMapToShop(shop);
                            // キーボード閉じ
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
                  ),

                // ===== マップの表示部分 =====
                Expanded(
                  child: gmaps.GoogleMap(
                    onMapCreated: (controller) {
                      if (!_mapControllerCompleter.isCompleted) {
                        _mapControllerCompleter.complete(controller);
                      }
                    },
                    // 現在地を中心にセット
                    initialCameraPosition: gmaps.CameraPosition(
                      target: currentUserLocationValue!,
                      zoom: 14.0,
                    ),
                    markers: markers,
                    // ズームやスクロール等はデフォルトで許可
                    myLocationEnabled: true, // 現在地の青い点を表示したい場合
                    myLocationButtonEnabled: false, // 右下に出る現在地ボタン
                    // +/−ボタンを表示したい場合
                    zoomControlsEnabled: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// モーダルシート。画像を横スクロール表示して「詳細を見る」ボタンで画面遷移
class _ShopBottomSheet extends StatelessWidget {
  const _ShopBottomSheet({
    Key? key,
    required this.shop,
  }) : super(key: key);

  final ShopsRecord shop;

  @override
  Widget build(BuildContext context) {
    final images = shop.images ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 横スクロール画像一覧
            if (images.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, i) {
                    final url = images[i];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        width: 200,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                ),
              ),
            const SizedBox(height: 16),

            // ショップ名
            Text(
              shop.name ?? '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // 住所など
            Text(
              shop.address ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // 詳細を見るボタン
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // モーダルを閉じる
                  // shop_widget.dart （Shop詳細画面）へ遷移
                  context.pushNamed(
                    'ShopScreen',
                    queryParameters: {
                      'shopRef': serializeParam(
                        shop.reference,
                        ParamType.DocumentReference,
                      ),
                    }.withoutNulls,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).furugiMainColor,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // パディング調整
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 角丸にする
                  ),
                ),
                child: const Text('詳細を見る'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
