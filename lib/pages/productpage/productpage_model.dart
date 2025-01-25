import '/components/header_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'productpage_widget.dart' show ProductpageWidget;
import 'package:flutter/material.dart';

class ProductpageModel extends FlutterFlowModel<ProductpageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header component.
  late HeaderModel headerModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    headerModel = createModel(context, () => HeaderModel());
  }

  @override
  void dispose() {
    headerModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
