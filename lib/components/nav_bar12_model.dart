import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'nav_bar12_widget.dart' show NavBar12Widget;

class NavBar12Model extends ChangeNotifier {
  static final NavBar12Model _instance = NavBar12Model._internal();

  factory NavBar12Model() {
    return _instance;
  }

  NavBar12Model._internal(); // プライベートコンストラクタ

  Color? colorPicked;

  void updateColor(Color newColor) {
    colorPicked = newColor;
    notifyListeners(); // 変更を通知
  }
}
