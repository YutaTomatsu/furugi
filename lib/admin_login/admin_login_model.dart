import '/flutter_flow/flutter_flow_util.dart';
import 'admin_login_widget.dart' show AdminLoginWidget;
import 'package:flutter/material.dart';

class AdminLoginModel extends FlutterFlowModel<AdminLoginWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for email_login widget.
  FocusNode? emailLoginFocusNode;
  TextEditingController? emailLoginTextController;
  String? Function(BuildContext, String?)? emailLoginTextControllerValidator;
  String? _emailLoginTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  // State field(s) for password_login widget.
  FocusNode? passwordLoginFocusNode;
  TextEditingController? passwordLoginTextController;
  late bool passwordLoginVisibility;
  String? Function(BuildContext, String?)? passwordLoginTextControllerValidator;
  String? _passwordLoginTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    emailLoginTextControllerValidator = _emailLoginTextControllerValidator;
    passwordLoginVisibility = false;
    passwordLoginTextControllerValidator =
        _passwordLoginTextControllerValidator;
  }

  @override
  void dispose() {
    emailLoginFocusNode?.dispose();
    emailLoginTextController?.dispose();

    passwordLoginFocusNode?.dispose();
    passwordLoginTextController?.dispose();
  }
}
