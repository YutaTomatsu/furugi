import '/components/header_widget.dart';
import '/components/nav_bar12_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'product_screen_widget.dart' show ProductScreenWidget;
import 'package:flutter/material.dart';

class ProductScreenModel extends FlutterFlowModel<ProductScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header component.
  late HeaderModel headerModel;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
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
