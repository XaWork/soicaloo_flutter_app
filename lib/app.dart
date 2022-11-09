import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:socialoo/configs/Mycolors.dart';
import 'package:socialoo/global/global.dart';
import 'package:socialoo/layouts/splashscreen.dart';
import 'package:socialoo/layouts/navigationbar/navigation_bar.dart';
import 'package:socialoo/route_generator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialoo/shared_preferences/preferencesKey.dart';

class Socialoo extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final AdaptiveThemeMode? savedThemeMode;

  Socialoo(
    this.prefs,
    this.savedThemeMode,
  );
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    setnotification();
    return AdaptiveTheme(
      light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
          primaryColor: Colors.indigo,
          primaryColorDark: Mycolors.primaryColorLight,
          // primaryColorLight: Mycolors.primaryColorLight,
          canvasColor: Colors.white,
          disabledColor: Mycolors.menuBackgroundColor,
          backgroundColor: Mycolors.backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: Mycolors.appbarbackgroundColor,
            actionsIconTheme: IconThemeData(
              color: Mycolors.appbariconcolor,
            ),
            iconTheme: IconThemeData(
              color: Mycolors.appbariconcolor,
              size: 24,
            ),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: Mycolors.tabbarlabelColor,
            unselectedLabelColor: Mycolors.tabbarunselectedLabelColor,
          ),
          iconTheme: const IconThemeData(color: Mycolors.iconThemeColor),
          scaffoldBackgroundColor: Mycolors.scaffoldBackgroundColor,
          textTheme: TextTheme(
            headline4: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Mycolors.apptitlecolor,
            ),
          ),
          cardColor: Mycolors.cardColor,
          shadowColor: Mycolors.shadowColor,
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: Mycolors.inputfillcolor,
          ),
          secondaryHeaderColor: Mycolors.secondaryHeaderColor),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        backgroundColor: Mycolors.backgroundColordark,
        disabledColor: Mycolors.scaffoldBackgroundColordark,
        secondaryHeaderColor: Mycolors.secondaryHeaderColorDark,
        appBarTheme: const AppBarTheme(
          actionsIconTheme: IconThemeData(
            color: Mycolors.appbariconcolordark,
          ),
          backgroundColor: Mycolors.appbarbackgroundColordark,
          iconTheme:
              IconThemeData(color: Mycolors.appbariconcolordark, size: 24),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Mycolors.tabbarlabelColordark,
          unselectedLabelColor: Mycolors.tabbarunselectedLabelColordark,
        ),
        iconTheme: const IconThemeData(color: Mycolors.iconThemeColordark),
        scaffoldBackgroundColor: Mycolors.scaffoldBackgroundColordark,
        textTheme: TextTheme(
          headline4: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Mycolors.apptitlecolordark,
          ),
        ),
        cardColor: Mycolors.cardColordark,
        shadowColor: Mycolors.shadowColordark,
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Mycolors.inputfillcolordark,
        ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Missing Person Helpline',
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        home: _handleCurrentScreen(prefs),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }

  Widget _handleCurrentScreen(SharedPreferences prefs) {
    String? data = prefs.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);
    preferences = prefs;
    if (data == null) {
      return SplashScreen();
    } else {
      return NavBar();
    }
  }

  setnotification() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    if (Platform.isIOS) {
      firebaseMessaging.setForegroundNotificationPresentationOptions(
        sound: true,
        alert: true,
        badge: true,
      );
    } else {}
  }
}
