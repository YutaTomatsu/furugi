import 'package:provider/provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'create_content_model.dart';
export 'create_content_model.dart';
import '../product_register_confirm/product_register_confirm_widget.dart';
import '../../../../components/header_default_widget';

class CreateContentWidget extends StatefulWidget {
  const CreateContentWidget({super.key});

  @override
  State<CreateContentWidget> createState() => _CreateContentWidgetState();
}

class _CreateContentWidgetState extends State<CreateContentWidget> {
  late CreateContentModel _model;

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // 必須選択項目
  String? _selectedCategory;
  String? _selectedCondition;
  String? _selectedSize;
  String? _selectedShippingDays;
  String? _selectedPrefecture;
  String? _selectedShippingCost;

  // 選択項目ごとのエラーメッセージ
  String? _categoryError;
  String? _conditionError;
  String? _sizeError;
  String? _shippingDaysError;
  String? _prefectureError;
  String? _shippingCostError;

  // 画像のエラーメッセージ
  String? _imageError;

  // TextFormField key
  final GlobalKey<FormFieldState<String>> _productNameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _productDetailKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _priceKey =
      GlobalKey<FormFieldState<String>>();

  // 画像アップロード関連
  List<String> _uploadedFileUrls = [];
  List<FFUploadedFile> _uploadedLocalFiles = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateContentModel());

    // テキストフィールド初期化
    _model.productNameTextController ??= TextEditingController();
    _model.productNameFocusNode ??= FocusNode();

    _model.productDetailTextController ??= TextEditingController();
    _model.productDetailFocusNode ??= FocusNode();

    _model.priceTextController ??= TextEditingController();
    _model.priceFocusNode ??= FocusNode();

    // デフォルト値を設定
    _selectedShippingDays = "2~3日で発送"; // 発送までの日数
    _selectedShippingCost = "送料込み(出品者負担)"; // 発送料の負担
    _loadDefaultPrefecture(); // sort_no=1 の都道府県を取得
  }

  /// Firestoreからsort_no==1のprefectureを取得し、_selectedPrefectureにセット
  Future<void> _loadDefaultPrefecture() async {
    final prefectures = await queryPrefecturesRecord(
      queryBuilder: (p) => p.where('sort_no', isEqualTo: 1).limit(1),
      singleRecord: true,
    ).first;
    if (prefectures.isNotEmpty) {
      setState(() {
        _selectedPrefecture = prefectures.first.prefecture;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // 販売手数料10%
  String get commission {
    final price = int.tryParse(_model.priceTextController.text);
    if (price == null) return "-";
    final fee = (price * 0.1).floor();
    return "¥$fee";
  }

  // 販売利益 = 価格 - 手数料
  String get profit {
    final price = int.tryParse(_model.priceTextController.text);
    if (price == null) return "-";
    final fee = (price * 0.1).floor();
    final p = price - fee;
    return "¥$p";
  }

  /// 下部ボタン押下時に必須選択項目をチェック
  bool _validateSelections() {
    bool isValid = true;

    // カテゴリー
    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      _categoryError = 'カテゴリーを選択してください';
      isValid = false;
    } else {
      _categoryError = null;
    }

    // 商品の状態
    if (_selectedCondition == null || _selectedCondition!.isEmpty) {
      _conditionError = '商品の状態を選択してください';
      isValid = false;
    } else {
      _conditionError = null;
    }

    // サイズ
    if (_selectedSize == null || _selectedSize!.isEmpty) {
      _sizeError = 'サイズを選択してください';
      isValid = false;
    } else {
      _sizeError = null;
    }

    // 発送までの日数
    if (_selectedShippingDays == null || _selectedShippingDays!.isEmpty) {
      _shippingDaysError = '発送までの日数を選択してください';
      isValid = false;
    } else {
      _shippingDaysError = null;
    }

    // 発送元地域
    if (_selectedPrefecture == null || _selectedPrefecture!.isEmpty) {
      _prefectureError = '発送元地域を選択してください';
      isValid = false;
    } else {
      _prefectureError = null;
    }

    // 発送料の負担
    if (_selectedShippingCost == null || _selectedShippingCost!.isEmpty) {
      _shippingCostError = '発送料の負担を選択してください';
      isValid = false;
    } else {
      _shippingCostError = null;
    }

    // 画像
    if (_uploadedFileUrls.isEmpty) {
      _imageError = '画像を選択してください';
      isValid = false;
    } else {
      _imageError = null;
    }

    return isValid;
  }

  /// バリデーションメッセージを表示
  Widget _buildErrorText(String? error) {
    if (error == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        error,
        style: const TextStyle(color: Colors.red, fontSize: 13),
      ),
    );
  }

  /// 画像選択ウィジェット
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final selectedMedia = await selectMedia(
              mediaSource: MediaSource.photoGallery,
              multiImage: true,
            );
            if (selectedMedia != null &&
                selectedMedia
                    .every((m) => validateFileFormat(m.storagePath, context))) {
              if (selectedMedia.length + _uploadedLocalFiles.length > 10) {
                setState(() {
                  _imageError = '画像は最大10枚まで選択できます';
                });
                return;
              }

              setState(() => _model.isDataUploading = true);

              var selectedUploadedFiles = <FFUploadedFile>[];
              var downloadUrls = <String>[];

              try {
                selectedUploadedFiles = selectedMedia
                    .map((m) => FFUploadedFile(
                          name: m.storagePath.split('/').last,
                          bytes: m.bytes,
                          height: m.dimensions?.height,
                          width: m.dimensions?.width,
                          blurHash: m.blurHash,
                        ))
                    .toList();

                downloadUrls = (await Future.wait(
                  selectedMedia.map(
                    (m) async => await uploadData(m.storagePath, m.bytes),
                  ),
                ))
                    .where((u) => u != null)
                    .map((u) => u!)
                    .toList();
              } finally {
                _model.isDataUploading = false;
              }

              if (selectedUploadedFiles.length == selectedMedia.length &&
                  downloadUrls.length == selectedMedia.length) {
                setState(() {
                  _uploadedLocalFiles.addAll(selectedUploadedFiles);
                  _uploadedFileUrls.addAll(downloadUrls);
                  _imageError = null;
                });
                // バリデーション再チェック→即エラー消去
                _validateAll();
              }
            }
          },
          child: Container(
            width: double.infinity,
            // 画像がないときとあるときで同じ位置に表示するため、高さは自動にしつつ、
            // colorでわかりやすくする。必要に応じて調整。
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: _uploadedLocalFiles.isEmpty
                ? Container(
                    // 高さ固定 (例：100) にしておくと、同じ場所に画像も表示できる
                    height: 100.0,
                    alignment: Alignment.center,
                    child: const Text(
                      '画像を選択（最大10枚）',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : _buildImageList(), // 選択済みなら画像を同じ領域に表示
          ),
        ),
        // エラー表示
        _buildErrorText(_imageError),
      ],
    );
  }

  /// 選択済み画像一覧を同じ領域に表示
  Widget _buildImageList() {
    return SizedBox(
      height: 120.0,
      // 余白を調整して同じ場所に表示する
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _uploadedLocalFiles.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.network(
                  _uploadedFileUrls[index],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _uploadedLocalFiles.removeAt(index);
                      _uploadedFileUrls.removeAt(index);
                    });
                    _validateAll(); // 画像削除して0枚なら即エラー表示
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 選択項目のUI（ラベル、ListTile、本項目のエラー）
  Widget _buildSelectionRow({
    required String label,
    String? selectedValue,
    String? error,
    required Future<String?> Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: FlutterFlowTheme.of(context).bodyMedium),
          ListTile(
            title: Text(
              selectedValue ?? '$labelを選択',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              final newValue = await onTap();
              if (newValue != null) {
                setState(() {
                  // 値を更新
                });
                // ここで再バリデーション→即エラー消去
                _validateAll();
              }
            },
          ),
          _buildErrorText(error),
        ],
      ),
    );
  }

  /// 全てチェック
  bool _validateAll() {
    final textFieldsValid = _formKey.currentState!.validate();
    final selectionValid = _validateSelections();
    return textFieldsValid && selectionValid;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: const HeaderDefaultWidget(
          title: '商品の情報を入力',
          showBackButton: true,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 画像
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _buildImagePicker(),
                  ),

                  // 商品名
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                    child: Text(
                      '商品名',
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      key: _productNameKey,
                      controller: _model.productNameTextController,
                      focusNode: _model.productNameFocusNode,
                      decoration: InputDecoration(
                        labelText: '必須（40文字まで）',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '商品名を入力してください';
                        }
                        if (value.length > 40) {
                          return '商品名は40文字以内で入力してください';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // 入力が変わるたびにバリデーション→即エラー消去
                        _formKey.currentState!.validate();
                      },
                    ),
                  ),

                  // 商品の説明（任意）
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                    child: Text(
                      '商品の説明（任意）',
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      key: _productDetailKey,
                      controller: _model.productDetailTextController,
                      focusNode: _model.productDetailFocusNode,
                      decoration: InputDecoration(
                        labelText: '例）転売です。',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      onChanged: (value) {
                        // 任意項目なので特にバリデーションはしないが、
                        // 必要なら _formKey.currentState!.validate();
                      },
                    ),
                  ),

                  // カテゴリー
                  _buildSelectionRow(
                    label: 'カテゴリー',
                    selectedValue: _selectedCategory,
                    error: _categoryError,
                    onTap: () async {
                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategorySelectionPage(),
                        ),
                      );
                      if (selected != null) {
                        setState(() {
                          _selectedCategory = selected;
                        });
                      }
                      return selected;
                    },
                  ),

                  // 商品の状態
                  _buildSelectionRow(
                    label: '商品の状態',
                    selectedValue: _selectedCondition,
                    error: _conditionError,
                    onTap: () async {
                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConditionSelectionPage(),
                        ),
                      );
                      if (selected != null) {
                        setState(() {
                          _selectedCondition = selected;
                        });
                      }
                      return selected;
                    },
                  ),

                  // サイズ
                  _buildSelectionRow(
                    label: 'サイズ',
                    selectedValue: _selectedSize,
                    error: _sizeError,
                    onTap: () async {
                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SizeSelectionPage(),
                        ),
                      );
                      if (selected != null) {
                        setState(() {
                          _selectedSize = selected;
                        });
                      }
                      return selected;
                    },
                  ),

                  // 発送までの日数
                  _buildSelectionRow(
                    label: '発送までの日数',
                    selectedValue: _selectedShippingDays,
                    error: _shippingDaysError,
                    onTap: () async {
                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShippingDaysSelectionPage(),
                        ),
                      );
                      if (selected != null) {
                        setState(() {
                          _selectedShippingDays = selected;
                        });
                      }
                      return selected;
                    },
                  ),

                  // 発送元地域
                  _buildSelectionRow(
                    label: '発送元地域',
                    selectedValue: _selectedPrefecture,
                    error: _prefectureError,
                    onTap: () async {
                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrefectureSelectionPage(),
                        ),
                      );
                      if (selected != null) {
                        setState(() {
                          _selectedPrefecture = selected;
                        });
                      }
                      return selected;
                    },
                  ),

                  // 発送料の負担
                  _buildSelectionRow(
                    label: '発送料の負担',
                    selectedValue: _selectedShippingCost,
                    error: _shippingCostError,
                    onTap: () async {
                      final selected = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShippingCostSelectionPage(),
                        ),
                      );
                      if (selected != null) {
                        setState(() {
                          _selectedShippingCost = selected;
                        });
                      }
                      return selected;
                    },
                  ),

                  // 販売価格
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                    child: Text(
                      '販売価格',
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      key: _priceKey,
                      controller: _model.priceTextController,
                      focusNode: _model.priceFocusNode,
                      decoration: InputDecoration(
                        labelText: '¥300~9,999,999（任意）',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '販売価格を入力してください';
                        }
                        final price = int.tryParse(value);
                        if (price == null || price < 300 || price > 9999999) {
                          return '販売価格は¥300~9,999,999の間で入力してください';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // 入力変更時にバリデーションして即エラー消去
                        _formKey.currentState!.validate();
                      },
                    ),
                  ),

                  // 販売手数料・利益
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '販売手数料（10%）: $commission',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '販売利益: $profit',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          color: FlutterFlowTheme.of(context).primaryBackground,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FFButtonWidget(
                onPressed: () {
                  print('下書きを保存しました。');
                },
                text: '下書きを保存',
                options: FFButtonOptions(
                  width: 160.0,
                  height: 40.0,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter',
                        color: const Color(0xFF507583),
                      ),
                  borderSide: const BorderSide(
                    color: Color(0xFF507583),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              FFButtonWidget(
                onPressed: () async {
                  final isValid = _validateAll();
                  setState(() {}); // 再描画→エラー反映/消去
                  if (!isValid) {
                    return; // エラーがあれば処理中断
                  }

                  // 確認画面へ遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductRegisterConfirmWidget(
                        productData: {
                          'productName': _model.productNameTextController.text,
                          'productDetail':
                              _model.productDetailTextController.text,
                          'category': _selectedCategory,
                          'condition': _selectedCondition,
                          'size': _selectedSize,
                          'shippingDays': _selectedShippingDays,
                          'prefecture': _selectedPrefecture,
                          'shippingCost': _selectedShippingCost,
                          'price': _model.priceTextController.text,
                          'commission': commission,
                          'profit': profit,
                          'imageUrls': _uploadedFileUrls,
                        },
                      ),
                    ),
                  );
                },
                text: '古着を確認する',
                options: FFButtonOptions(
                  width: 160.0,
                  height: 40.0,
                  color: const Color(0xFF507583),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                  elevation: 3.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// カテゴリー選択ページ（既存）
class CategorySelectionPage extends StatefulWidget {
  @override
  _CategorySelectionPageState createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カテゴリーを選択'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
      ),
      body: StreamBuilder<List<CategoriesRecord>>(
        stream: queryCategoriesRecord(
          queryBuilder: (categoriesRecord) =>
              categoriesRecord.orderBy('sort_no'),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary),
              ),
            );
          }
          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category.categoryName),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  final subCollectionRef =
                      category.reference.collection('sub_collections');
                  final subCollectionSnapshot =
                      await subCollectionRef.limit(1).get();

                  if (subCollectionSnapshot.docs.isNotEmpty) {
                    final selectedCategory = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategorySelectionPage(
                          parentCategoryRef: category.reference,
                        ),
                      ),
                    );
                    if (selectedCategory != null) {
                      Navigator.pop(context, selectedCategory);
                    }
                  } else {
                    Navigator.pop(context, category.categoryName);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SubCategorySelectionPage extends StatefulWidget {
  final DocumentReference parentCategoryRef;

  const SubCategorySelectionPage({
    Key? key,
    required this.parentCategoryRef,
  }) : super(key: key);

  @override
  _SubCategorySelectionPageState createState() =>
      _SubCategorySelectionPageState();
}

class _SubCategorySelectionPageState extends State<SubCategorySelectionPage> {
  @override
  Widget build(BuildContext context) {
    final subCollectionRef =
        widget.parentCategoryRef.collection('sub_collections');

    return Scaffold(
      appBar: AppBar(
        title: const Text('サブカテゴリーを選択'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: subCollectionRef.orderBy('sort_no').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary),
              ),
            );
          }
          final subCategories = snapshot.data!.docs;
          return ListView.builder(
            itemCount: subCategories.length,
            itemBuilder: (context, index) {
              final subCategoryDoc = subCategories[index];
              final subCategoryName =
                  subCategoryDoc['category_name'] as String?;

              return ListTile(
                title: Text(subCategoryName ?? ''),
                trailing: const Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  final nextSubCollectionRef =
                      subCategoryDoc.reference.collection('sub_collections');
                  final nextSubCollectionSnapshot =
                      await nextSubCollectionRef.limit(1).get();

                  if (nextSubCollectionSnapshot.docs.isNotEmpty) {
                    final selectedCategory = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubCategorySelectionPage(
                          parentCategoryRef: subCategoryDoc.reference,
                        ),
                      ),
                    );
                    if (selectedCategory != null) {
                      Navigator.pop(context, selectedCategory);
                    }
                  } else {
                    Navigator.pop(context, subCategoryName);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ConditionSelectionPage extends StatelessWidget {
  const ConditionSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderDefaultWidget(
        title: '商品の状態',
        showBackButton: true,
      ),
      body: StreamBuilder<List<ConditionsRecord>>(
        stream: queryConditionsRecord(
          queryBuilder: (conditionsRecord) =>
              conditionsRecord.orderBy('sort_no'),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary),
              ),
            );
          }
          final conditions = snapshot.data!;
          return ListView.separated(
            itemCount: conditions.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final condition = conditions[index];
              return ListTile(
                title: Text(condition.condition),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context, condition.condition);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SizeSelectionPage extends StatelessWidget {
  static const sizes = [
    "XXS",
    "XS",
    "S",
    "M",
    "L",
    "XL",
    "2XL",
    "3XL",
    "4XL",
    "FREE SIZE"
  ];

  const SizeSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderDefaultWidget(
        title: 'サイズ',
        showBackButton: true,
      ),
      body: ListView.builder(
        itemCount: sizes.length,
        itemBuilder: (context, index) {
          final size = sizes[index];
          return ListTile(
            title: Text(size),
            onTap: () {
              Navigator.pop(context, size);
            },
          );
        },
      ),
    );
  }
}

class ShippingDaysSelectionPage extends StatelessWidget {
  static const daysOptions = [
    "1~2日で発送",
    "2~3日で発送",
    "4~7日で発送",
  ];

  const ShippingDaysSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderDefaultWidget(
        title: '発送までの日数',
        showBackButton: true,
      ),
      body: ListView.builder(
        itemCount: daysOptions.length,
        itemBuilder: (context, index) {
          final day = daysOptions[index];
          return ListTile(
            title: Text(day),
            onTap: () {
              Navigator.pop(context, day);
            },
          );
        },
      ),
    );
  }
}

class PrefectureSelectionPage extends StatelessWidget {
  const PrefectureSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderDefaultWidget(
        title: '発送元地域',
        showBackButton: true,
      ),
      body: StreamBuilder<List<PrefecturesRecord>>(
        stream: queryPrefecturesRecord(
          queryBuilder: (prefecturesRecord) =>
              prefecturesRecord.orderBy('sort_no'),
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
          final prefs = snapshot.data!;
          return ListView.builder(
            itemCount: prefs.length,
            itemBuilder: (context, index) {
              final pref = prefs[index];
              return ListTile(
                title: Text(pref.prefecture),
                onTap: () {
                  Navigator.pop(context, pref.prefecture);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ShippingCostSelectionPage extends StatelessWidget {
  static const costOptions = [
    "送料込み(出品者負担)",
    "着払い(購入者負担)",
  ];

  const ShippingCostSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderDefaultWidget(
        title: '発送料の負担',
        showBackButton: true,
      ),
      body: ListView.builder(
        itemCount: costOptions.length,
        itemBuilder: (context, index) {
          final cost = costOptions[index];
          return ListTile(
            title: Text(cost),
            onTap: () {
              Navigator.pop(context, cost);
            },
          );
        },
      ),
    );
  }
}
