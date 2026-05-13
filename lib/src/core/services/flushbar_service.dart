// // lib/src/core/services/flushbar_service.dart

// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_template/src/core/theme/app_colors.dart';

// class FlushbarService {
//   FlushbarService._();

//   static void info(BuildContext context, String message) {
//     _show(
//       context,
//       message: message,
//       backgroundColor: const Color(0xFF0891B2),
//       icon: Icons.info_outline_rounded,
//     );
//   }

//   static void success(BuildContext context, String message) {
//     _show(
//       context,
//       message: message,
//       backgroundColor: AppColors.success,
//       icon: Icons.check_circle_outline_rounded,
//     );
//   }

//   static void warning(BuildContext context, String message) {
//     _show(
//       context,
//       message: message,
//       backgroundColor: const Color(0xFFD97706),
//       icon: Icons.warning_amber_rounded,
//     );
//   }

//   static void error(BuildContext context, String message) {
//     _show(
//       context,
//       message: message,
//       backgroundColor: AppColors.error,
//       icon: Icons.error_outline_rounded,
//     );
//   }

//   static void _show(
//     BuildContext context, {
//     required String message,
//     required Color backgroundColor,
//     required IconData icon,
//   }) {
//     Flushbar(
//       messageText: Text(
//         message,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       icon: Icon(icon, color: Colors.white, size: 26),
//       duration: const Duration(seconds: 3),
//       margin: const EdgeInsets.all(16),
//       borderRadius: BorderRadius.circular(14),
//       flushbarPosition: FlushbarPosition.TOP,
//       backgroundColor: backgroundColor,
//       animationDuration: const Duration(milliseconds: 300),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//     ).show(context);
//   }
// }

import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'package:flutter_template/src/core/theme/app_colors.dart';

class FlushbarService {
  FlushbarService._();

  static void info(String message) {
    _show(
      message: message,
      backgroundColor: const Color(0xFF0891B2),
      icon: Icons.info_outline_rounded,
    );
  }

  static void success(String message) {
    _show(
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void warning(String message) {
    _show(
      message: message,
      backgroundColor: const Color(0xFFD97706),
      icon: Icons.warning_amber_rounded,
    );
  }

  static void error(String message) {
    _show(
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
    );
  }

  static void _show({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    toastification.dismissAll();

    toastification.show(
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.none,
      dragToClose: true,
      applyBlurEffect: false,
      borderRadius: BorderRadius.circular(14),
      // margin: const EdgeInsets.all(16),
      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      icon: Icon(icon, color: Colors.white, size: 26),
      title: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
