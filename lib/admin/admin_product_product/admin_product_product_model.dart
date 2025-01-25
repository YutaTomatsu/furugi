import '/components/nav_menu_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'admin_product_product_widget.dart' show AdminProductProductWidget;
import 'package:flutter/material.dart';

class AdminProductProductModel
    extends FlutterFlowModel<AdminProductProductWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for NavMenu component.
  late NavMenuModel navMenuModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

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
