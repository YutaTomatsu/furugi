import 'package:flutter/material.dart';
import 'package:furugi_with_template/flutter_flow/flutter_flow_theme.dart';
import 'package:provider/provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/header_widget.dart' show HeaderWidget;
import '/components/nav_bar12_widget.dart' show NavBar12Model, NavBar12Widget;
import 'purchases_model.dart';

class PurchasesWidget extends StatefulWidget {
  const PurchasesWidget({Key? key}) : super(key: key);

  @override
  State<PurchasesWidget> createState() => _PurchasesWidgetState();
}

class _PurchasesWidgetState extends State<PurchasesWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PurchasesModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PurchasesModel());
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _model.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // 仕切り線
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFE5E5E5),
    );
  }

  // 正方形の枠内に画像を収める
  Widget _buildSquareImage(String imageUrl) {
    return Container(
      width: 80,
      height: 80,
      color: Colors.white,
      child: (imageUrl.isNotEmpty)
          ? Image.network(
              imageUrl,
              fit: BoxFit.contain,
            )
          : const Icon(Icons.image_outlined, size: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          '取引',
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
      body: Stack(
        children: [
          // メイン表示部分
          SingleChildScrollView(
            child: Column(
              children: [
                // タブバー
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    indicatorColor:
                        FlutterFlowTheme.of(context).furugiMainColor,
                    tabs: const [
                      Tab(text: '購入した商品'),
                      Tab(text: '購入された商品'),
                    ],
                  ),
                ),

                // タブバーの中身
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      //-------------------------------------------------
                      // (1) 購入した商品
                      //-------------------------------------------------
                      StreamBuilder<List<PurchasesRecord>>(
                        stream: queryPurchasesRecord(
                          queryBuilder: (p) => p
                              .where('user', isEqualTo: currentUserReference)
                              .orderBy('time_stamp', descending: true),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'エラーが発生しました: ${snapshot.error}',
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
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

                          // 購入商品リスト表示
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

                              final firstRef = productRefs.first;
                              return StreamBuilder<ProductsRecord>(
                                stream: ProductsRecord.getDocument(firstRef),
                                builder: (context, productSnap) {
                                  if (productSnap.hasError) {
                                    return ListTile(
                                      title: Text(
                                        '商品取得エラー: ${productSnap.error}',
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    );
                                  }
                                  if (productSnap.connectionState ==
                                      ConnectionState.waiting) {
                                    return const ListTile(
                                      title: Text('読み込み中...'),
                                    );
                                  }
                                  if (!productSnap.hasData) {
                                    return const ListTile(
                                      title: Text('読み込み中...'),
                                    );
                                  }

                                  final product = productSnap.data;
                                  if (product == null) {
                                    return const ListTile(
                                      title: Text('商品が削除された可能性があります。'),
                                    );
                                  }

                                  final imageUrl = product.images.isNotEmpty
                                      ? product.images.first
                                      : '';
                                  final name = product.name;
                                  final timeStamp = purchase.timeStamp;

                                  return InkWell(
                                    onTap: () {
                                      // 会話ページへ
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
                                            ? dateTimeFormat('yMMMd', timeStamp)
                                            : '購入日不明',
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),

                      //-------------------------------------------------
                      // (2) 購入された商品
                      //-------------------------------------------------
                      FutureBuilder<List<PurchasesRecord>>(
                        future: queryPurchasesRecordOnce(
                          queryBuilder: (p) =>
                              p.orderBy('time_stamp', descending: true),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'エラーが発生しました: ${snapshot.error}',
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
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

                          // 「purchases の product のうち、ユーザードキュメント (/Users/xxx) が
                          //   currentUserReference と一致するものだけを抽出」
                          final purchasedFromMe =
                              allPurchases.where((purchase) {
                            for (final productRef in purchase.product) {
                              final userDocRef = productRef.parent.parent;
                              // userDocRef = /Users/xxx
                              if (userDocRef?.path ==
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

                              final firstRef = productRefs.first;
                              return StreamBuilder<ProductsRecord>(
                                stream: ProductsRecord.getDocument(firstRef),
                                builder: (context, productSnap) {
                                  if (productSnap.hasError) {
                                    return ListTile(
                                      title: Text(
                                        '商品取得エラー: ${productSnap.error}',
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    );
                                  }
                                  if (productSnap.connectionState ==
                                      ConnectionState.waiting) {
                                    return const ListTile(
                                      title: Text('読み込み中...'),
                                    );
                                  }
                                  if (!productSnap.hasData) {
                                    return const ListTile(
                                      title: Text('読み込み中...'),
                                    );
                                  }

                                  final product = productSnap.data;
                                  if (product == null) {
                                    return const ListTile(
                                      title: Text('商品が削除された可能性があります。'),
                                    );
                                  }

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
                                            ? dateTimeFormat('yMMMd', timeStamp)
                                            : '購入日不明',
                                      ),
                                    ),
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
        ],
      ),
    );
  }
}
