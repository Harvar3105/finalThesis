import 'package:flutter/material.dart';
import 'package:final_thesis_app/configurations/app_colours.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme.g.dart';

@riverpod
class Theme extends _$Theme {
  @override
  ThemeData build() => _customLightTheme();

  void toggleTheme() async {
    state = state.brightness == Brightness.light ? _customDarkTheme() : _customLightTheme();
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", state.brightness == Brightness.dark);
  }

  void setDarkTheme(bool set) async {
    if (set) state = _customDarkTheme();
  }

  static const errorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    borderRadius: BorderRadius.all(Radius.circular(100)),
  );
  static const focusedErrorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red),
  borderRadius: BorderRadius.all(Radius.circular(100)),
  );

  ThemeData _customLightTheme() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundColorLight,
      useMaterial3: true,
      fontFamily: 'WorkSans',
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryColorLight, // Navbar icons and text
        secondary: AppColors.secondaryColorLight, // Background color
        surface: AppColors.surfaceColorLight, // Cards and overlays
        onPrimary: AppColors.primaryTextColorLight, // Text on primary
        onSecondary: AppColors.secondaryTextColorLight, // General text color
        onSurface: AppColors.onSurfaceColorLight, // Text on cards and surfaces
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundColorLight,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColorLight),
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        errorBorder: errorBorder,
        focusedErrorBorder: focusedErrorBorder,
        labelStyle: const TextStyle(color: Colors.black),
        errorStyle: const TextStyle(color: Colors.red),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      iconTheme: IconThemeData(
        color: AppColors.iconThemeLight,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  ThemeData _customDarkTheme() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundColorDark,
      useMaterial3: true,
      fontFamily: 'WorkSans',
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryColorDark, // Navbar icons and text
        secondary: AppColors.secondaryColorDark, // Background color
        surface: AppColors.surfaceColorDark, // Cards and overlays
        onPrimary: AppColors.primaryTextColorDark, // Text on primary
        onSecondary: AppColors.secondaryTextColorDark, // General text color
        onSurface: AppColors.onSurfaceColorDark, // Text on cards and surfaces
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundColorDark,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColorDark),
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        errorBorder: errorBorder,
        focusedErrorBorder: focusedErrorBorder,
        labelStyle: const TextStyle(color: Colors.white),
        errorStyle: const TextStyle(color: Colors.red),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      iconTheme: IconThemeData(
        color: AppColors.iconThemeDark,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.black,
      ),
      dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        contentTextStyle: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }
}