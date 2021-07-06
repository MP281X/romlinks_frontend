import 'package:flutter/material.dart';

class ThemeApp {
  //! ThemeData
  static ThemeData themeData = ThemeData.dark().copyWith(
    canvasColor: secondaryColor,
    scaffoldBackgroundColor: primaryColor,
    primaryColor: primaryColor,
    colorScheme: ThemeData.dark().colorScheme.copyWith(primary: accentColor),
    accentColor: secondaryColor,
    appBarTheme: AppBarTheme(
      color: primaryColor,
      elevation: 0,
    ),
    scrollbarTheme: _scrollBarTheme,
    iconTheme: IconThemeData(size: 30, color: secondaryColor),
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

//! Base widget

class ContainerW extends StatelessWidget {
  const ContainerW(
    this.child, {
    required this.height,
    required this.width,
    this.boxShadow = false,
    this.padding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.all(20),
    this.color = ThemeApp.secondaryColor,
  });
  final Widget child;
  final double height;
  final double width;
  final bool boxShadow;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          if (boxShadow)
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(3, 3),
            ),
        ],
      ),
    );
  }
}

class ButtonW extends StatelessWidget {
  const ButtonW(
    this.text, {
    required this.height,
    required this.width,
    required this.onTap,
    this.color = ThemeApp.accentColor,
    this.white = false,
    this.padding = const EdgeInsets.all(13),
    this.margin = const EdgeInsets.all(10),
  });
  final String text;
  final double height;
  final double width;
  final Function onTap;
  final Color color;
  final bool white;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: ContainerW(
        FittedBox(
          child: TextW(
            text,
            maxLine: 1,
            white: white,
          ),
        ),
        padding: padding,
        margin: margin,
        color: color,
        height: height,
        width: width,
      ),
    );
  }
}

class TextW extends StatelessWidget {
  const TextW(
    this.text, {
    this.white = true,
    this.bold = true,
    this.maxLine = 100,
    this.size = 30,
    this.centerText = false,
  });
  final String text;
  final double size;
  final bool white;
  final bool bold;
  final int maxLine;
  final bool centerText;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: white ? Colors.white : ThemeApp.primaryColor,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: centerText ? TextAlign.center : TextAlign.left,
      maxLines: maxLine,
    );
  }
}
