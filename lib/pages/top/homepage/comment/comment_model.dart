import '/flutter_flow/flutter_flow_util.dart';
import 'comment_widget.dart' show CommentWidget;
import 'package:flutter/material.dart';

class CommentModel extends FlutterFlowModel<CommentWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for UserComment widget.
  FocusNode? userCommentFocusNode;
  TextEditingController? userCommentTextController;
  String? Function(BuildContext, String?)? userCommentTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    userCommentFocusNode?.dispose();
    userCommentTextController?.dispose();
  }
}
