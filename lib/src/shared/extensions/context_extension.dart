import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/app_localizations.dart';

extension ContextExtension on BuildContext {
  // Existing extensions...

  // 👇 Add this
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  // Locale helpers
  bool get isGujarati => locale.languageCode == 'gu';
  bool get isEnglish => locale.languageCode == 'en';
  Locale get locale => Localizations.localeOf(this);
}
