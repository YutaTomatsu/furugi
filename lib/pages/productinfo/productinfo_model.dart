import '/components/header_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'productinfo_widget.dart' show ProductinfoWidget;
import 'package:flutter/material.dart';

class ProductinfoModel extends FlutterFlowModel<ProductinfoWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header component.
  late HeaderModel headerModel;

  @override
  void initState(BuildContext context) {
    headerModel = createModel(context, () => HeaderModel());
  }

  @override
  void dispose() {
    headerModel.dispose();
  }
}
