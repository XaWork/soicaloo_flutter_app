import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialoo/app.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await SharedPreferences.getInstance().then(
    (prefs) {
      runApp(
        Socialoo(prefs, savedThemeMode),
      );
    },
  );
}
