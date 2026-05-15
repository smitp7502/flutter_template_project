import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

// Supported locales
const supportedLocales = [
  Locale('en'), // English
  Locale('gu'), // Gujarati
];

// Locale state notifier
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')); // Default: English

  void setEnglish() => state = const Locale('en');
  void setGujarati() => state = const Locale('gu');

  void setLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      state = locale;
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);
