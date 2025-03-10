import 'package:furugi_with_template/flutter_flow/flutter_flow_google_map.dart';
import '/components/header_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'shop_screen_widget.dart' show ShopScreenWidget;
import 'package:flutter/material.dart';

class ShopScreenModel extends FlutterFlowModel<ShopScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for header component.
  late HeaderModel headerModel;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {
    headerModel = createModel(context, () => HeaderModel());
  }

  @override
  void dispose() {
    headerModel.dispose();
  }
}
