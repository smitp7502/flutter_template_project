import 'dart:convert';
import 'dart:developer' as developer;

class AppLogger {
  static const String _reset = '\x1B[0m';

  static const String _infoColor = '\x1B[36m'; // Cyan
  static const String _successColor = '\x1B[32m'; // Green
  static const String _warningColor = '\x1B[33m'; // Yellow
  static const String _errorColor = '\x1B[31m'; // Red

  static void info(String message, {String? tag, Map<String, dynamic>? json}) {
    _log(
      level: 'INFO',
      color: _infoColor,
      message: message,
      tag: tag,
      json: json,
    );
  }

  static void success(
    String message, {
    String? tag,
    Map<String, dynamic>? json,
  }) {
    _log(
      level: 'SUCCESS',
      color: _successColor,
      message: message,
      tag: tag,
      json: json,
    );
  }

  static void warning(
    String message, {
    String? tag,
    Map<String, dynamic>? json,
  }) {
    _log(
      level: 'WARNING',
      color: _warningColor,
      message: message,
      tag: tag,
      json: json,
    );
  }

  static void error(String message, {String? tag, Map<String, dynamic>? json}) {
    _log(
      level: 'ERROR',
      color: _errorColor,
      message: message,
      tag: tag,
      json: json,
    );
  }

  static void _log({
    required String level,
    required String color,
    required String message,
    String? tag,
    Map<String, dynamic>? json,
  }) {
    final timestamp = DateTime.now().toIso8601String();

    final tagText = tag != null && tag.isNotEmpty ? '[$tag] ' : '';

    final prefix = '[$level] $timestamp $tagText';

    final buffer = StringBuffer();

    buffer.writeln('$color$prefix$message$_reset');

    if (json != null && json.isNotEmpty) {
      const encoder = JsonEncoder.withIndent('  ');

      final formattedJson = encoder.convert(json);

      final jsonLines = formattedJson.split('\n');

      for (final line in jsonLines) {
        buffer.writeln('$color${' ' * prefix.length}$line$_reset');
      }
    }

    developer.log(buffer.toString(), name: level);
  }
}
