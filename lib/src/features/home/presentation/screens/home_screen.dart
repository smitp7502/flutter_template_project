import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/core/enums/permission_type.dart';

import 'package:flutter_template/src/core/listerns/app_listener.dart';
import 'package:flutter_template/src/core/routes/app_routes.dart';
import 'package:flutter_template/src/core/services/flushbar_service.dart';
import 'package:flutter_template/src/core/services/permission_service.dart';
import 'package:flutter_template/src/features/auth/presentation/providers/logout_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    AppListener.listen(ref);
  }

  Future<void> _logout() async {
    await ref.read(logoutProvider.notifier).logout();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.loginScren,
      (_) => false,
    );
  }

  Future<void> _notificationTap() async {
    final result = await PermissionService.request(
      context,
      PermissionType.notification,
    );

    if (result.isGranted) {
      FlushbarService.success("Notification permission granted");
      return;
    }

    if (result.isPermanentlyDenied) {
      return;
    }

    FlushbarService.warning("Notification permission denied");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              switch (value) {
                case "notification":
                  _notificationTap();
                  break;

                case "logout":
                  await _logout();
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: "notification",
                  child: Row(
                    children: [
                      Icon(Icons.notifications_outlined),
                      SizedBox(width: 12),
                      Text("Notifications"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: "logout",
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 12),
                      Text("Logout"),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: const Center(child: Text("Home Screen")),
    );
  }
}
