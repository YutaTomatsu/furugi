import '/components/nav_bar12_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'add_contents_model.dart';
export 'add_contents_model.dart';

class AddContentsWidget extends StatefulWidget {
  const AddContentsWidget({super.key});

  @override
  State<AddContentsWidget> createState() => _AddContentsWidgetState();
}

class _AddContentsWidgetState extends State<AddContentsWidget>
    with TickerProviderStateMixin {
  late AddContentsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddContentsModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 80.0.ms,
            duration: 330.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 210.0.ms,
            begin: const Offset(0.0, 100.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: 600.0,
                decoration: const BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 250.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).furugiMainColor,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.network(
                            '',
                          ).image,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).furugiMainColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('CreateContent');
                            },
                            child: Text(
                              '古着を出品する',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 19.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          Icon(
                            Icons.man,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 250.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.network(
                            '',
                          ).image,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: const Color(0xFF638091),
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('CreateContentCopy');
                            },
                            child: Text(
                              '古着屋を登録する',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context)
                                        .furugiMainColor,
                                    fontSize: 19.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                          Icon(
                            Icons.home_work,
                            color: FlutterFlowTheme.of(context).furugiMainColor,
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animateOnPageLoad(
                  animationsMap['containerOnPageLoadAnimation']!),
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: wrapWithModel(
                  model: _model.navBar12Model,
                  updateCallback: () => safeSetState(() {}),
                  child: const NavBar12Widget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
