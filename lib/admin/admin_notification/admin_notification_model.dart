import '/components/nav_menu_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'admin_notification_widget.dart' show AdminNotificationWidget;
import 'package:flutter/material.dart';

class AdminNotificationModel extends FlutterFlowModel<AdminNotificationWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for NavMenu component.
  late NavMenuModel navMenuModel;

  @override
  void initState(BuildContext context) {
    navMenuModel = createModel(context, () => NavMenuModel());
  }

  @override
  void dispose() {
    navMenuModel.dispose();
  }
}
