import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // Stripeを使う場合に追加

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart'; // initFirebase()等が定義されている
import 'flutter_flow/flutter_flow_util.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // バックグラウンド時のメッセージ処理
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // GoRouter設定
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // ブラウザ上のURLに「#/」が付かないようにする
  usePathUrlStrategy();

  // Firebase 初期化 (firebase_config.dart の initFirebase で Firebase.initializeApp() を行っている想定)
  await initFirebase();

  // Stripe公開鍵（テスト用）
  // ApplePay / GooglePay を使わないなら applySettings() は呼び出さなくてOK
  Stripe.publishableKey =
      'pk_test_51QDLEkDCX7s7s38MMydMF6bLoMd86Z3S2BOnY1ANWx2R9WKew1NaRyTj36vmULOFMtd68kZFZXp0R3xi9X1wqkqG00jTIfkV2z';
  // Stripe.instance.applySettings(); // ApplePay/GooglePayを使うなら

  // FFAppState の初期化 (アプリ状態管理)
  final appState = FFAppState();
  await appState.initializePersistedState();

  // App Check有効化 (例: Play Integrity / Debug token)
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    ChangeNotifierProvider(
      create: (context) => appState,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

void saveFcmToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null && currentUserReference != null) {
    await currentUserReference?.update({'fcmToken': token});
  }
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  // ユーザ認証状態監視用
  late Stream<BaseAuthUser> userStream;
  final authUserSub = authenticatedUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();

    // アプリ共通の状態管理Notifierを取得し、ルーターを作成
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    // FirebaseAuth ユーザー監視
    userStream = furugiWithTemplateFirebaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });

    // JWTトークン監視
    jwtTokenStream.listen((_) {});

    // スプラッシュ画面を1秒後に非表示にする
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );

    saveFcmToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      if (currentUserReference != null) {
        currentUserReference?.update({'fcmToken': newToken});
      }
    });
  }

  @override
  void dispose() {
    authUserSub.cancel();
    super.dispose();
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'furugi with template',
      // ローカライズ
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        // 必要に応じて
        // Locale('ja', ''),
      ],
      // テーマ設定
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      // ルーター設定
      routerConfig: _router,
    );
  }
}
