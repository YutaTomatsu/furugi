import 'package:flutter/material.dart';
import 'package:furugi_with_template/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class DefaultAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showCartIcon;
  final bool showNotificationIcon;

  const DefaultAppBarWidget({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.showCartIcon = false,
    this.showNotificationIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, // ヘッダー背景色
      foregroundColor: Colors.black, // ヘッダーテキスト色
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Inter',
              fontSize: 16.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w500,
            ),
      ),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      actions: [
        if (showCartIcon)
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            onPressed: () {
              context.pushNamed('Cart');
            },
          ),
        if (showNotificationIcon)
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: FlutterFlowTheme.of(context).primaryText,
            ),
            onPressed: () {
              context.pushNamed('Notification');
            },
          ),
      ],
    );
  }

  // `PreferredSizeWidget` を継承するために `preferredSize` を実装
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
