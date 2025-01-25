import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'create_content_copy_widget.dart' show CreateContentCopyWidget;
import 'package:flutter/material.dart';
import 'dart:typed_data';

class CreateContentCopyModel extends FlutterFlowModel<CreateContentCopyWidget> {
  /// State fields for stateful widgets in this page.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  // State field(s) for shop_Name widget.
  FocusNode? shopNameFocusNode;
  TextEditingController? shopNameTextController;
  String? Function(BuildContext, String?)? shopNameTextControllerValidator;

  // State field(s) for prefecture widget. (未使用なら削除可)
  String? prefectureValue;
  FormFieldController<String>? prefectureValueController;

  // State field(s) for post widget.
  FocusNode? postFocusNode;
  TextEditingController? postTextController;
  String? Function(BuildContext, String?)? postTextControllerValidator;
  ApiCallResponse? apiResultac6; // zipcodeAPI結果

  // State field(s) for address4 widget.
  FocusNode? address4FocusNode;
  TextEditingController? address4TextController;
  String? Function(BuildContext, String?)? address4TextControllerValidator;

  // State field(s) for tell widget.
  FocusNode? tellFocusNode;
  TextEditingController? tellTextController;
  String? Function(BuildContext, String?)? tellTextControllerValidator;

  // State field(s) for hp widget.
  FocusNode? hpFocusNode;
  TextEditingController? hpTextController;
  String? Function(BuildContext, String?)? hpTextControllerValidator;

  // [旧] priceRange テキスト入力  (今は不要なら削除可)
  FocusNode? priceRangeFocusNode;
  TextEditingController? priceRangeTextController;
  String? Function(BuildContext, String?)? priceRangeTextControllerValidator;

  // State field(s) for priceRange(CheckboxGroup).
  FormFieldController<List<String>>? priceRangeValueController;
  List<String>? get priceRangeValues => priceRangeValueController?.value;
  set priceRangeValues(List<String>? val) =>
      priceRangeValueController?.value = val;

  // State field(s) for payment(CheckboxGroup).
  FormFieldController<List<String>>? paymentValueController;
  List<String>? get paymentValues => paymentValueController?.value;
  set paymentValues(List<String>? val) => paymentValueController?.value = val;

  // State field(s) for closedDays(CheckboxGroup).
  FormFieldController<List<String>>? closedDaysValueController;
  List<String>? get closedDaysValues => closedDaysValueController?.value;
  set closedDaysValues(List<String>? val) =>
      closedDaysValueController?.value = val;

  // State field(s) for genders(CheckboxGroup).
  FormFieldController<List<String>>? gendersValueController;
  List<String>? get gendersValues => gendersValueController?.value;
  set gendersValues(List<String>? val) => gendersValueController?.value = val;

  // State field(s) for parking(CheckboxGroup).
  FormFieldController<List<String>>? parkingValueController;
  List<String>? get parkingValues => parkingValueController?.value;
  set parkingValues(List<String>? val) => parkingValueController?.value = val;

  // State field(s) for features widget.
  FocusNode? featuresFocusNode;
  TextEditingController? featuresTextController;
  String? Function(BuildContext, String?)? featuresTextControllerValidator;

  // Geocoding API
  ApiCallResponse? geocoding;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    // 必要に応じてコントローラやFocusNodeをdispose
    shopNameFocusNode?.dispose();
    shopNameTextController?.dispose();

    postFocusNode?.dispose();
    postTextController?.dispose();

    address4FocusNode?.dispose();
    address4TextController?.dispose();

    tellFocusNode?.dispose();
    tellTextController?.dispose();

    hpFocusNode?.dispose();
    hpTextController?.dispose();

    priceRangeFocusNode?.dispose();
    priceRangeTextController?.dispose();

    featuresFocusNode?.dispose();
    featuresTextController?.dispose();
  }
}
