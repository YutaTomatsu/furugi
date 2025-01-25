import '/components/nav_bar12_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for RatingBar widget.
  double? ratingBarValue1;
  // State field(s) for RatingBar widget.
  double? ratingBarValue2;
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
