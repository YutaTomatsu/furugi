import 'dart:async';

import 'package:flutter/material.dart';
import 'package:furugi_with_template/pages/completed_transaction/completed_transaction_widget.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';

import '/auth/base_auth_user_provider.dart';

import '/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => appStateNotifier.loggedIn
          ? const HomePageWidget()
          : const FirstpageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? const HomePageWidget()
              : const FirstpageWidget(),
        ),
        FFRoute(
          name: 'Firstpage',
          path: '/firstpage',
          builder: (context, params) => const FirstpageWidget(),
        ),
        FFRoute(
          name: 'HomePage',
          path: '/homePage',
          builder: (context, params) => const HomePageWidget(),
        ),
        FFRoute(
          name: 'ProductScreen',
          path: '/productScreen',
          builder: (context, params) => ProductScreenWidget(
            productInfo: params.getParam(
              'productInfo',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['Users', 'products'],
            ),
          ),
        ),
        FFRoute(
          name: 'Productpage',
          path: '/productpage',
          builder: (context, params) => const ProductpageWidget(),
        ),
        FFRoute(
          name: 'Myaccount',
          path: '/myaccount',
          builder: (context, params) => const MyaccountWidget(),
        ),
        FFRoute(
          name: 'BUY_CheckOut',
          path: '/bUYCheckOut',
          builder: (context, params) => const BUYCheckOutWidget(),
        ),
        FFRoute(
          name: 'Login',
          path: '/login',
          builder: (context, params) => const LoginWidget(),
        ),
        FFRoute(
          name: 'MyOrder',
          path: '/myOrder',
          builder: (context, params) => const MyOrderWidget(),
        ),
        FFRoute(
          name: 'OrderHistory',
          path: '/orderHistory',
          builder: (context, params) => const OrderHistoryWidget(),
        ),
        FFRoute(
          name: 'Likes',
          path: '/likes',
          builder: (context, params) => const LikesWidget(),
        ),
        FFRoute(
          name: 'Editprofile',
          path: '/editprofile',
          builder: (context, params) => const EditprofileWidget(),
        ),
        FFRoute(
          name: 'Settingss',
          path: '/settingss',
          builder: (context, params) => const SettingssWidget(),
        ),
        FFRoute(
          name: 'Categories',
          path: '/categories',
          builder: (context, params) => const CategoriesWidget(),
        ),
        FFRoute(
          name: 'ForgetPassword',
          path: '/forgetPassword',
          builder: (context, params) => const ForgetPasswordWidget(),
        ),
        FFRoute(
          name: 'productinfo',
          path: '/productinfo',
          builder: (context, params) => const ProductinfoWidget(),
        ),
        FFRoute(
          name: 'Cart',
          path: '/cart',
          builder: (context, params) => const CartWidget(),
        ),
        FFRoute(
          name: 'Dashboard',
          path: '/dashboard',
          builder: (context, params) => DashboardWidget(
            dashboard: params.getParam(
              'dashboard',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'AdminOrderManagementAll',
          path: '/adminOrderManagementAll',
          builder: (context, params) => AdminOrderManagementAllWidget(
            dashboard: params.getParam(
              'dashboard',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'AdminOrderManagementInProcess',
          path: '/adminOrderManagementInProcess',
          builder: (context, params) => AdminOrderManagementInProcessWidget(
            dashboard: params.getParam(
              'dashboard',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'AdminOrderManagementShipped',
          path: '/adminOrderManagementShipped',
          builder: (context, params) => AdminOrderManagementShippedWidget(
            dashboard: params.getParam(
              'dashboard',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'AdminOrderManagementDelivered',
          path: '/adminOrderManagementDelivered',
          builder: (context, params) => AdminOrderManagementDeliveredWidget(
            dashboard: params.getParam(
              'dashboard',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'Settings',
          path: '/Setting',
          builder: (context, params) => SettingsWidget(
            dashboard: params.getParam(
              'dashboard',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'AdminLogin',
          path: '/admin',
          builder: (context, params) => const AdminLoginWidget(),
        ),
        FFRoute(
          name: 'AdminCustomerManagement',
          path: '/adminCustomerManagement',
          builder: (context, params) => AdminCustomerManagementWidget(
            dashboard: params.getParam(
              'dashboard',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'AdminProductCategory',
          path: '/adminProductCategory',
          builder: (context, params) => AdminProductCategoryWidget(
            dashboard: params.getParam(
              'dashboard',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'adminProduct_Simple',
          path: '/adminProductCategoryadd',
          builder: (context, params) => AdminProductSimpleWidget(
            dashboard: params.getParam(
              'dashboard',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'AdminProduct_Product',
          path: '/adminProductProduct',
          builder: (context, params) => const AdminProductProductWidget(),
        ),
        FFRoute(
          name: 'adminProduct_Simple2',
          path: '/adminProductCategoryad',
          builder: (context, params) => AdminProductSimple2Widget(
            dashboard: params.getParam(
              'dashboard',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: 'AdminNotification',
          path: '/adminNotification',
          builder: (context, params) => const AdminNotificationWidget(),
        ),
        FFRoute(
          name: 'UserProfile',
          path: '/userProfile',
          builder: (context, params) => UserProfileWidget(
            userRef: params.getParam(
              'userRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['Users'],
            ),
          ),
        ),
        FFRoute(
          name: 'AddContents',
          path: '/addContents',
          builder: (context, params) => const AddContentsWidget(),
        ),
        FFRoute(
          name: 'CreateContent',
          path: '/createContent',
          builder: (context, params) => const CreateContentWidget(),
        ),
        FFRoute(
          name: 'SignUp',
          path: '/signUp',
          builder: (context, params) => const SignUpWidget(),
        ),
        FFRoute(
          name: 'CreateContentCopy',
          path: '/createContentCopy',
          builder: (context, params) => const CreateContentCopyWidget(),
        ),
        FFRoute(
          name: 'ShopScreen',
          path: '/shopScreen',
          builder: (context, params) => ShopScreenWidget(
            shopRef: params.getParam(
              'shopRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['shops'],
            ),
          ),
        ),
        FFRoute(
          name: 'Map',
          path: '/map',
          builder: (context, params) => const MapWidget(),
        ),
        FFRoute(
          name: 'ProductCategory',
          path: '/productCategory',
          builder: (context, params) => const ProductCategoryWidget(),
        ),
        FFRoute(
          name: 'Products',
          path: '/products',
          builder: (context, params) => ProductsWidget(
            categoryrRef: params.getParam(
              'categoryrRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['categories'],
            ),
          ),
        ),
        FFRoute(
          name: 'Comment',
          path: '/comment',
          builder: (context, params) => CommentWidget(
            productInfo: params.getParam(
              'productInfo',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['Users', 'products'],
            ),
          ),
        ),
        FFRoute(
          name: 'Notification',
          path: '/notification',
          builder: (context, params) => const NotificationWidget(),
        ),
        FFRoute(
          name: 'Profile',
          path: '/Profile',
          builder: (context, params) => const ProfileWidget(),
        ),
        FFRoute(
          name: 'MyProducts',
          path: '/myProducts',
          builder: (context, params) => const MyProductsWidget(),
        ),
        FFRoute(
          name: 'Payment',
          path: '/payment',
          builder: (context, params) => const PaymentWidget(),
        ),
        FFRoute(
          name: 'PurchasedConversation',
          path: '/purchasedConversation',
          builder: (context, params) => PurchasedConversationWidget(
            productInfo: params.getParam<DocumentReference>(
              'productInfo',
              ParamType.DocumentReference,
              isList: true,
              collectionNamePath: ['Users', 'products'],
            ),
          ),
        ),
        FFRoute(
          name: 'CompletedTransaction',
          path: '/completedTransaction',
          builder: (context, params) => CompletedTransactionWidget(),
        ),
        FFRoute(
          name: 'Purchases',
          path: '/purchases',
          builder: (context, params) => PurchasesWidget(),
        ),
        FFRoute(
          name: 'SearchShop',
          path: '/searchShop',
          builder: (context, params) => const SearchShopWidget(),
        ),
        FFRoute(
            name: 'shops',
            path: '/shops',
            builder: (context, params) => ShopsWidget(
                  keyword: params.getParam<String>('keyword', ParamType.String),
                  prefectures: params.getParam<List<String>>(
                      'prefectures', ParamType.String,
                      isList: true),
                  priceRanges: params.getParam<List<String>>(
                      'priceRanges', ParamType.String,
                      isList: true),
                  payments: params.getParam<List<String>>(
                      'payments', ParamType.String,
                      isList: true),
                  closedDays: params.getParam<List<String>>(
                      'closedDays', ParamType.String,
                      isList: true),
                  genders: params.getParam<List<String>>(
                      'genders', ParamType.String,
                      isList: true),
                  parking: params.getParam<List<String>>(
                      'parking', ParamType.String,
                      isList: true),
                ))
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/firstpage';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => const TransitionInfo(
        hasTransition: true,
        transitionType: PageTransitionType.fade,
        duration: Duration(milliseconds: 0),
      );
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
