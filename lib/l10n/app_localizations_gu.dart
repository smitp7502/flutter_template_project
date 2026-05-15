// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appName => 'મારી એપ';

  @override
  String get login => 'લૉગિન';

  @override
  String get logout => 'લૉગઆઉટ';

  @override
  String get email => 'ઈમેઈલ';

  @override
  String get password => 'પાસવર્ડ';

  @override
  String get submit => 'સબમિટ કરો';

  @override
  String get cancel => 'રદ કરો';

  @override
  String welcomeMessage(String name) {
    return 'સ્વાગત છે, $name!';
  }

  @override
  String get home => 'ઘર';

  @override
  String get homeScreen => 'હોમ સ્ક્રીન';

  @override
  String get notifications => 'સૂચનાઓ';

  @override
  String get language => 'ભાષા';

  @override
  String get english => 'અંગ્રેજી';

  @override
  String get gujarati => 'ગુજરાતી';

  @override
  String currentLanguage(String language) {
    return 'વર્તમાન ભાષા: $language';
  }
}
