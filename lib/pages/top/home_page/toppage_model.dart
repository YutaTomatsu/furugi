import '/components/header_widget.dart';
import '/components/nav_bar12_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'toppage_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header component.
  late HeaderModel headerModel;
  // State field(s) for SearchField widget.
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;
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
    searchFieldFocusNode?.dispose();
    searchFieldTextController?.dispose();
    headerModel.dispose();
    navBar12Model.dispose();
  }
}
