import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_checkbox_group.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'create_content_copy_model.dart';
export 'create_content_copy_model.dart';
import '../shop_register_confirm/shop_register_confirm_widget.dart';

class CreateContentCopyWidget extends StatefulWidget {
  const CreateContentCopyWidget({super.key});

  @override
  State<CreateContentCopyWidget> createState() =>
      _CreateContentCopyWidgetState();
}

class _CreateContentCopyWidgetState extends State<CreateContentCopyWidget> {
  late CreateContentCopyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _prefectureTextController =
      TextEditingController();
  final FocusNode _prefectureFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String? _imageError;
  String? _postalCodeError;

  List<String> _errorMessages = [];

  // 各フィールド
  final GlobalKey<FormFieldState<String>> _shopNameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _postalCodeKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _prefectureKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _addressKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _tellKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _hpKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _featuresKey =
      GlobalKey<FormFieldState<String>>();

  // ※ 価格帯はテキスト入力から選択式に変更
  //   → FlutterFlowCheckboxGroup で複数選択を想定（例：100円～ / 500円～ / 1000円～など）
  //   もし単一選択ならRadioボタンかRadioGroupを使ってください
  List<String> _uploadedFileUrls = [];
  List<FFUploadedFile> _uploadedLocalFiles = [];
  List<String> _uploadedFilePaths = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateContentCopyModel());

    // 既存のTextController初期化など
    _model.shopNameTextController ??= TextEditingController();
    _model.shopNameFocusNode ??= FocusNode();
    _model.postTextController ??= TextEditingController();
    _model.postFocusNode ??= FocusNode();
    _model.address4TextController ??= TextEditingController();
    _model.address4FocusNode ??= FocusNode();
    _model.tellTextController ??= TextEditingController();
    _model.tellFocusNode ??= FocusNode();
    _model.hpTextController ??= TextEditingController();
    _model.hpFocusNode ??= FocusNode();
    _model.featuresTextController ??= TextEditingController();
    _model.featuresFocusNode ??= FocusNode();

    // 価格帯はテキスト入力を廃止 → 選択式
    // _model.priceRangeTextController は不要だが、もし残しておくなら使用しないでOK
    _model.priceRangeValueController ??= FormFieldController<List<String>>([]);
  }

  @override
  void dispose() {
    _model.dispose();
    _prefectureTextController.dispose();
    _prefectureFocusNode.dispose();
    super.dispose();
  }

  String? _validatePostalCode(String? value) {
    if (value == null || value.isEmpty) {
      return '郵便番号を入力してください';
    } else if (!RegExp(r'^\d{7}$').hasMatch(value)) {
      return '7桁の数字を入力してください（ハイフンなし）';
    } else if (_postalCodeError != null) {
      return _postalCodeError;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ========= 画像選択 =========
                _buildImagePicker(),

                // ========= 店名 =========
                _buildTextField(
                  label: '店名',
                  formKey: _shopNameKey,
                  controller: _model.shopNameTextController!,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return '店名を入力してください';
                    }
                    return null;
                  },
                ),

                // ========= 郵便番号 + 検索ボタン =========
                _buildPostalCodeInput(),

                // ========= 都道府県(テキスト表示) =========
                _buildPrefectureInput(),

                // ========= 住所 =========
                _buildTextField(
                  label: '住所',
                  formKey: _addressKey,
                  controller: _model.address4TextController!,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return '住所を入力してください';
                    }
                    return null;
                  },
                ),

                // ========= 電話番号 =========
                _buildTextField(
                  label: '電話番号',
                  formKey: _tellKey,
                  controller: _model.tellTextController!,
                ),

                // ========= HP =========
                _buildTextField(
                  label: 'HP',
                  formKey: _hpKey,
                  controller: _model.hpTextController!,
                  required: false,
                ),

                // ========= 価格帯(チェックボックス) =========
                _buildPriceRangeSelection(),

                // ========= 支払い方法(Checkbox) =========
                _buildPaymentSelection(),

                // ========= 定休日(Checkbox) =========
                _buildClosedDaysSelection(),

                // ========= ジェンダー(Checkbox) =========
                _buildGendersSelection(),

                // ========= 駐車場(Checkbox) =========
                _buildParkingSelection(),

                // ========= 特徴(任意) =========
                _buildTextField(
                  label: '特徴（任意）',
                  formKey: _featuresKey,
                  controller: _model.featuresTextController!,
                  required: false,
                ),

                // ========= ボタン群 =========
                _buildBottomButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //----- 画像選択コンポーネント -----
  Widget _buildImagePicker() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () async {
              final selectedMedia = await selectMedia(
                mediaSource: MediaSource.photoGallery,
                multiImage: true,
              );
              if (selectedMedia != null &&
                  selectedMedia.every(
                      (m) => validateFileFormat(m.storagePath, context))) {
                final newMedia = selectedMedia.where((m) {
                  return !_uploadedFilePaths.contains(m.storagePath);
                }).toList();
                if (newMedia.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('すでに選択された画像です。')),
                  );
                  return;
                }
                if (newMedia.length + _uploadedLocalFiles.length > 10) {
                  setState(() {
                    _imageError = '画像は最大10枚まで選択できます';
                  });
                  return;
                }

                setState(() => _model.isDataUploading = true);
                var selectedUploadedFiles = <FFUploadedFile>[];
                var downloadUrls = <String>[];

                try {
                  selectedUploadedFiles = newMedia.map((m) {
                    return FFUploadedFile(
                      name: m.storagePath.split('/').last,
                      bytes: m.bytes,
                      height: m.dimensions?.height,
                      width: m.dimensions?.width,
                      blurHash: m.blurHash,
                    );
                  }).toList();

                  downloadUrls = (await Future.wait(
                    newMedia.map(
                        (m) async => await uploadData(m.storagePath, m.bytes)),
                  ))
                      .where((u) => u != null)
                      .map((u) => u!)
                      .toList();
                } finally {
                  _model.isDataUploading = false;
                }

                if (selectedUploadedFiles.length == newMedia.length &&
                    downloadUrls.length == newMedia.length) {
                  setState(() {
                    _uploadedLocalFiles.addAll(selectedUploadedFiles);
                    _uploadedFileUrls.addAll(downloadUrls);
                    _uploadedFilePaths
                        .addAll(newMedia.map((m) => m.storagePath));
                    _imageError = null;
                  });
                } else {
                  setState(() {});
                  return;
                }
              }
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '画像を選択（最大10枚）',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
        if (_uploadedLocalFiles.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _uploadedLocalFiles.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.network(
                        _uploadedFileUrls[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _uploadedLocalFiles.removeAt(index);
                            _uploadedFileUrls.removeAt(index);
                            _uploadedFilePaths.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        if (_imageError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _imageError!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  //----- 通常のテキストフィールド -----
  Widget _buildTextField({
    required String label,
    required GlobalKey<FormFieldState<String>> formKey,
    required TextEditingController controller,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return Column(
      children: [
        Text(label, style: FlutterFlowTheme.of(context).bodyMedium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextFormField(
            key: formKey,
            controller: controller,
            decoration: InputDecoration(
              labelText: '$labelを入力',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: validator ??
                (val) {
                  if (required && (val == null || val.isEmpty)) {
                    return '$labelを入力してください';
                  }
                  return null;
                },
          ),
        ),
      ],
    );
  }

  //----- 郵便番号 + 検索ボタン -----
  Widget _buildPostalCodeInput() {
    return Column(
      children: [
        const Text('郵便番号'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                key: _postalCodeKey,
                controller: _model.postTextController,
                decoration: InputDecoration(
                  labelText: '郵便番号を入力（7桁）',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(7),
                ],
                validator: _validatePostalCode,
                onChanged: (value) {
                  setState(() {
                    _postalCodeError = null;
                    _formKey.currentState!.validate();
                  });
                },
              ),
              if (_postalCodeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _postalCodeError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
        FFButtonWidget(
          onPressed: () async {
            String? validationError =
                _validatePostalCode(_model.postTextController.text);
            if (validationError != null) {
              setState(() => _postalCodeError = validationError);
              return;
            } else {
              setState(() => _postalCodeError = null);
            }

            _model.apiResultac6 = await ZipcodeAPICall.call(
              zipcode: _model.postTextController.text,
            );

            if ((_model.apiResultac6?.succeeded ?? false) &&
                getJsonField((_model.apiResultac6?.jsonBody ?? ''),
                        r'''$.results''') !=
                    null) {
              final address1 = getJsonField(
                      (_model.apiResultac6?.jsonBody ?? ''),
                      r'''$.results[0].address1''')
                  .toString();
              final address2 = getJsonField(
                      (_model.apiResultac6?.jsonBody ?? ''),
                      r'''$.results[0].address2''')
                  .toString();
              final address3 = getJsonField(
                      (_model.apiResultac6?.jsonBody ?? ''),
                      r'''$.results[0].address3''')
                  .toString();

              _prefectureTextController.text = address1;
              _model.address4TextController.text = '$address2$address3';
              setState(() => _postalCodeError = null);
            } else {
              setState(() => _postalCodeError = '正しい郵便番号を入力してください');
            }
          },
          text: '検索',
          options: FFButtonOptions(
            height: 40,
            color: FlutterFlowTheme.of(context).primary,
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  //----- 都道府県(テキスト) -----
  Widget _buildPrefectureInput() {
    return Column(
      children: [
        const Text('都道府県'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextFormField(
            key: _prefectureKey,
            controller: _prefectureTextController,
            decoration: InputDecoration(
              labelText: '都道府県がここに表示されます',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: FlutterFlowTheme.of(context).primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return '都道府県を入力してください';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  //----- 価格帯(チェックボックス) -----
  Widget _buildPriceRangeSelection() {
    // 想定：複数選択可 (100円～ / 500円～ / 1000円～ / 2000円～ など)
    // ※ 単一選択ならラジオボタンを使ってください
    const priceOptions = ['100円～', '500円～', '1000円～', '2000円～', '5000円～'];
    return Column(
      children: [
        const Text('価格帯'),
        FlutterFlowCheckboxGroup(
          options: priceOptions,
          onChanged: (val) {
            setState(() => _model.priceRangeValues = val);
          },
          controller: _model.priceRangeValueController ??=
              FormFieldController<List<String>>([]),
          activeColor: FlutterFlowTheme.of(context).primary,
          checkColor: FlutterFlowTheme.of(context).info,
          checkboxBorderColor: FlutterFlowTheme.of(context).secondaryText,
          textStyle: FlutterFlowTheme.of(context).bodyMedium,
          checkboxBorderRadius: BorderRadius.circular(4.0),
        ),
      ],
    );
  }

  //----- 支払い方法(Checkbox)
  Widget _buildPaymentSelection() {
    return Column(
      children: [
        const Text('支払い方法'),
        StreamBuilder<List<PaymentsRecord>>(
          stream: queryPaymentsRecord(
            queryBuilder: (paymentsRecord) => paymentsRecord.orderBy('sort_no'),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final payments = snapshot.data!;
            return FlutterFlowCheckboxGroup(
              options: payments.map((p) => p.payment).toList(),
              onChanged: (val) => setState(() => _model.paymentValues = val),
              controller: _model.paymentValueController ??=
                  FormFieldController<List<String>>([]),
              activeColor: FlutterFlowTheme.of(context).primary,
              checkColor: FlutterFlowTheme.of(context).info,
              checkboxBorderColor: FlutterFlowTheme.of(context).secondaryText,
              textStyle: FlutterFlowTheme.of(context).bodyMedium,
              checkboxBorderRadius: BorderRadius.circular(4.0),
            );
          },
        ),
      ],
    );
  }

  //----- 定休日(Checkbox)
  Widget _buildClosedDaysSelection() {
    return Column(
      children: [
        const Text('定休日'),
        StreamBuilder<List<ClosedDaysRecord>>(
          stream: queryClosedDaysRecord(
            queryBuilder: (closedDaysRecord) =>
                closedDaysRecord.orderBy('sort_no'),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final days = snapshot.data!;
            return FlutterFlowCheckboxGroup(
              options: days.map((d) => d.day).toList(),
              onChanged: (val) => setState(() => _model.closedDaysValues = val),
              controller: _model.closedDaysValueController ??=
                  FormFieldController<List<String>>([]),
              activeColor: FlutterFlowTheme.of(context).primary,
              checkColor: FlutterFlowTheme.of(context).info,
              checkboxBorderColor: FlutterFlowTheme.of(context).secondaryText,
              textStyle: FlutterFlowTheme.of(context).bodyMedium,
              checkboxBorderRadius: BorderRadius.circular(4.0),
            );
          },
        ),
      ],
    );
  }

  //----- ジェンダー(Checkbox)
  Widget _buildGendersSelection() {
    return Column(
      children: [
        const Text('ジェンダー'),
        StreamBuilder<List<GendersRecord>>(
          stream: queryGendersRecord(
            queryBuilder: (gendersRecord) => gendersRecord.orderBy('sort_no'),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final list = snapshot.data!;
            return FlutterFlowCheckboxGroup(
              options: list.map((g) => g.gender).toList(),
              onChanged: (val) => setState(() => _model.gendersValues = val),
              controller: _model.gendersValueController ??=
                  FormFieldController<List<String>>([]),
              activeColor: FlutterFlowTheme.of(context).primary,
              checkColor: FlutterFlowTheme.of(context).info,
              checkboxBorderColor: FlutterFlowTheme.of(context).secondaryText,
              textStyle: FlutterFlowTheme.of(context).bodyMedium,
              checkboxBorderRadius: BorderRadius.circular(4.0),
            );
          },
        ),
      ],
    );
  }

  //----- 駐車場(Checkbox)
  Widget _buildParkingSelection() {
    return Column(
      children: [
        const Text('駐車場'),
        StreamBuilder<List<ParkingRecord>>(
          stream: queryParkingRecord(
            queryBuilder: (parkingRecord) => parkingRecord.orderBy('sort_no'),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final list = snapshot.data!;
            return FlutterFlowCheckboxGroup(
              options: list.map((p) => p.exist).toList(),
              onChanged: (val) => setState(() => _model.parkingValues = val),
              controller: _model.parkingValueController ??=
                  FormFieldController<List<String>>([]),
              activeColor: FlutterFlowTheme.of(context).primary,
              checkColor: FlutterFlowTheme.of(context).info,
              checkboxBorderColor: FlutterFlowTheme.of(context).secondaryText,
              textStyle: FlutterFlowTheme.of(context).bodyMedium,
              checkboxBorderRadius: BorderRadius.circular(4.0),
            );
          },
        ),
      ],
    );
  }

  //----- ボタン(下書き & 確認) -----
  Widget _buildBottomButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // 下書き保存
            FFButtonWidget(
              onPressed: () {
                debugPrint('下書きを保存しました。');
              },
              text: '下書きを保存',
              options: FFButtonOptions(
                height: 40,
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter',
                      color: Colors.black,
                    ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 8),
            // 確認画面へ
            FFButtonWidget(
              onPressed: () {
                bool isValid = _formKey.currentState!.validate();
                if (_postalCodeError != null) {
                  isValid = false;
                }
                // 画像チェック
                if (_uploadedFileUrls.isEmpty) {
                  setState(() => _imageError = '画像を選択してください');
                  isValid = false;
                } else {
                  setState(() => _imageError = null);
                }

                List<String> errorMessages = [];
                if (_shopNameKey.currentState?.errorText != null) {
                  errorMessages.add(_shopNameKey.currentState!.errorText!);
                }
                if (_postalCodeKey.currentState?.errorText != null) {
                  errorMessages.add(_postalCodeKey.currentState!.errorText!);
                }
                if (_postalCodeError != null) {
                  errorMessages.add(_postalCodeError!);
                }
                if (_prefectureKey.currentState?.errorText != null) {
                  errorMessages.add(_prefectureKey.currentState!.errorText!);
                }
                if (_addressKey.currentState?.errorText != null) {
                  errorMessages.add(_addressKey.currentState!.errorText!);
                }
                if (_tellKey.currentState?.errorText != null) {
                  errorMessages.add(_tellKey.currentState!.errorText!);
                }
                if (_hpKey.currentState?.errorText != null) {
                  errorMessages.add(_hpKey.currentState!.errorText!);
                }
                if (_imageError != null) {
                  errorMessages.add(_imageError!);
                }

                setState(() => _errorMessages = errorMessages);

                if (!isValid) return;

                // shop_register_confirm_widget.dart に渡すデータ
                final shopData = {
                  'shopName': _model.shopNameTextController?.text,
                  'postalCode': _model.postTextController?.text,
                  'prefecture': _prefectureTextController.text,
                  'address': _model.address4TextController?.text,
                  'tel': _model.tellTextController?.text,
                  'hp': _model.hpTextController?.text,
                  // priceRange は複数選択
                  'priceRange': _model.priceRangeValues,
                  'features': _model.featuresTextController?.text,
                  'imageUrls': _uploadedFileUrls,
                  'payment': _model.paymentValues,
                  'closedDays': _model.closedDaysValues,
                  'genders': _model.gendersValues,
                  'parking': _model.parkingValues,
                };

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopRegisterConfirmWidget(
                      shopData: shopData,
                    ),
                  ),
                );
              },
              text: '古着屋を確認する',
              options: FFButtonOptions(
                height: 40,
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter',
                      color: Colors.black,
                    ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        if (_errorMessages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                const Text(
                  '以下のエラーが発生しています',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ..._errorMessages.map((msg) => Text(
                      msg,
                      style: const TextStyle(color: Colors.red),
                    )),
              ],
            ),
          ),
      ],
    );
  }
}
