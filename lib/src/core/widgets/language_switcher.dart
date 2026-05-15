import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return DropdownButton<Locale>(
      value: currentLocale,
      items: const [
        DropdownMenuItem(value: Locale('en'), child: Text('🇬🇧 English')),
        DropdownMenuItem(value: Locale('gu'), child: Text('🇮🇳 ગુજરાતી')),
      ],
      onChanged: (locale) {
        if (locale != null) {
          ref.read(localeProvider.notifier).setLocale(locale);
        }
      },
    );
  }
}
