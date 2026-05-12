import 'package:flutter/material.dart';
import 'package:flutter_template/src/core/routes/app_routes.dart';
import 'package:flutter_template/src/core/utils/app_logger.dart';
import 'package:flutter_template/src/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_template/src/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter_template/src/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_template/src/features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    AppLogger.info("Navigate to : ${settings.name}", tag: "NAVIGATION");

    Map<String, Widget> routes = {
      AppRoutes.splashScreen: SplashScreen(),
      AppRoutes.homeScreen: HomeScreen(),
      AppRoutes.loginScren: LoginScreen(),
      AppRoutes.signupScreen: SignupScreen(),
    };

    return MaterialPageRoute(
      builder: (_) => routes[settings.name] != null
          ? routes[settings.name]!
          : Scaffold(
              body: Center(child: Text("Unknown Route ${settings.name}")),
            ),
    );
  }
}
