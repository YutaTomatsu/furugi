import 'package:furugi_with_template/components/nav_bar12_model.dart';
import 'package:furugi_with_template/components/nav_bar12_widget.dart';
import 'package:provider/provider.dart';

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

  /// 店名キーワード（初期値）
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

  /// 検索バーに対応するTextController
  final TextEditingController _searchController = TextEditingController();

  /// サジェスト用の検索結果候補（入力中に表示）
  List<ShopsRecord> _searchResults = [];

  /// Firestoreから取得した全ショップをキャッシュ
  List<ShopsRecord> _allShops = [];

  /// 最終的にEnter押下で確定した検索キーワード
  String _finalSearchKeyword = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShopsModel());

    // FlutterFlowで生成された検索バー用のコントローラ
    _model.searchFieldTextController ??= TextEditingController();
    _model.searchFieldFocusNode ??= FocusNode();

    // 初期キーワードがあればセット
    if (widget.keyword != null && widget.keyword!.isNotEmpty) {
      _searchController.text = widget.keyword!;
    }

    // 入力中はサジェストだけ更新 → _onSearchChanged()
    // (Enter押下で本検索を実行)
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _model.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// 入力中に呼ばれ、サジェスト候補だけ更新
  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();

    // 空ならサジェストクリア
    if (query.isEmpty) {
      setState(() => _searchResults.clear());
      return;
    }
    // まだ_allShopsが未取得なら何もしない
    if (_allShops.isEmpty) return;

    // 部分一致で候補を絞る
    final filtered = _allShops.where((shop) {
      final name = (shop.name ?? '').toLowerCase();
      return name.contains(query);
    }).toList();

    // ヒット位置が先頭に近い順にソート
    filtered.sort((a, b) {
      final aName = (a.name ?? '').toLowerCase();
      final bName = (b.name ?? '').toLowerCase();
      final indexA = aName.indexOf(query);
      final indexB = bName.indexOf(query);
      return indexA.compareTo(indexB);
    });

    setState(() {
      _searchResults = filtered;
    });
  }

  /// Enter押下で呼ばれる → メインリストを絞り込み
  /// サジェストを消して、_finalSearchKeyword を確定
  void _onSearchSubmitted(String submittedText) {
    setState(() {
      _finalSearchKeyword = submittedText.trim().toLowerCase();
      // Enterを押したらサジェストは消す
      _searchResults.clear();
    });
    FocusScope.of(context).unfocus();
  }

  /// メインの絞り込みロジック
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
    final filtered = allShops.where((shop) {
      // (1) 店名キーワード
      if (keyword != null && keyword.isNotEmpty) {
        final lowerName = shop.name.toLowerCase();
        if (!lowerName.contains(keyword)) {
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

    // ソート: キーワード一致が先頭に近い順
    if (keyword != null && keyword.isNotEmpty) {
      filtered.sort((a, b) {
        final aName = a.name.toLowerCase();
        final bName = b.name.toLowerCase();
        final indexA = aName.indexOf(keyword);
        final indexB = bName.indexOf(keyword);
        return indexA.compareTo(indexB);
      });
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    // ここでは、Enter押下済みの _finalSearchKeyword を使って絞り込む
    final keyword = _finalSearchKeyword;

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
        bottomNavigationBar: Consumer<NavBar12Model>(
          builder: (context, model, child) {
            return NavBar12Widget();
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Container(
              height: 36, // 検索バーの高さ
              decoration: BoxDecoration(
                color: Colors.grey[150],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                // ★ Enterを押したら絞り込み実行 & サジェストクリア
                onSubmitted: _onSearchSubmitted,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  hintText: 'ショップ検索（Enterで決定）',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[150],

                  // クリアボタン
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: FlutterFlowTheme.of(context).furugiMainColor,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged(); // クリアで候補も再更新
                          },
                        )
                      : null,
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          centerTitle: false,
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
          child: Stack(
            children: [
              // メインのリスト
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
                    final allShops = snapshot.data!;
                    // 取得した全ショップをキャッシュ
                    _allShops = allShops;

                    // Enter押下済みのkeywordでフィルタ
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
              // ★ サジェスト候補を検索バー直下に表示
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
                        onTap: () {
                          // 候補をタップ → 検索フィールドに反映
                          _searchController.text = shop.name ?? '';
                          _onSearchChanged();
                          FocusScope.of(context).unfocus();
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

  /// ショップ1件分のUI
  Widget _buildShopItem(BuildContext context, ShopsRecord shopRecord) {
    return InkWell(
      onTap: () {
        // ショップ詳細へ遷移
        context.pushNamed(
          'ShopScreen',
          queryParameters: {
            'shopRef': serializeParam(
              shopRecord.reference,
              ParamType.DocumentReference,
            ),
          }.withoutNulls,
          extra: <String, dynamic>{
            kTransitionInfoKey: const TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.rightToLeft,
            ),
          },
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
                    // いいねボタン
                    Align(
                      alignment: Alignment.centerRight,
                      child: ToggleIcon(
                        onPressed: () async {
                          try {
                            // toppage_widget.dart での実装を参考に
                            final likeElement = currentUserReference;
                            final likeUpdate =
                                shopRecord.like.contains(likeElement)
                                    ? FieldValue.arrayRemove([likeElement])
                                    : FieldValue.arrayUnion([likeElement]);
                            await shopRecord.reference.update({
                              ...mapToFirestore({'like': likeUpdate}),
                            });
                          } catch (e) {
                            print('Error toggling like: $e');
                          }
                        },
                        // toppage_widget.dart では like.contains(...) 前提
                        value: shopRecord.like.contains(currentUserReference),
                        onIcon: Icon(
                          Icons.favorite,
                          color: FlutterFlowTheme.of(context).like,
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
