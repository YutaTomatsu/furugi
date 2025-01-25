import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import '/components/header_model.dart';
import '/components/nav_bar12_model.dart';

class PurchasesModel extends FlutterFlowModel {
  /// プロパティ
  late HeaderModel headerModel;
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
