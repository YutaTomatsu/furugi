import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'menuoptions_model.dart';
export 'menuoptions_model.dart';

class MenuoptionsWidget extends StatefulWidget {
  const MenuoptionsWidget({super.key});

  @override
  State<MenuoptionsWidget> createState() => _MenuoptionsWidgetState();
}

class _MenuoptionsWidgetState extends State<MenuoptionsWidget> {
  late MenuoptionsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuoptionsModel());
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
      height: 60.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.settings_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          Text(
            'Dashboard',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  letterSpacing: 0.0,
                ),
          ),
        ].divide(const SizedBox(width: 12.0)).addToStart(const SizedBox(width: 24.0)),
      ),
    );
  }
}
