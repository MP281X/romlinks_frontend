//! Base widget

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/views/theme.dart';

class ContainerW extends StatelessWidget {
  const ContainerW(
    this.child, {
    required this.height,
    required this.width,
    this.boxShadow = false,
    this.padding = const EdgeInsets.all(10),
    this.margin = const EdgeInsets.all(10),
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
  ButtonW(
    this.text1, {
    required this.onTap,
    this.height = 40,
    this.width = 170,
    this.animated = false,
    this.color = ThemeApp.accentColor,
    this.white = true,
    this.padding = const EdgeInsets.all(10),
    this.margin = const EdgeInsets.all(10),
  });
  final String text1;
  final bool animated;
  final double height;
  final double width;
  final Function onTap;
  final Color color;
  final bool white;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return GetX<ButtonWController>(
      assignId: true,
      global: false,
      init: new ButtonWController(),
      builder: (controller) {
        return GestureDetector(
          onTap: () async {
            if (animated) {
              controller.animation.value = true;
              await onTap();
              controller.animation.value = false;
            } else {
              onTap();
            }
          },
          child: ContainerW(
            FittedBox(
              child: (!controller.animation.value)
                  ? TextW(
                      text1,
                      maxLine: 1,
                      white: white,
                    )
                  : Center(
                      child: CircularProgressIndicator(color: ThemeApp.primaryColor),
                    ),
            ),
            padding: padding,
            margin: margin,
            color: color,
            height: height,
            width: width,
          ),
        );
      },
    );
  }
}

class ButtonWController extends GetxController {
  var animation = false.obs;
}

class TextW extends StatelessWidget {
  const TextW(
    this.text, {
    this.white = true,
    this.bold = true,
    this.maxLine = 100,
    this.size = 20,
    this.big = false,
    this.centerText = false,
  });
  final String text;
  final double size;
  final bool white;
  final bool bold;
  final bool big;
  final int maxLine;
  final bool centerText;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: (big) ? 30 : size,
        color: white ? Colors.white : ThemeApp.primaryColor,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: centerText ? TextAlign.center : TextAlign.left,
      maxLines: maxLine,
    );
  }
}
