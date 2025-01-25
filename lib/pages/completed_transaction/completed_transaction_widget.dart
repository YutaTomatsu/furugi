import 'package:flutter/material.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/header_widget.dart' show HeaderWidget;
import '/components/nav_bar12_widget.dart' show NavBar12Widget;

class CompletedTransactionWidget extends StatefulWidget {
  const CompletedTransactionWidget({Key? key}) : super(key: key);

  @override
  State<CompletedTransactionWidget> createState() =>
      _CompletedTransactionWidgetState();
}

class _CompletedTransactionWidgetState extends State<CompletedTransactionWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  Widget _buildDivider() => const Divider(height: 1, thickness: 1);

  Widget _buildSquareImage(String imageUrl) {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[200],
      child: imageUrl.isNotEmpty
          ? Image.network(imageUrl, fit: BoxFit.contain)
          : const Icon(Icons.image_outlined, size: 40),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // メイン
          SingleChildScrollView(
            child: Column(
              children: [
                const HeaderWidget(),

                // タブバー
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    tabs: const [
                      Tab(text: '購入した(完了)'),
                      Tab(text: '購入された(完了)'),
                    ],
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // ---------------------------
                      // (1) 「購入した商品」かつレビュー済
                      // ---------------------------
                      StreamBuilder<List<PurchasesRecord>>(
                        stream: queryPurchasesRecord(
                          queryBuilder: (p) => p
                              .where('user', isEqualTo: currentUserReference)
                              .orderBy('time_stamp', descending: true),
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final purchases = snapshot.data!;
                          if (purchases.isEmpty) {
                            return const Center(
                              child: Text('まだ商品を購入していません。'),
                            );
                          }

                          return ListView.separated(
                            separatorBuilder: (_, __) => _buildDivider(),
                            itemCount: purchases.length,
                            itemBuilder: (context, index) {
                              final purchase = purchases[index];
                              final productRefs = purchase.product;
                              if (productRefs.isEmpty) {
                                return ListTile(
                                  title: const Text('商品データなし'),
                                  subtitle: Text(
                                    purchase.timeStamp != null
                                        ? dateTimeFormat(
                                            'yMMMd', purchase.timeStamp!)
                                        : '購入日不明',
                                  ),
                                );
                              }
                              // ここでは "レビューが存在する" 場合のみ表示
                              return FutureBuilder<List<ReviewsRecord>>(
                                future: queryReviewsRecordOnce(
                                  queryBuilder: (r) => r
                                      .whereArrayContainsAny(
                                          'product', productRefs)
                                      .limit(1),
                                ),
                                builder: (context, reviewSnap) {
                                  if (!reviewSnap.hasData) {
                                    return const ListTile(
                                      title: Text('読み込み中...'),
                                    );
                                  }
                                  final reviews = reviewSnap.data!;
                                  // レビューが無ければ完了していない → 非表示
                                  if (reviews.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  // レビューがある → 「完了」表示
                                  final firstRef = productRefs.first;
                                  return StreamBuilder<ProductsRecord>(
                                    stream:
                                        ProductsRecord.getDocument(firstRef),
                                    builder: (context, prodSnap) {
                                      if (!prodSnap.hasData) {
                                        return const ListTile(
                                          title: Text('読み込み中...'),
                                        );
                                      }
                                      final product = prodSnap.data!;
                                      final imageUrl = product.images.isNotEmpty
                                          ? product.images.first
                                          : '';
                                      final name = product.name;
                                      final timeStamp = purchase.timeStamp;

                                      return InkWell(
                                        onTap: () {
                                          context.pushNamed(
                                            'PurchasedConversation',
                                            queryParameters: {
                                              'productInfo': serializeParam(
                                                productRefs,
                                                ParamType.DocumentReference,
                                                isList: true,
                                              ),
                                            }.withoutNulls,
                                          );
                                        },
                                        child: ListTile(
                                          leading: _buildSquareImage(imageUrl),
                                          title: Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            timeStamp != null
                                                ? dateTimeFormat(
                                                    'yMMMd', timeStamp)
                                                : '購入日不明',
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),

                      // ---------------------------
                      // (2) 「購入された商品」かつレビュー済
                      // ---------------------------
                      FutureBuilder<List<PurchasesRecord>>(
                        future: queryPurchasesRecordOnce(
                          queryBuilder: (p) =>
                              p.orderBy('time_stamp', descending: true),
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final allPurchases = snapshot.data!;
                          if (allPurchases.isEmpty) {
                            return const Center(
                              child: Text('まだ商品を購入されていません。'),
                            );
                          }

                          // 自分の出品商品
                          final purchasedFromMe = allPurchases.where((p) {
                            for (final ref in p.product) {
                              if (ref.parent.parent?.path ==
                                  currentUserReference?.path) {
                                return true;
                              }
                            }
                            return false;
                          }).toList();
                          if (purchasedFromMe.isEmpty) {
                            return const Center(
                              child: Text('まだ商品を購入されていません。'),
                            );
                          }

                          return ListView.separated(
                            separatorBuilder: (_, __) => _buildDivider(),
                            itemCount: purchasedFromMe.length,
                            itemBuilder: (context, index) {
                              final purchase = purchasedFromMe[index];
                              final productRefs = purchase.product;
                              if (productRefs.isEmpty) {
                                return ListTile(
                                  title: const Text('商品データなし'),
                                  subtitle: Text(
                                    purchase.timeStamp != null
                                        ? dateTimeFormat(
                                            'yMMMd', purchase.timeStamp!)
                                        : '購入日不明',
                                  ),
                                );
                              }
                              // レビューがあるかどうか
                              return FutureBuilder<List<ReviewsRecord>>(
                                future: queryReviewsRecordOnce(
                                  queryBuilder: (r) => r
                                      .whereArrayContainsAny(
                                          'product', productRefs)
                                      .limit(1),
                                ),
                                builder: (context, reviewSnap) {
                                  if (!reviewSnap.hasData) {
                                    return const ListTile(
                                      title: Text('読み込み中...'),
                                    );
                                  }
                                  final reviews = reviewSnap.data!;
                                  if (reviews.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  // レビューあり → 完了表示
                                  final firstRef = productRefs.first;
                                  return StreamBuilder<ProductsRecord>(
                                    stream:
                                        ProductsRecord.getDocument(firstRef),
                                    builder: (context, prodSnap) {
                                      if (!prodSnap.hasData) {
                                        return const ListTile(
                                          title: Text('読み込み中...'),
                                        );
                                      }
                                      final product = prodSnap.data!;
                                      final imageUrl = product.images.isNotEmpty
                                          ? product.images.first
                                          : '';
                                      final name = product.name;
                                      final timeStamp = purchase.timeStamp;

                                      return InkWell(
                                        onTap: () {
                                          context.pushNamed(
                                            'PurchasedConversation',
                                            queryParameters: {
                                              'productInfo': serializeParam(
                                                productRefs,
                                                ParamType.DocumentReference,
                                                isList: true,
                                              ),
                                            }.withoutNulls,
                                          );
                                        },
                                        child: ListTile(
                                          leading: _buildSquareImage(imageUrl),
                                          title: Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            timeStamp != null
                                                ? dateTimeFormat(
                                                    'yMMMd', timeStamp)
                                                : '購入日不明',
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // フッターナビ
          Align(
            alignment: const AlignmentDirectional(0, 1),
            child: const NavBar12Widget(),
          ),
        ],
      ),
    );
  }
}
