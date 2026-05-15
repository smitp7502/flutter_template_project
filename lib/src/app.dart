import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:flutter_template/src/core/providers/locale_provider.dart';
import 'package:toastification/toastification.dart';

import 'package:flutter_template/src/core/routes/app_router.dart';
import 'package:flutter_template/src/core/routes/app_routes.dart';
import 'package:flutter_template/src/core/widgets/app_loader.dart';
import 'package:flutter_template/src/core/widgets/connectivity_listener.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: globalNavigatorKey,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRoutes.splashScreen,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: supportedLocales,
        builder: (context, child) {
          return ConnectivityListener(child: AppLoader(child: child!));
        },
      ),
    );
  }
}
