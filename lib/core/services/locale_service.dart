import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const String _localeKey = 'selected_locale';
  final SharedPreferences _prefs;

  LocaleService(this._prefs);

  Future<void> setLocale(String languageCode) async {
    await _prefs.setString(_localeKey, languageCode);
  }

  Locale? getLocale() {
    final languageCode = _prefs.getString(_localeKey);
    if (languageCode != null) {
      return Locale(languageCode);
    }
    return null;
  }
}
