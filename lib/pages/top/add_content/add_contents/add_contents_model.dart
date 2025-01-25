import '/components/nav_bar12_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'add_contents_widget.dart' show AddContentsWidget;
import 'package:flutter/material.dart';

class AddContentsModel extends FlutterFlowModel<AddContentsWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for NavBar12 component.
  late NavBar12Model navBar12Model;

  @override
  void initState(BuildContext context) {
    navBar12Model = createModel(context, () => NavBar12Model());
  }

  @override
  void dispose() {
    navBar12Model.dispose();
  }
}
