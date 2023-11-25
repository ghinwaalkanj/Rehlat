import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/global.dart';

extension LocalizedTranslation on String {
  String translate() {
    return AppLocalization.of(navigatorKey.currentContext!).translate(this);
  }
}

class AppLocalization {
  final Locale locale;
  late Map<String, String> _sentences;

  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  Future<bool> load() async {
    String data =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> result = json.decode(data);
    _sentences = result.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) => _sentences[key] ?? '???';
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationsDelegate();

  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = AppLocalization(locale);
    await localization.load();
    log("Load ${locale.languageCode}");
    return localization;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
