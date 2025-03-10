import '/components/header_widget.dart';
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

  @override
  void initState(BuildContext context) {
    headerModel = createModel(context, () => HeaderModel());
  }

  @override
  void dispose() {
    headerModel.dispose();
  }
}
