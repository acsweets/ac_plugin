import 'package:flutter/material.dart';
///1.0 这个是在themeData里控制路由动画的
///ThemeData(
///         pageTransitionsTheme: PageTransitionsTheme(
///           builders: {
///             TargetPlatform.android: MyCustomPageTransitionBuilder(),
///             TargetPlatform.iOS: FadePageTransitionsBuilder(),
///           },
///         ),
///       ),
///2.0
/// pageTransitionsTheme: PageTransitionsTheme(
///           builders: {
///             TargetPlatform.android: MyCustomPageTransitionBuilder(),
///             TargetPlatform.iOS: MyCustomPageTransitionBuilder(),
///           },
///         ),
class FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext? context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
      child: child,
    );
  }
}
