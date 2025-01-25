import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/header_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'shops_model.dart';
export 'shops_model.dart';

class ShopsWidget extends StatefulWidget {
  const ShopsWidget({
    super.key,
    // SearchShopWidget から複数のフィルタパラメータを受け取る
    this.keyword,
    this.prefectures,
    this.priceRanges,
    this.payments,
    this.closedDays,
    this.genders,
    this.parking,
  });

  /// 店名キーワード
  final String? keyword;

  /// 都道府県絞り込み (例: ["東京都", "大阪府"] など)
  final List<String>? prefectures;

  /// 価格帯 (例: ["100円～", "500円～"])
  final List<String>? priceRanges;

  /// 支払い方法 (例: ["クレジットカード", "PayPay", ...])
  final List<String>? payments;

  /// 定休日 (例: ["月曜日", "火曜日", ...])
  final List<String>? closedDays;

  /// ジェンダー (例: ["メンズ", "レディース", "キッズ"])
  final List<String>? genders;

  /// 駐車場 (例: ["あり", "なし"] など)
  final List<String>? parking;

  @override
  State<ShopsWidget> createState() => _ShopsWidgetState();
}

class _ShopsWidgetState extends State<ShopsWidget> {
  late ShopsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShopsModel());

    // ショップ一覧画面に検索バーがあるなら使う
    _model.searchFieldTextController ??= TextEditingController();
    _model.searchFieldFocusNode ??= FocusNode();

    // 例えば、SearchShopWidget で入力された keyword をこちらにセットしておく
    _model.searchFieldTextController?.text = widget.keyword ?? '';
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// allShops を受け取り、SearchShopWidget からのフィルタ内容で手動絞り込み
  List<ShopsRecord> _applyAllFilters(
    List<ShopsRecord> allShops,
    String? keyword,
    List<String>? prefs,
    List<String>? prices,
    List<String>? pays,
    List<String>? closed,
    List<String>? genders,
    List<String>? parking,
  ) {
    return allShops.where((shop) {
      // (1) 店名キーワード
      if (keyword != null && keyword.isNotEmpty) {
        final lowerName = shop.name.toLowerCase();
        final lowerKey = keyword.toLowerCase();
        if (!lowerName.contains(lowerKey)) {
          return false;
        }
      }
      // (2) 都道府県
      if (prefs != null && prefs.isNotEmpty) {
        if (!prefs.contains(shop.prefecture)) {
          return false;
        }
      }
      // (3) 価格帯
      if (prices != null && prices.isNotEmpty) {
        bool matched = false;
        for (final pr in prices) {
          if (shop.priceRange.contains(pr)) {
            matched = true;
            break;
          }
        }
        if (!matched) return false;
      }
      // (4) 支払い方法
      if (pays != null && pays.isNotEmpty) {
        if (!shop.payment.any((p) => pays.contains(p))) {
          return false;
        }
      }
      // (5) 定休日
      if (closed != null && closed.isNotEmpty) {
        if (!shop.closedDay.any((d) => closed.contains(d))) {
          return false;
        }
      }
      // (6) ジェンダー
      if (genders != null && genders.isNotEmpty) {
        if (!shop.genders.any((g) => genders.contains(g))) {
          return false;
        }
      }
      // (7) 駐車場
      if (parking != null && parking.isNotEmpty) {
        if (!shop.parking.any((p) => parking.contains(p))) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final keyword = widget.keyword ?? '';
    final prefList = widget.prefectures ?? [];
    final priceList = widget.priceRanges ?? [];
    final payList = widget.payments ?? [];
    final closedList = widget.closedDays ?? [];
    final genderList = widget.genders ?? [];
    final parkingList = widget.parking ?? [];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          child: Column(
            children: [
              // もしこの画面にも検索バーを置きたい場合はここに追加
              wrapWithModel(
                model: _model.headerModel,
                updateCallback: () => setState(() {}),
                child: const HeaderWidget(),
              ),

              // 全件読み込み → 手動絞り込み
              Expanded(
                child: StreamBuilder<List<ShopsRecord>>(
                  stream: queryShopsRecord(
                    queryBuilder: (shops) =>
                        shops.orderBy('created_time', descending: true),
                  ),
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
                    // 全データ取得
                    final allShops = snapshot.data!;
                    // 手動フィルタ
                    final filteredShops = _applyAllFilters(
                      allShops,
                      keyword,
                      prefList,
                      priceList,
                      payList,
                      closedList,
                      genderList,
                      parkingList,
                    );

                    if (filteredShops.isEmpty) {
                      return const Center(child: Text('該当するショップがありません'));
                    }
                    // 絞り込み結果を表示
                    return ListView.builder(
                      itemCount: filteredShops.length,
                      itemBuilder: (context, index) {
                        final shopRecord = filteredShops[index];
                        return _buildShopItem(context, shopRecord);
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

  Widget _buildShopItem(BuildContext context, ShopsRecord shopRecord) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          'ShopScreen',
          queryParameters: {
            'shopRef': serializeParam(
              shopRecord.reference,
              ParamType.DocumentReference,
            ),
          }.withoutNulls,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // 画像サムネイル
            if (shopRecord.images.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                child: Image.network(
                  shopRecord.images.first,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            // テキスト情報
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shopRecord.name,
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shopRecord.prefecture,
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                    // お気に入りボタン
                    Align(
                      alignment: Alignment.centerRight,
                      child: ToggleIcon(
                        onPressed: () async {
                          final likeElement = currentUserReference;
                          final likeUpdate =
                              shopRecord.like.contains(likeElement)
                                  ? FieldValue.arrayRemove([likeElement])
                                  : FieldValue.arrayUnion([likeElement]);
                          await shopRecord.reference.update({
                            ...mapToFirestore({'like': likeUpdate}),
                          });
                        },
                        value: shopRecord.like.contains(currentUserReference),
                        onIcon: Icon(
                          Icons.favorite,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 22.0,
                        ),
                        offIcon: Icon(
                          Icons.favorite_border,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 22.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
