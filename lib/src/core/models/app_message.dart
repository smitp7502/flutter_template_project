import 'package:flutter_template/src/core/enums/message_type.dart';

class AppMessage {
  final String message;
  final MessageType type;

  const AppMessage({required this.message, required this.type});
}
