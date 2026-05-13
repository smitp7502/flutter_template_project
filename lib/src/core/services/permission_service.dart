import 'package:flutter/material.dart';
import 'package:flutter_template/src/shared/models/permission_result.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_template/src/core/enums/permission_type.dart';

class PermissionService {
  PermissionService._();
  static Future<PermissionResult> request(
    BuildContext context,
    PermissionType type,
  ) async {
    final permission = _mapPermission(type);

    final status = await permission.request();

    final result = PermissionResult(
      isGranted: status.isGranted,
      isPermanentlyDenied: status.isPermanentlyDenied,
    );

    if (status.isPermanentlyDenied || status.isRestricted) {
      _showSettingsDialog(context);
    }

    return result;
  }

  static Future<Map<PermissionType, PermissionResult>> requestMultiple(
    BuildContext context,
    List<PermissionType> types,
  ) async {
    final permissions = <PermissionType, Permission>{};

    for (final type in types) {
      permissions[type] = _mapPermission(type);
    }

    final statuses = await permissions.values.toList().request();

    final result = <PermissionType, PermissionResult>{};

    bool shouldOpenSettings = false;

    for (final entry in permissions.entries) {
      final status = statuses[entry.value]!;

      result[entry.key] = PermissionResult(
        isGranted: status.isGranted,
        isPermanentlyDenied: status.isPermanentlyDenied,
      );

      if (status.isPermanentlyDenied || status.isRestricted) {
        shouldOpenSettings = true;
      }
    }

    if (shouldOpenSettings) {
      _showSettingsDialog(context);
    }

    return result;
  }

  static Future<bool> isGranted(PermissionType type) async {
    final permission = _mapPermission(type);

    return permission.isGranted;
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }

  static void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("Permission Required"),
          content: const Text(
            "Some permissions are permanently denied. Please enable them from app settings.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                await openSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  static Permission _mapPermission(PermissionType type) {
    switch (type) {
      case PermissionType.notification:
        return Permission.notification;

      case PermissionType.camera:
        return Permission.camera;

      case PermissionType.storage:
        return Permission.storage;

      case PermissionType.microphone:
        return Permission.microphone;

      case PermissionType.location:
        return Permission.location;
    }
  }
}
