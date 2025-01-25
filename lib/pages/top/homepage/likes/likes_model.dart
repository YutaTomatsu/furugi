import '/components/header_widget.dart';
import '/components/nav_bar12_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'likes_widget.dart' show LikesWidget;
import 'package:flutter/material.dart';

class LikesModel extends FlutterFlowModel<LikesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header component.
  late HeaderModel headerModel;
  // Model for NavBar12 component.
  late NavBar12Model navBar12Model;

  @override
  void initState(BuildContext context) {
    headerModel = createModel(context, () => HeaderModel());
    navBar12Model = createModel(context, () => NavBar12Model());
  }

  @override
  void dispose() {
    headerModel.dispose();
    navBar12Model.dispose();
  }
}
