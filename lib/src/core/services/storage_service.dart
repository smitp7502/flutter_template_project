import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_template/src/core/utils/app_logger.dart';

class StorageService {
  StorageService._internal();

  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tag = 'STORAGE';

  Future<void> writeString(String key, String value) async {
    try {
      AppLogger.info(
        'Writing string value',
        tag: _tag,
        json: {'key': key, 'value': value},
      );

      await _storage.write(key: key, value: value);

      AppLogger.success(
        'String value stored successfully',
        tag: _tag,
        json: {'key': key},
      );
    } catch (e) {
      AppLogger.error(
        'Failed to write string value',
        tag: _tag,
        json: {'key': key, 'error': e.toString()},
      );

      rethrow;
    }
  }

  Future<String?> readString(String key) async {
    try {
      AppLogger.info('Reading string value', tag: _tag, json: {'key': key});

      final value = await _storage.read(key: key);

      AppLogger.success(
        'String value fetched successfully',
        tag: _tag,
        json: {'key': key, 'value': value},
      );

      return value;
    } catch (e) {
      AppLogger.error(
        'Failed to read string value',
        tag: _tag,
        json: {'key': key, 'error': e.toString()},
      );

      rethrow;
    }
  }

  Future<void> writeJson(String key, Map<String, dynamic> value) async {
    try {
      AppLogger.info(
        'Writing JSON value',
        tag: _tag,
        json: {'key': key, 'value': value},
      );

      final jsonStr = jsonEncode(value);

      await writeString(key, jsonStr);

      AppLogger.success(
        'JSON value stored successfully',
        tag: _tag,
        json: {'key': key},
      );
    } catch (e) {
      AppLogger.error(
        'Failed to write JSON value',
        tag: _tag,
        json: {'key': key, 'error': e.toString()},
      );

      rethrow;
    }
  }

  Future<Map<String, dynamic>?> readJson(String key) async {
    try {
      AppLogger.info('Reading JSON value', tag: _tag, json: {'key': key});

      final jsonStr = await _storage.read(key: key);

      if (jsonStr == null) {
        AppLogger.warning('No JSON value found', tag: _tag, json: {'key': key});

        return null;
      }

      final decoded = jsonDecode(jsonStr);

      AppLogger.success(
        'JSON value fetched successfully',
        tag: _tag,
        json: {'key': key, 'value': decoded},
      );

      return decoded;
    } catch (e) {
      AppLogger.error(
        'Failed to read JSON value',
        tag: _tag,
        json: {'key': key, 'error': e.toString()},
      );

      rethrow;
    }
  }

  Future<void> delete(String key) async {
    try {
      AppLogger.warning('Deleting value', tag: _tag, json: {'key': key});

      await _storage.delete(key: key);

      AppLogger.success(
        'Value deleted successfully',
        tag: _tag,
        json: {'key': key},
      );
    } catch (e) {
      AppLogger.error(
        'Failed to delete value',
        tag: _tag,
        json: {'key': key, 'error': e.toString()},
      );

      rethrow;
    }
  }

  Future<void> deleteAll() async {
    try {
      AppLogger.warning('Deleting all stored values', tag: _tag);

      await _storage.deleteAll();

      AppLogger.success('All stored values deleted successfully', tag: _tag);
    } catch (e) {
      AppLogger.error(
        'Failed to delete all values',
        tag: _tag,
        json: {'error': e.toString()},
      );

      rethrow;
    }
  }
}
