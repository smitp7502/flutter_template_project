import 'package:flutter_template/src/core/models/app_message.dart';

class AppState {
  final AppMessage? message;

  const AppState({this.message});

  AppState copyWith({AppMessage? message}) {
    return AppState(message: message);
  }
}
