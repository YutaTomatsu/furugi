import '../../components/nav_bar12_widget.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'edit_profile_model.dart';
export 'edit_profile_model.dart';
import '/backend/api_requests/api_calls.dart';
import 'package:flutter/services.dart';

class EditprofileWidget extends StatefulWidget {
  const EditprofileWidget({Key? key}) : super(key: key);

  @override
  State<EditprofileWidget> createState() => _EditprofileWidgetState();
}

class _EditprofileWidgetState extends State<EditprofileWidget> {
  late EditprofileModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // 既存の配送先一覧
  List<Map<String, dynamic>> _addresses = [];
  // 新たに追加予定の配送先リスト
  List<Map<String, dynamic>> _pendingAddresses = [];
  // デフォルトの配送先インデックス
  int? _selectedAddressIndex;

  /// 新規配送先追加フォーム
  final GlobalKey<FormState> _newAddressFormKey = GlobalKey<FormState>();
  final TextEditingController _newAddressNameController =
      TextEditingController();
  final TextEditingController _newAddressEmailController =
      TextEditingController();
  final TextEditingController _newAddressPhoneController =
      TextEditingController();
  final TextEditingController _newAddressPostalCodeController =
      TextEditingController();
  final TextEditingController _newAddressPrefectureController =
      TextEditingController();
  final TextEditingController _newAddressDetailController =
      TextEditingController();
  String? _newAddressPostalCodeError;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditprofileModel());
    _model.initializeModel(); // モデル初期化

    // ----- 基本情報フォームコントローラ初期化 -----
    _model.nameTextController ??=
        TextEditingController(text: currentUserDisplayName);
    _model.nameFocusNode ??= FocusNode();

    _model.emailTextController ??=
        TextEditingController(text: currentUserEmail);
    _model.emailFocusNode ??= FocusNode();

    _model.phoneTextController1 ??=
        TextEditingController(text: currentPhoneNumber);
    _model.phoneFocusNode1 ??= FocusNode();

    // ----- 既存配送先をロード -----
    if (currentUserDocument?.address is List) {
      _addresses =
          List<Map<String, dynamic>>.from(currentUserDocument!.address);
      if (_addresses.isNotEmpty) {
        _selectedAddressIndex = currentUserDocument?.defaultAddressIndex ?? 0;
        if (_selectedAddressIndex != null &&
            _selectedAddressIndex! >= _addresses.length) {
          _selectedAddressIndex = 0;
        }
      }
    } else if (currentUserDocument?.address is String &&
        (currentUserDocument!.address as String).isNotEmpty) {
      _addresses = [
        {
          'name': currentUserDisplayName,
          'email': currentUserEmail,
          'phone': currentPhoneNumber,
          'address': currentUserDocument!.address,
          'postal_code': currentUserDocument!.postalCode,
        }
      ];
      _selectedAddressIndex = currentUserDocument?.defaultAddressIndex ?? 0;
    }

    // ----- 新規配送先フォーム初期値 -----
    _newAddressNameController.text = currentUserDisplayName;
    _newAddressEmailController.text = currentUserEmail;
    _newAddressPhoneController.text = currentPhoneNumber;

    // 郵便番号が変わったらエラーをクリア
    _newAddressPostalCodeController.addListener(() {
      setState(() {
        _newAddressPostalCodeError = null;
      });
    });
  }

  @override
  void dispose() {
    _model.dispose();

    _newAddressNameController.dispose();
    _newAddressEmailController.dispose();
    _newAddressPhoneController.dispose();
    _newAddressPostalCodeController.dispose();
    _newAddressPrefectureController.dispose();
    _newAddressDetailController.dispose();

    super.dispose();
  }

  /// 画面遷移用: 指定ページへアニメ付きで移動
  void _goToPage(int pageIndex) {
    setState(() {
      _model.currentPageIndex = pageIndex;
    });
    _model.pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// 「新しい配送先を追加」 → 追加予定リスト（_pendingAddresses）に格納
  void _addNewAddress() {
    if (!_newAddressFormKey.currentState!.validate()) {
      return;
    }
    final newAddress = {
      'name': _newAddressNameController.text,
      'email': _newAddressEmailController.text,
      'phone': _newAddressPhoneController.text,
      'postal_code': _newAddressPostalCodeController.text,
      'address':
          '${_newAddressPrefectureController.text} ${_newAddressDetailController.text}',
    };
    setState(() {
      _pendingAddresses.add(newAddress);
    });
    // 入力フィールドをクリア
    _newAddressPostalCodeController.clear();
    _newAddressPrefectureController.clear();
    _newAddressDetailController.clear();
  }

  /// 新規住所フォームの「検索」ボタン押下時
  Future<void> _searchPostalCodeForNew() async {
    final validationError =
        _validatePostalCode(_newAddressPostalCodeController.text);
    if (validationError != null) {
      setState(() {
        _newAddressPostalCodeError = validationError;
      });
      return;
    } else {
      setState(() {
        _newAddressPostalCodeError = null;
      });
    }

    // APIコール
    final apiResult = await ZipcodeAPICall.call(
      zipcode: _newAddressPostalCodeController.text,
    );
    if ((apiResult?.succeeded ?? false) &&
        getJsonField(apiResult?.jsonBody ?? '', r'''$.results''') != null) {
      final address1 =
          getJsonField(apiResult?.jsonBody ?? '', r'''$.results[0].address1''')
              .toString();
      final address2 =
          getJsonField(apiResult?.jsonBody ?? '', r'''$.results[0].address2''')
              .toString();
      final address3 =
          getJsonField(apiResult?.jsonBody ?? '', r'''$.results[0].address3''')
              .toString();
      setState(() {
        _newAddressPrefectureController.text = address1;
        _newAddressDetailController.text = '$address2$address3';
      });
    } else {
      setState(() {
        _newAddressPostalCodeError = '正しい郵便番号を入力してください';
      });
    }
  }

  // ----------------- メニュー画面(ページ0) -----------------
  Widget _buildMenuPage() {
    final List<Map<String, dynamic>> menuItems = [
      {'text': '基本情報の編集', 'page': 1},
      {'text': '登録済み配送先の編集', 'page': 2},
      {'text': '新しい配送先の追加', 'page': 3},
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: menuItems.length,
      separatorBuilder: (context, index) => Divider(
        thickness: 1, // 線の太さ
        height: 1, // 上下の余白
        color: Colors.grey.shade300, // 線の色
      ),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return InkWell(
          onTap: () => _goToPage(item['page']),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            alignment: Alignment.center, // 左寄せ
            child: Text(
              item['text'],
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        );
      },
    );
  }

  // ----------------- 基本情報編集(ページ1) -----------------
  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _model.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _model.nameTextController,
                focusNode: _model.nameFocusNode,
                decoration: InputDecoration(
                  labelText: '名前',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: _model.nameTextControllerValidator,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _model.emailTextController,
                focusNode: _model.emailFocusNode,
                decoration: InputDecoration(
                  labelText: 'メールアドレス',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: _model.emailTextControllerValidator,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _model.phoneTextController1,
                focusNode: _model.phoneFocusNode1,
                decoration: InputDecoration(
                  labelText: '電話番号',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: _model.phoneTextController1Validator,
              ),
              const SizedBox(height: 40),
              // 「編集を保存する」ボタン
              FFButtonWidget(
                onPressed: _saveBasicInfoOnly,
                text: '編集を保存する',
                options: FFButtonOptions(
                  height: 40,
                  color: FlutterFlowTheme.of(context).furugiMainColor,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 基本情報だけ保存
  Future<void> _saveBasicInfoOnly() async {
    if (!_model.formKey.currentState!.validate()) {
      return;
    }
    await currentUserReference!.update(
      createUsersRecordData(
        email: _model.emailTextController?.text ?? '',
        displayName: _model.nameTextController?.text ?? '',
        phoneNumber: _model.phoneTextController1?.text ?? '',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('基本情報を保存しました')),
    );
  }

  // ----------------- 登録済み配送先(ページ2) -----------------
  Widget _buildAddressListPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_addresses.isEmpty)
              const Text('配送先が登録されていません')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final addr = _addresses[index];
                  if (_model.editingAddressIndex == index) {
                    // インライン編集フォーム
                    return _buildInlineAddressEditor(index);
                  } else {
                    // 通常表示
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '名前: ${addr['name']}\nメールアドレス: ${addr['email']}\n電話番号: ${addr['phone']}\n郵便番号: ${addr['postal_code']}\n住所: ${addr['address']}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (_selectedAddressIndex == index)
                                  const Text('【既定の配送先】',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ))
                                else
                                  Align(
                                    child: TextButton(
                                      onPressed: () =>
                                          _setDefaultAddressAndSave(index),
                                      child: const Text('デフォルトの配送先に指定'),
                                    ),
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color: FlutterFlowTheme.of(context)
                                              .furugiMainColor),
                                      onPressed: () {
                                        // 編集開始: Prefecture + Detail に分割する
                                        setState(() {
                                          _model.editingAddressIndex = index;
                                          _model.editNameCtrl.text =
                                              addr['name'] ?? '';
                                          _model.editEmailCtrl.text =
                                              addr['email'] ?? '';
                                          _model.editPhoneCtrl.text =
                                              addr['phone'] ?? '';
                                          _model.editPostalCodeCtrl.text =
                                              addr['postal_code'] ?? '';

                                          // Addressをざっくり分割
                                          final oldAddress =
                                              addr['address'] ?? '';
                                          final splitted =
                                              oldAddress.split(' ');
                                          if (splitted.length >= 2) {
                                            _model.editPrefectureCtrl.text =
                                                splitted.first;
                                            _model.editDetailCtrl.text =
                                                splitted.sublist(1).join(' ');
                                          } else {
                                            _model.editPrefectureCtrl.text =
                                                oldAddress; // or ''
                                            _model.editDetailCtrl.text = '';
                                          }
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: FlutterFlowTheme.of(context)
                                              .furugiMainColor),
                                      onPressed: () =>
                                          _deleteAddressAndSave(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  /// デフォルトの配送先を指定して即時保存
  Future<void> _setDefaultAddressAndSave(int index) async {
    setState(() {
      _selectedAddressIndex = index;
    });
    await _saveAllAddresses();
  }

  /// 配送先を削除して即保存
  Future<void> _deleteAddressAndSave(int index) async {
    setState(() {
      _addresses.removeAt(index);
      if (_selectedAddressIndex == index) {
        _selectedAddressIndex = _addresses.isNotEmpty ? 0 : null;
      } else if (_selectedAddressIndex != null &&
          index < _selectedAddressIndex!) {
        _selectedAddressIndex = _selectedAddressIndex! - 1;
      }
    });
    await _saveAllAddresses();
  }

  /// 全ての配送先情報をFirestoreに保存
  Future<void> _saveAllAddresses() async {
    await currentUserReference!.update(
      createUsersRecordData(
        address: _addresses,
        defaultAddressIndex: _selectedAddressIndex,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('配送先情報を保存しました')),
    );
  }

  /// インライン編集フォーム (Address フィールドを削除)
  Widget _buildInlineAddressEditor(int index) {
    return Card(
      color: const Color(0xFFEFEFEF),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextFormField(
              controller: _model.editNameCtrl,
              decoration: const InputDecoration(labelText: '名前'),
            ),
            TextFormField(
              controller: _model.editEmailCtrl,
              decoration: const InputDecoration(labelText: 'メールアドレス'),
            ),
            TextFormField(
              controller: _model.editPhoneCtrl,
              decoration: const InputDecoration(labelText: '電話番号'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _model.editPostalCodeCtrl,
                    decoration: const InputDecoration(labelText: '郵便番号 (7桁)'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(7),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                FFButtonWidget(
                  onPressed: () async {
                    final error = _validatePostalCode(
                      _model.editPostalCodeCtrl.text,
                    );
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                      return;
                    }
                    final apiResult = await ZipcodeAPICall.call(
                      zipcode: _model.editPostalCodeCtrl.text,
                    );
                    if ((apiResult?.succeeded ?? false) &&
                        getJsonField(
                                apiResult?.jsonBody ?? '', r'''$.results''') !=
                            null) {
                      final address1 = getJsonField(apiResult?.jsonBody ?? '',
                              r'''$.results[0].address1''')
                          .toString();
                      final address2 = getJsonField(apiResult?.jsonBody ?? '',
                              r'''$.results[0].address2''')
                          .toString();
                      final address3 = getJsonField(apiResult?.jsonBody ?? '',
                              r'''$.results[0].address3''')
                          .toString();
                      setState(() {
                        // 都道府県フィールドと住所詳細に分割
                        _model.editPrefectureCtrl.text = address1;
                        _model.editDetailCtrl.text = '$address2$address3';
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('正しい郵便番号を入力してください')),
                      );
                    }
                  },
                  text: '検索',
                  options: FFButtonOptions(
                    height: 40,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Inter',
                          color: Colors.black,
                        ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // 都道府県 & 住所詳細
            TextFormField(
              controller: _model.editPrefectureCtrl,
              decoration: const InputDecoration(labelText: '都道府県'),
            ),
            TextFormField(
              controller: _model.editDetailCtrl,
              decoration: const InputDecoration(labelText: '住所詳細'),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _model.editingAddressIndex = null; // 編集キャンセル
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('キャンセル'),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () {
                    // 「都道府県 + 住所詳細」を結合して address フィールドにする
                    final updatedAddress =
                        '${_model.editPrefectureCtrl.text} ${_model.editDetailCtrl.text}';

                    setState(() {
                      _addresses[index] = {
                        'name': _model.editNameCtrl.text,
                        'email': _model.editEmailCtrl.text,
                        'phone': _model.editPhoneCtrl.text,
                        'address': updatedAddress,
                        'postal_code': _model.editPostalCodeCtrl.text,
                      };
                      _model.editingAddressIndex = null; // 編集終了
                    });
                    // 変更をFirestoreに保存
                    _saveAllAddresses();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        FlutterFlowTheme.of(context).furugiMainColor,
                    foregroundColor: Colors.white, // ボタン文字色
                  ),
                  child: const Text('保存'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ----------------- 新しい配送先の追加(ページ3) -----------------
  Widget _buildNewAddressPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // 新規住所フォーム
            Form(
              key: _newAddressFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _newAddressNameController,
                    decoration: InputDecoration(
                      labelText: '名前',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (val) =>
                        (val == null || val.isEmpty) ? '名前を入力してください' : null,
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _newAddressEmailController,
                    decoration: InputDecoration(
                      labelText: 'メールアドレス',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (val) => (val == null || val.isEmpty)
                        ? 'メールアドレスを入力してください'
                        : null,
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _newAddressPhoneController,
                    decoration: InputDecoration(
                      labelText: '電話番号',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (val) =>
                        (val == null || val.isEmpty) ? '電話番号を入力してください' : null,
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _newAddressPostalCodeController,
                    decoration: InputDecoration(
                      labelText: '郵便番号 (7桁)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(7),
                    ],
                    validator: _validatePostalCode,
                  ),
                  if (_newAddressPostalCodeError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _newAddressPostalCodeError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 10.0),
                  FFButtonWidget(
                    onPressed: _searchPostalCodeForNew,
                    text: '検索',
                    options: FFButtonOptions(
                      height: 40,
                      color: FlutterFlowTheme.of(context).furugiMainColor,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                              ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _newAddressPrefectureController,
                    decoration: InputDecoration(
                      labelText: '都道府県',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (val) => (val == null || val.isEmpty)
                        ? '都道府県が自動入力されませんでした'
                        : null,
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _newAddressDetailController,
                    decoration: InputDecoration(
                      labelText: '住所',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    maxLines: 3,
                    validator: (val) =>
                        (val == null || val.isEmpty) ? '住所が自動入力されませんでした' : null,
                  ),
                  const SizedBox(height: 10.0),
                  FFButtonWidget(
                    onPressed: _addNewAddress,
                    text: '追加(一時リスト)',
                    options: FFButtonOptions(
                      height: 40,
                      color: FlutterFlowTheme.of(context).furugiMainColor,
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(fontFamily: 'Inter', color: Colors.white),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            // 一時リスト表示
            if (_pendingAddresses.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '追加予定の配送先',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 10.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _pendingAddresses.length,
                    itemBuilder: (context, index) {
                      final addr = _pendingAddresses[index];
                      return Card(
                        child: ListTile(
                          textColor: Colors.black,
                          subtitle: Text(
                              '名前: ${addr['name']}\nメールアドレス: ${addr['email']}\n電話番号: ${addr['phone']}\n郵便番号: ${addr['postal_code']}\n住所: ${addr['address']}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete,
                                color: FlutterFlowTheme.of(context)
                                    .furugiMainColor),
                            onPressed: () {
                              setState(() {
                                _pendingAddresses.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            const SizedBox(height: 20),
            // このページだけの「編集を保存する」ボタン
            FFButtonWidget(
              onPressed: _savePendingAddresses,
              text: '編集を保存する',
              options: FFButtonOptions(
                height: 40,
                color: FlutterFlowTheme.of(context).furugiMainColor,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 新しい配送先だけ保存
  Future<void> _savePendingAddresses() async {
    // ここでは _pendingAddresses を _addresses に統合して保存
    setState(() {
      _addresses.addAll(_pendingAddresses);
      _pendingAddresses.clear();
    });
    // Firestore更新
    await currentUserReference!.update(
      createUsersRecordData(
        address: _addresses,
        defaultAddressIndex: _selectedAddressIndex,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('新しい配送先を保存しました')),
    );
  }

  /// 郵便番号バリデーション (共通)
  String? _validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return '郵便番号を入力してください';
    } else if (!RegExp(r'^\d{7}$').hasMatch(value)) {
      return '7桁の数字を入力してください（ハイフンなし）';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        bottomNavigationBar: wrapWithModel(
          model: _model.navBar12Model,
          updateCallback: () => setState(() {}),
          child: const NavBar12Widget(),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          toolbarHeight: 50,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (_model.currentPageIndex == 0) {
                Navigator.pop(context);
              } else {
                _goToPage(0);
              }
            },
          ),
          title: Text(
            _getPageTitle(_model.currentPageIndex), // ヘッダータイトルを取得
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: Colors.black,
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        body: SafeArea(
          child: PageView(
            controller: _model.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildMenuPage(),
              _buildBasicInfoPage(),
              _buildAddressListPage(),
              _buildNewAddressPage(),
            ],
          ),
        ),
      ),
    );
  }
}

String _getPageTitle(int pageIndex) {
  switch (pageIndex) {
    case 0:
      return 'プロフィール編集';
    case 1:
      return '基本情報の編集';
    case 2:
      return '登録済み配送先の編集';
    case 3:
      return '新しい配送先の追加';
    default:
      return 'プロフィール編集';
  }
}
