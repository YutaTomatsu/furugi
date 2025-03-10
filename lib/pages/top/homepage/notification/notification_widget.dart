import 'package:furugi_with_template/components/nav_bar12_widget.dart';
import 'package:provider/provider.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'notification_model.dart';
export 'notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({Key? key}) : super(key: key);
  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  late NotificationModel _model;

  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationModel());

    // フォアグラウンドでのメッセージ受信
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      // 通知を表示するロジックをここに追加
      if (notification != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(notification.title ?? ''),
            content: Text(notification.body ?? ''),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });

    // ユーザーが通知をタップしたときの処理
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // 必要に応じて画面遷移などを行う
    });
  }

  @override
  Widget build(BuildContext context) {
    // UI の構築
    return Scaffold(
      bottomNavigationBar: Consumer<NavBar12Model>(
        builder: (context, model, child) {
          return NavBar12Widget();
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white, // ← ヘッダー背景色
        foregroundColor: Colors.black, // ← ヘッダーテキスト色
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          '通知',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Inter',
                fontSize: 16.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            onPressed: () {
              context.pushNamed('Cart'); // ← カート画面に遷移
            },
          ),
        ],
      ),
      body: Center(
        child: const Text('ここに通知が表示されます'),
      ),
    );
  }
}
