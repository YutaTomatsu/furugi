import '/flutter_flow/flutter_flow_util.dart';
import 'my_account_widget.dart' show MyaccountWidget;
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

  String? uploadedFileUrl;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
