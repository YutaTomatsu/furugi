import '/components/header_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'b_u_y_check_out_widget.dart' show BUYCheckOutWidget;
import 'package:flutter/material.dart';

class BUYCheckOutModel extends FlutterFlowModel<BUYCheckOutWidget> {
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
