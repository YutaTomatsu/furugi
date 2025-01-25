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
  void initState() {
    super.initState();

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
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
        child: const Text('ここに通知が表示されます'),
      ),
    );
  }
}
