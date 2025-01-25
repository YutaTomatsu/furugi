import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'create_content_widget.dart' show CreateContentWidget;
import 'package:flutter/material.dart';

class CreateContentModel extends FlutterFlowModel<CreateContentWidget> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  // State field(s) for product_Name widget.
  FocusNode? productNameFocusNode;
  TextEditingController? productNameTextController;
  String? Function(BuildContext, String?)? productNameTextControllerValidator;
  // State field(s) for product_Detail widget.
  FocusNode? productDetailFocusNode;
  TextEditingController? productDetailTextController;
  String? Function(BuildContext, String?)? productDetailTextControllerValidator;
  // State field(s) for category widget.
  List<String>? categoryValue;
  FormFieldController<List<String>>? categoryValueController;
  List<CategoriesRecord>? categoryPreviousSnapshot;
  // State field(s) for condition widget.
  String? conditionValue;
  FormFieldController<String>? conditionValueController;
  // State field(s) for price widget.
  FocusNode? priceFocusNode;
  TextEditingController? priceTextController;
  String? Function(BuildContext, String?)? priceTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    productNameFocusNode?.dispose();
    productNameTextController?.dispose();

    productDetailFocusNode?.dispose();
    productDetailTextController?.dispose();

    priceFocusNode?.dispose();
    priceTextController?.dispose();
  }
}
