import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/core/enums/message_type.dart';
import 'package:flutter_template/src/core/models/app_message.dart';
import 'package:flutter_template/src/core/providers/app_state.dart';

final appProvider = NotifierProvider<AppNotifier, AppState>(AppNotifier.new);

class AppNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    return const AppState();
  }

  void showSuccess(String message) {
    state = state.copyWith(
      message: AppMessage(message: message, type: MessageType.success),
    );
  }

  void showError(String message) {
    state = state.copyWith(
      message: AppMessage(message: message, type: MessageType.error),
    );
  }

  void clearMessage() {
    state = state.copyWith(message: null);
  }
}
