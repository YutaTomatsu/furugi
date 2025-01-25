import '/components/header_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'shops_widget.dart' show ShopsWidget;
import 'package:flutter/material.dart';

class ShopsModel extends FlutterFlowModel<ShopsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header component.
  late HeaderModel headerModel;
  // State field(s) for SearchField widget.
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {
    headerModel = createModel(context, () => HeaderModel());
  }

  @override
  void dispose() {
    headerModel.dispose();
    searchFieldFocusNode?.dispose();
    searchFieldTextController?.dispose();
  }
}
