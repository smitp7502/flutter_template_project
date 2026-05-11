import 'package:flutter/material.dart';
import 'package:flutter_template/src/core/routes/app_routes.dart';

class SplashController {
  Future<void> navigate(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.loginScren,
      (_) => false,
    );
  }
}
