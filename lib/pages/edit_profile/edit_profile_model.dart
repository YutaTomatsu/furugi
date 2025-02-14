import 'package:furugi_with_template/components/header_model.dart';
import 'package:furugi_with_template/components/nav_bar12_model.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'edit_profile_widget.dart' show EditprofileWidget;
import 'package:flutter/material.dart';

class EditprofileModel extends FlutterFlowModel<EditprofileWidget> {
  /// PageView関連
  late PageController pageController;
  // 0 = メニュー, 1=基本情報, 2=登録済み配送先, 3=新しい配送先
  int currentPageIndex = 0;

  /// 基本情報フォーム
  final formKey = GlobalKey<FormState>();

  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  // ★ Flutter の TextFormField.validator は `String? Function(String?)?`
  String? Function(String?)? nameTextControllerValidator;

  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(String?)? emailTextControllerValidator;

  FocusNode? phoneFocusNode1;
  TextEditingController? phoneTextController1;
  String? Function(String?)? phoneTextController1Validator;

  /// 既存配送先の編集用(インライン編集フォーム)
  // どのIndexを編集中か (nullなら編集中なし)
  int? editingAddressIndex;

  // 編集フォーム用コントローラ
  final TextEditingController editNameCtrl = TextEditingController();
  final TextEditingController editEmailCtrl = TextEditingController();
  final TextEditingController editPhoneCtrl = TextEditingController();
  final TextEditingController editPostalCodeCtrl = TextEditingController();
  final TextEditingController editPrefectureCtrl = TextEditingController();
  final TextEditingController editDetailCtrl = TextEditingController();
  // 表示用 (まとめた住所)
  final TextEditingController editFullAddressCtrl = TextEditingController();

  /// ヘッダー/フッター用モデル
  late HeaderModel headerModel;
  late NavBar12Model navBar12Model;

  // 通常のメソッドとして初期化処理を呼ぶ (initStateは親クラスでabstractじゃない)
  void initializeModel() {
    pageController = PageController(initialPage: 0);

    // 必須フィールドバリデータ設定
    nameTextControllerValidator = (val) {
      if (val == null || val.isEmpty) {
        return '名前を入力してください';
      }
      return null;
    };
    emailTextControllerValidator = (val) {
      if (val == null || val.isEmpty) {
        return 'メールアドレスを入力してください';
      }
      return null;
    };
    phoneTextController1Validator = (val) {
      if (val == null || val.isEmpty) {
        return '電話番号を入力してください';
      }
      return null;
    };
  }

  // 親クラスの dispose() はオーバーライドではなく、そこから呼ばれる
  @override
  void dispose() {
    pageController.dispose();

    nameFocusNode?.dispose();
    nameTextController?.dispose();
    emailFocusNode?.dispose();
    emailTextController?.dispose();
    phoneFocusNode1?.dispose();
    phoneTextController1?.dispose();

    editNameCtrl.dispose();
    editEmailCtrl.dispose();
    editPhoneCtrl.dispose();
    editPostalCodeCtrl.dispose();
    editPrefectureCtrl.dispose();
    editDetailCtrl.dispose();
    editFullAddressCtrl.dispose();

    headerModel.dispose();
    navBar12Model.dispose();
  }

  @override
  void onUpdate() {
    // 必要があればここでアップデート処理
  }

  @override
  void onReady() {
    // ページがマウントされたあとに行いたい処理があれば
  }

  @override
  void onReload() {
    // Hot reload時に行いたい処理があれば
  }

  @override
  void initState(BuildContext context) {
    headerModel = createModel(context, () => HeaderModel());
    navBar12Model = createModel(context, () => NavBar12Model());
  }
}
