import 'package:flutter/material.dart';
import 'package:flutter_template/src/core/routes/app_router.dart';
import 'package:flutter_template/src/core/routes/app_routes.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRoutes.splashScreen,
      navigatorKey: globalNavigatorKey,
    );
  }
}
