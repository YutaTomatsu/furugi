import '/components/nav_menu_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'admin_product_category_widget.dart' show AdminProductCategoryWidget;
import 'package:flutter/material.dart';

class AdminProductCategoryModel
    extends FlutterFlowModel<AdminProductCategoryWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for NavMenu component.
  late NavMenuModel navMenuModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  @override
  void initState(BuildContext context) {
    navMenuModel = createModel(context, () => NavMenuModel());
  }

  @override
  void dispose() {
    navMenuModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
