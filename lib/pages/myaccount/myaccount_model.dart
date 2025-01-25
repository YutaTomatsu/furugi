import '/components/nav_bar12_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'myaccount_widget.dart' show MyaccountWidget;
import 'package:flutter/material.dart';

class MyaccountModel extends FlutterFlowModel<MyaccountWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for NavBar12 component.
  late NavBar12Model navBar12Model;

  @override
  void initState(BuildContext context) {
    navBar12Model = createModel(context, () => NavBar12Model());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    navBar12Model.dispose();
  }
}
