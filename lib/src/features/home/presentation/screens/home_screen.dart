import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:flutter_template/src/core/enums/permission_type.dart';

import 'package:flutter_template/src/core/listerns/app_listener.dart';
import 'package:flutter_template/src/core/providers/locale_provider.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    final currentLanguageLabel = currentLocale.languageCode == 'gu'
        ? l10n.gujarati
        : l10n.english;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            tooltip: l10n.language,
            onSelected: (locale) {
              ref.read(localeProvider.notifier).setLocale(locale);
            },
            itemBuilder: (context) {
              return [
                CheckedPopupMenuItem(
                  value: const Locale('en'),
                  checked: currentLocale.languageCode == 'en',
                  child: Text(l10n.english),
                ),
                CheckedPopupMenuItem(
                  value: const Locale('gu'),
                  checked: currentLocale.languageCode == 'gu',
                  child: Text(l10n.gujarati),
                ),
              ];
            },
          ),
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
                PopupMenuItem(
                  value: "notification",
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_outlined),
                      const SizedBox(width: 12),
                      Text(l10n.notifications),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "logout",
                  child: Row(
                    children: [
                      const Icon(Icons.logout),
                      const SizedBox(width: 12),
                      Text(l10n.logout),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.homeScreen,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(l10n.welcomeMessage("User")),
            const SizedBox(height: 8),
            Text(l10n.currentLanguage(currentLanguageLabel)),
          ],
        ),
      ),
    );
  }
}
