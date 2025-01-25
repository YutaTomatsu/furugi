import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_colorpicker/flutterflow_colorpicker.dart';
import 'nav_bar12_model.dart';
export 'nav_bar12_model.dart';

class NavBar12Widget extends StatefulWidget {
  const NavBar12Widget({super.key});

  @override
  State<NavBar12Widget> createState() => _NavBar12WidgetState();
}

class _NavBar12WidgetState extends State<NavBar12Widget> {
  late NavBar12Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NavBar12Model());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.0,
      decoration: const BoxDecoration(
        color: Color(0x00EEEEEE),
      ),
      child: Material(
        color: Colors.transparent,
        elevation: 0.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Container(
          width: double.infinity,
          height: 70.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 50.0,
                icon: const Icon(
                  Icons.home_rounded,
                  color: Color(0xFF9299A1),
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pushNamed('HomePage');

                  final colorPickedColor = await showFFColorPicker(
                    context,
                    currentColor: _model.colorPicked ??=
                        FlutterFlowTheme.of(context).primary,
                    showRecentColors: true,
                    allowOpacity: true,
                    textColor: FlutterFlowTheme.of(context).primaryText,
                    secondaryTextColor:
                        FlutterFlowTheme.of(context).secondaryText,
                    backgroundColor:
                        FlutterFlowTheme.of(context).primaryBackground,
                    primaryButtonBackgroundColor:
                        FlutterFlowTheme.of(context).primary,
                    primaryButtonTextColor: Colors.white,
                    primaryButtonBorderColor: Colors.transparent,
                    displayAsBottomSheet: isMobileWidth(context),
                  );

                  if (colorPickedColor != null) {
                    safeSetState(() => _model.colorPicked = colorPickedColor);
                  }
                },
              ),
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 50.0,
                icon: const Icon(
                  Icons.location_pin,
                  color: Color(0xFF9299A1),
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pushNamed('Map');
                },
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 25.0,
                    borderWidth: 1.0,
                    buttonSize: 60.0,
                    fillColor: FlutterFlowTheme.of(context).primary,
                    icon: Icon(
                      Icons.add,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 30.0,
                    ),
                    onPressed: () async {
                      context.pushNamed('AddContents');
                    },
                  ),
                ],
              ),
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 50.0,
                icon: const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFF9299A1),
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pushNamed('Likes');
                },
              ),
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 50.0,
                icon: const Icon(
                  Icons.attach_money_rounded,
                  color: Color(0xFF9299A1),
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pushNamed('Purchases');
                },
              ),
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 50.0,
                icon: const Icon(
                  Icons.person,
                  color: Color(0xFF9299A1),
                  size: 24.0,
                ),
                onPressed: () async {
                  context.pushNamed('Profile');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
