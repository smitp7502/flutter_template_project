import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'package:flutter_template/src/core/routes/app_router.dart';
import 'package:flutter_template/src/core/routes/app_routes.dart';
import 'package:flutter_template/src/core/widgets/app_loader.dart';
import 'package:flutter_template/src/core/widgets/connectivity_listener.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: globalNavigatorKey,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRoutes.splashScreen,

        builder: (context, child) {
          return ConnectivityListener(child: AppLoader(child: child!));
        },
      ),
    );
  }
}
