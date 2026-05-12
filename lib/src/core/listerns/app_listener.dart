import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_template/src/core/enums/message_type.dart';

import 'package:flutter_template/src/core/providers/app_provider.dart';

import 'package:flutter_template/src/core/services/flushbar_service.dart';

import 'package:flutter_template/src/core/utils/app_logger.dart';

class AppListener {
  AppListener._();

  static void listen(BuildContext context, WidgetRef ref) {
    ref.listenManual(appProvider, (previous, next) {
      final message = next.message;

      if (message == null) return;

      AppLogger.info(message.message, tag: "APP_MESSAGE");

      switch (message.type) {
        case MessageType.success:
          FlushbarService.success(context, message.message);
          break;

        case MessageType.error:
          FlushbarService.error(context, message.message);
          break;

        case MessageType.warning:
          FlushbarService.warning(context, message.message);
          break;

        case MessageType.info:
          FlushbarService.info(context, message.message);
          break;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(appProvider.notifier).clearMessage();
      });
    });
  }
}
