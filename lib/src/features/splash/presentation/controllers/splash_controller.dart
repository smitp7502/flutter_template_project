import 'package:flutter/material.dart';
import 'package:flutter_template/src/core/constants/storage_key.dart';
import 'package:flutter_template/src/core/routes/app_routes.dart';
import 'package:flutter_template/src/core/services/storage_service.dart';

class SplashController {
  Future<void> navigate(BuildContext context) async {
    final String? token = await StorageService().readString(
      StorageKey.accessToken,
    );
    await Future.delayed(const Duration(seconds: 1));

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      token != null ? AppRoutes.homeScreen : AppRoutes.loginScren,
      (_) => false,
    );
  }
}
