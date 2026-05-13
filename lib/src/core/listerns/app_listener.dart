// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:flutter_template/src/app.dart';
// import 'package:flutter_template/src/core/enums/message_type.dart';
// import 'package:flutter_template/src/core/providers/app_provider.dart';
// import 'package:flutter_template/src/core/services/flushbar_service.dart';
// import 'package:flutter_template/src/core/utils/app_logger.dart';

// class AppListener {
//   AppListener._();

//   static void listen(WidgetRef ref) {
//     ref.listenManual(appProvider, (previous, next) {
//       final message = next.message;

//       if (message == null) return;

//       final overlayContext = globalNavigatorKey.currentState?.overlay?.context;

//       if (overlayContext == null) return;

//       AppLogger.info(message.message, tag: "APP_MESSAGE");

//       switch (message.type) {
//         case MessageType.success:
//           FlushbarService.success(overlayContext, message.message);
//           break;

//         case MessageType.error:
//           FlushbarService.error(overlayContext, message.message);
//           break;

//         case MessageType.warning:
//           FlushbarService.warning(overlayContext, message.message);
//           break;

//         case MessageType.info:
//           FlushbarService.info(overlayContext, message.message);
//           break;
//       }

//       Future.microtask(() {
//         ref.read(appProvider.notifier).clearMessage();
//       });
//     });
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_template/src/core/enums/message_type.dart';
import 'package:flutter_template/src/core/providers/app_provider.dart';
import 'package:flutter_template/src/core/services/flushbar_service.dart';
import 'package:flutter_template/src/core/utils/app_logger.dart';

class AppListener {
  AppListener._();

  static void listen(WidgetRef ref) {
    ref.listenManual(appProvider, (previous, next) {
      final message = next.message;

      if (message == null) return;

      AppLogger.info(message.message, tag: "APP_MESSAGE");

      switch (message.type) {
        case MessageType.success:
          FlushbarService.success(message.message);
          break;

        case MessageType.error:
          FlushbarService.error(message.message);
          break;

        case MessageType.warning:
          FlushbarService.warning(message.message);
          break;

        case MessageType.info:
          FlushbarService.info(message.message);
          break;
      }

      Future.microtask(() {
        ref.read(appProvider.notifier).clearMessage();
      });
    });
  }
}
