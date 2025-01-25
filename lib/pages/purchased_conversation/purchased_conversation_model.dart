import '/flutter_flow/flutter_flow_util.dart';
import 'purchased_conversation_widget.dart' show PurchasedConversationWidget;
import 'package:flutter/material.dart';

class PurchasedConversationModel
    extends FlutterFlowModel<PurchasedConversationWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for UserComment widget.
  FocusNode? userCommentFocusNode;
  TextEditingController? userCommentTextController;
  String? Function(BuildContext, String?)? userCommentTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController1?.dispose();

    userCommentFocusNode?.dispose();
    userCommentTextController?.dispose();
  }
}
