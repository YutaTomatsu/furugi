import 'package:flutter/material.dart';
import 'package:furugi_with_template/pages/top/shops/shops_widget.dart';
import '/backend/backend.dart'; // PrefecturesRecord, queryShopsRecordOnce() などを使う
import 'search_shop_model.dart';

class SearchShopWidget extends StatefulWidget {
  const SearchShopWidget({Key? key}) : super(key: key);

  @override
  State<SearchShopWidget> createState() => _SearchShopWidgetState();
}

class _SearchShopWidgetState extends State<SearchShopWidget>
    with TickerProviderStateMixin {
  late SearchShopModel _model;

  @override
  void initState() {
    super.initState();
    _model = SearchShopModel();

    _model.tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.searchBarTextController.dispose();
    _model.searchBarFocusNode.dispose();
    _model.tabController.dispose();
    super.dispose();
  }

  /// ヒット件数を再計算
  Future<void> _recalculateHitCount() async {
    final keyword = _model.searchBarTextController.text;
    final allShops = await queryShopsRecordOnce(); // 全件取得

    // 絞り込み
    final filtered = allShops.where((shop) {
      // (1) 店名
      if (keyword.isNotEmpty &&
          !shop.name.toLowerCase().contains(keyword.toLowerCase())) {
        return false;
      }
      // (2) 都道府県
      if (_model.selectedPrefectures.isNotEmpty &&
          !_model.selectedPrefectures.contains(shop.prefecture)) {
        return false;
      }
      // (3) 価格帯
      if (_model.selectedPriceRanges.isNotEmpty) {
        bool matched = false;
        for (final pr in _model.selectedPriceRanges) {
          if (shop.priceRange.contains(pr)) {
            matched = true;
            break;
          }
        }
        if (!matched) return false;
      }
      // (4) 支払い方法
      if (_model.selectedPayments.isNotEmpty) {
        if (!shop.payment.any((p) => _model.selectedPayments.contains(p))) {
          return false;
        }
      }
      // (5) 定休日
      if (_model.selectedClosedDays.isNotEmpty) {
        if (!shop.closedDay.any((d) => _model.selectedClosedDays.contains(d))) {
          return false;
        }
      }
      // (6) ジェンダー
      if (_model.selectedGenders.isNotEmpty) {
        if (!shop.genders.any((g) => _model.selectedGenders.contains(g))) {
          return false;
        }
      }
      // (7) 駐車場
      if (_model.selectedParking.isNotEmpty) {
        if (!shop.parking.any((p) => _model.selectedParking.contains(p))) {
          return false;
        }
      }
      return true;
    }).toList();

    setState(() {
      _model.shopCount = filtered.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ショップ検索'),
      ),
      body: Column(
        children: [
          // --- 検索バー ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _model.searchBarTextController,
              focusNode: _model.searchBarFocusNode,
              decoration: const InputDecoration(
                labelText: 'Shop name...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => _recalculateHitCount(),
            ),
          ),

          // --- タブバー ---
          TabBar(
            controller: _model.tabController,
            tabs: const [
              Tab(text: '都道府県'),
              Tab(text: '価格帯'),
              Tab(text: 'その他'),
            ],
          ),

          // --- タブビュー ---
          Expanded(
            child: TabBarView(
              controller: _model.tabController,
              children: [
                _buildPrefectureTab(),
                _buildPriceRangeTab(),
                _buildOtherFiltersTab(),
              ],
            ),
          ),

          // --- ヒット件数 & 検索ボタン ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ヒット件数: ${_model.shopCount}'),
                ElevatedButton(
                  onPressed: () {
                    // ☆ Navigator.push で ShopsWidget に遷移
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShopsWidget(
                          keyword: _model.searchBarTextController.text,
                          prefectures: _model.selectedPrefectures,
                          priceRanges: _model.selectedPriceRanges,
                          payments: _model.selectedPayments,
                          closedDays: _model.selectedClosedDays,
                          genders: _model.selectedGenders,
                          parking: _model.selectedParking,
                        ),
                      ),
                    );
                  },
                  child: const Text('検索'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========= 以下 各タブのUI構成 =========

  Widget _buildPrefectureTab() {
    return FutureBuilder<List<PrefecturesRecord>>(
      future: queryPrefecturesRecordOnce(
        // 1回だけ取得
        queryBuilder: (p) => p.orderBy('sort_no'),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final prefs = snapshot.data!;
        return ListView.builder(
          itemCount: prefs.length,
          itemBuilder: (context, i) {
            final prefName = prefs[i].prefecture;
            final isChecked = _model.selectedPrefectures.contains(prefName);
            return CheckboxListTile(
              title: Text(prefName),
              value: isChecked,
              onChanged: (val) async {
                setState(() {
                  if (val == true) {
                    _model.addToSelectedPrefectures(prefName);
                  } else {
                    _model.removeFromSelectedPrefectures(prefName);
                  }
                });
                await _recalculateHitCount();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPriceRangeTab() {
    // サンプル
    const priceOptions = ['100円～', '500円～', '1000円～', '2000円～', '5000円～'];
    return ListView.builder(
      itemCount: priceOptions.length,
      itemBuilder: (context, i) {
        final opt = priceOptions[i];
        final isChecked = _model.selectedPriceRanges.contains(opt);
        return CheckboxListTile(
          title: Text(opt),
          value: isChecked,
          onChanged: (val) async {
            setState(() {
              if (val == true) {
                _model.addToSelectedPriceRanges(opt);
              } else {
                _model.removeFromSelectedPriceRanges(opt);
              }
            });
            await _recalculateHitCount();
          },
        );
      },
    );
  }

  Widget _buildOtherFiltersTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 支払い方法
          const Text('支払い方法'),
          FutureBuilder<List<PaymentsRecord>>(
            future: queryPaymentsRecordOnce(
              queryBuilder: (r) => r.orderBy('sort_no'),
            ),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const CircularProgressIndicator();
              }
              final payList = snap.data!;
              return Column(
                children: payList.map((payRec) {
                  final payName = payRec.payment;
                  final isChecked = _model.selectedPayments.contains(payName);
                  return CheckboxListTile(
                    title: Text(payName),
                    value: isChecked,
                    onChanged: (val) async {
                      setState(() {
                        if (val == true) {
                          _model.addToSelectedPayments(payName);
                        } else {
                          _model.removeFromSelectedPayments(payName);
                        }
                      });
                      await _recalculateHitCount();
                    },
                  );
                }).toList(),
              );
            },
          ),
          const Divider(),

          // 定休日
          const Text('定休日'),
          FutureBuilder<List<ClosedDaysRecord>>(
            future: queryClosedDaysRecordOnce(
              queryBuilder: (r) => r.orderBy('sort_no'),
            ),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const CircularProgressIndicator();
              }
              final closedList = snap.data!;
              return Column(
                children: closedList.map((cd) {
                  final dayName = cd.day;
                  final isChecked = _model.selectedClosedDays.contains(dayName);
                  return CheckboxListTile(
                    title: Text(dayName),
                    value: isChecked,
                    onChanged: (val) async {
                      setState(() {
                        if (val == true) {
                          _model.addToSelectedClosedDays(dayName);
                        } else {
                          _model.removeFromSelectedClosedDays(dayName);
                        }
                      });
                      await _recalculateHitCount();
                    },
                  );
                }).toList(),
              );
            },
          ),
          const Divider(),

          // ジェンダー
          const Text('ジェンダー'),
          FutureBuilder<List<GendersRecord>>(
            future: queryGendersRecordOnce(
              queryBuilder: (r) => r.orderBy('sort_no'),
            ),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const CircularProgressIndicator();
              }
              final genders = snap.data!;
              return Column(
                children: genders.map((gd) {
                  final gdName = gd.gender;
                  final isChecked = _model.selectedGenders.contains(gdName);
                  return CheckboxListTile(
                    title: Text(gdName),
                    value: isChecked,
                    onChanged: (val) async {
                      setState(() {
                        if (val == true) {
                          _model.addToSelectedGenders(gdName);
                        } else {
                          _model.removeFromSelectedGenders(gdName);
                        }
                      });
                      await _recalculateHitCount();
                    },
                  );
                }).toList(),
              );
            },
          ),
          const Divider(),

          // 駐車場
          const Text('駐車場'),
          FutureBuilder<List<ParkingRecord>>(
            future: queryParkingRecordOnce(
              queryBuilder: (r) => r.orderBy('sort_no'),
            ),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const CircularProgressIndicator();
              }
              final parkList = snap.data!;
              return Column(
                children: parkList.map((pk) {
                  final parkName = pk.exist;
                  final isChecked = _model.selectedParking.contains(parkName);
                  return CheckboxListTile(
                    title: Text(parkName),
                    value: isChecked,
                    onChanged: (val) async {
                      setState(() {
                        if (val == true) {
                          _model.addToSelectedParking(parkName);
                        } else {
                          _model.removeFromSelectedParking(parkName);
                        }
                      });
                      await _recalculateHitCount();
                    },
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
