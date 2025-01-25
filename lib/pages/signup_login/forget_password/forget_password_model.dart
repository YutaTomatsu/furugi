import '/flutter_flow/flutter_flow_util.dart';
import 'forget_password_widget.dart' show ForgetPasswordWidget;
import 'package:flutter/material.dart';

class ForgetPasswordModel extends FlutterFlowModel<ForgetPasswordWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for email_Reset widget.
  FocusNode? emailResetFocusNode;
  TextEditingController? emailResetTextController;
  String? Function(BuildContext, String?)? emailResetTextControllerValidator;
  String? _emailResetTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Email Field is required';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    emailResetTextControllerValidator = _emailResetTextControllerValidator;
  }

  @override
  void dispose() {
    emailResetFocusNode?.dispose();
    emailResetTextController?.dispose();
  }
}
