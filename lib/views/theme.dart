import 'package:flutter/material.dart';

//! App theme and color
class ThemeApp {
  //! ThemeData
  static ThemeData themeData = ThemeData.dark().copyWith(
    canvasColor: secondaryColor,
    scaffoldBackgroundColor: primaryColor,
    primaryColor: accentColor,
    dialogBackgroundColor: primaryColor,
    colorScheme: ThemeData.dark().colorScheme.copyWith(primary: accentColor),
    accentColor: accentColor,
    appBarTheme: AppBarTheme(
      color: primaryColor,
      elevation: 0,
    ),
    scrollbarTheme: _scrollBarTheme,
    iconTheme: IconThemeData(size: 30, color: accentColor),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: _textFieldBorder,
      enabledBorder: _textFieldBorder,
    ),
  );

  //! TextField border
  static OutlineInputBorder _textFieldBorder = OutlineInputBorder(
    borderSide: BorderSide(color: secondaryColor, width: 4.0),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  //! Scrollbar
  static ScrollbarThemeData _scrollBarTheme = ScrollbarThemeData(
    showTrackOnHover: true,
    isAlwaysShown: true,
    trackColor: MaterialStateProperty.resolveWith<Color>(
      (states) => Colors.transparent,
    ),
    trackBorderColor: MaterialStateProperty.resolveWith<Color>(
      (states) => Colors.transparent,
    ),
    thumbColor: MaterialStateProperty.resolveWith<Color>(
      (states) => accentColor,
    ),
  );

  //! Color
  static const Color primaryColor = Color(0xFF181C2D);
  static const Color secondaryColor = Color(0xFF1D2335);
  static const Color accentColor = Color(0xFFFF3B30);
}
