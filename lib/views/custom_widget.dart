//! All the custom widget for standardizing the app style

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/views/theme.dart';

//! container
class ContainerW extends StatelessWidget {
  const ContainerW(
    this.child, {
    this.height = 100,
    this.width = 100,
    this.boxShadow = false,
    this.padding = const EdgeInsets.all(10),
    this.margin = const EdgeInsets.all(10),
    this.color = ThemeApp.secondaryColor,
    this.marginLeft = true,
    this.marginRight = true,
  });
  final Widget child;
  final double height;
  final double width;
  final bool boxShadow;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color color;
  final bool marginLeft;
  final bool marginRight;
  @override
  Widget build(BuildContext context) {
    EdgeInsets customMargin = margin.copyWith(left: (marginLeft) ? margin.left : 0, right: (marginRight) ? margin.right : 0);
    return Container(
      child: child,
      height: height,
      width: width,
      padding: padding,
      margin: customMargin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [if (boxShadow) BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 7, offset: Offset(3, 3))],
      ),
    );
  }
}

//! button
class ButtonW extends StatelessWidget {
  ButtonW(
    this.text1, {
    required this.onTap,
    this.onPress,
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
  final void Function()? onPress;
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
        return InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onLongPress: onPress,
          onTap: () async {
            if (animated) {
              controller.animation.value = true;
              await onTap();
              controller.animation.value = false;
            } else
              onTap();
          },
          child: ContainerW(
            FittedBox(
              child: (!controller.animation.value) ? TextW(text1, maxLine: 1) : Center(child: CircularProgressIndicator(color: ThemeApp.primaryColor)),
            ),
            color: color,
            padding: padding,
            margin: margin,
            height: height,
            width: width,
          ),
        );
      },
    );
  }
}

//! controller for the button animation state
class ButtonWController extends GetxController {
  var animation = false.obs;
}

//! text
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
    return (maxLine != 1)
        ? Text(
            text,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: (big) ? 30 : size,
              color: white ? Colors.white : ThemeApp.primaryColor,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: centerText ? TextAlign.center : TextAlign.left,
            maxLines: maxLine,
          )
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Text(
              text,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: (big) ? 30 : size,
                color: white ? Colors.white : ThemeApp.primaryColor,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: centerText ? TextAlign.center : TextAlign.left,
              maxLines: maxLine,
            ),
          );
  }
}

//! space
class SpaceW extends StatelessWidget {
  const SpaceW({this.big = false});
  final bool big;
  @override
  Widget build(BuildContext context) => SizedBox(height: (big) ? 30 : 10);
}

class TextFieldW extends StatelessWidget {
  const TextFieldW(
    this.text, {
    this.onChanged,
    this.onPressed,
    this.number = false,
    this.controller,
    this.bottomSpace = true,
    this.prefixIcon,
    this.hide = false,
  });
  final String text;
  final void Function(String)? onChanged;
  final void Function()? onPressed;
  final bool number;
  final TextEditingController? controller;
  final bool bottomSpace;
  final IconData? prefixIcon;
  final bool hide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpace ? 10 : 0),
      child: SizedBox(
        width: 230,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: (number) ? TextInputType.number : null,
          inputFormatters: (number) ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] : null,
          obscureText: hide,
          decoration: InputDecoration(
            prefixIcon: (prefixIcon != null) ? Icon(prefixIcon) : null,
            hintText: text,
            suffixIcon: (onPressed == null)
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: IconButton(
                      splashRadius: 20,
                      icon: Icon(Icons.add),
                      onPressed: onPressed,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

//! custom snackbar
void snackbarW(String title, String? msg) {
  if (msg != null) if (Get.isSnackbarOpen == false)
    Get.snackbar(
      title,
      msg,
      icon: (title.toLowerCase() == "error") ? Icon(Icons.report_problem_outlined, color: ThemeApp.accentColor) : null,
      shouldIconPulse: false,
      colorText: Colors.white,
      duration: Duration(seconds: 5),
      backgroundColor: ThemeApp.secondaryColor.withOpacity(0.8),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    );
}

//! display an error icon
class ErrorW extends StatelessWidget {
  const ErrorW(this.msg, {this.personIcon = false});

  final String msg;
  final bool personIcon;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon((personIcon) ? Icons.person : Icons.report_problem_outlined, color: ThemeApp.accentColor),
        SpaceW(),
        TextW(msg),
      ],
    ));
  }
}

//! custom future builder
class FutureBuilderW<T> extends StatelessWidget {
  const FutureBuilderW({required this.future, required this.builder});
  final Widget Function(T) builder;
  final Future future;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return (snapshot.data == null) ? ErrorW("unable to get the data") : builder(snapshot.data);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

//! display an image or an icon if there is error
class ImageW extends StatelessWidget {
  const ImageW({required this.category, required this.name, this.profileIcon = false, this.first = false});
  final PhotoCategory category;
  final String name;
  final bool profileIcon;
  final bool first;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        FileStorageService.imgUrl(category, name),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => ContainerW(
          Icon((!profileIcon) ? Icons.report_problem_outlined : Icons.person),
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

//! custom scaffold with padding
class ScaffoldW extends StatelessWidget {
  ScaffoldW(this.child, {this.scroll = false, this.auth = false, this.maxWidth = true});

  final Widget child;
  final bool scroll;
  final bool auth;
  final UserController _userController = Get.find();
  final bool maxWidth;

  @override
  Widget build(BuildContext context) {
    if (_userController.token.isEmpty && auth) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextW("Unauthorized"),
                SpaceW(big: true),
                ButtonW("Auth", onTap: () => Get.toNamed("/auth")),
              ],
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          body: SizedBox(
            height: context.height,
            width: context.width,
            child: (scroll)
                ? SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: (maxWidth) ? MaxWidthW(child) : child,
                    ),
                  )
                : Padding(padding: EdgeInsets.all(20), child: Center(child: child)),
          ),
        ),
      );
    }
  }
}

//! widget that define the max width
class MaxWidthW extends StatelessWidget {
  const MaxWidthW(this.child);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 1000,
        child: child,
      ),
    );
  }
}

//! dialog with two button and a scrollable child
void bottomSheetW(
    {required Widget child, required String text, required Function onTap, bool scrollable = true, double height = 300, String text2 = "Edit data", Function? onTap2, bool oneButton = false}) {
  Get.bottomSheet(
    Padding(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: (scrollable) ? 800 : 400, maxHeight: (scrollable) ? 3000 : height),
        child: ContainerW(
          (scrollable)
              ? Stack(
                  children: [
                    SingleChildScrollView(physics: BouncingScrollPhysics(), child: child),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 60, maxWidth: 340),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!oneButton) Expanded(child: ButtonW(text2, onTap: () => (onTap2 == null) ? Get.close(1) : onTap2())),
                            Expanded(child: ButtonW(text, onTap: onTap)),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    child,
                    SpaceW(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!oneButton) Expanded(child: ButtonW(text2, onTap: () => (onTap2 == null) ? Get.close(1) : onTap2())),
                        Expanded(child: ButtonW(text, onTap: onTap)),
                      ],
                    ),
                  ],
                ),
          height: height,
          color: ThemeApp.primaryColor,
        ),
      ),
    ),
    barrierColor: Colors.black.withOpacity(0.9),
  );
}

//! display a list of screenshot
class ScreenshotW extends StatelessWidget {
  const ScreenshotW(this.image);
  final List<String> image;

  @override
  Widget build(BuildContext context) {
    return (image.length > 0)
        ? SizedBox(
            height: 250,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: image.length,
              itemBuilder: (BuildContext context, int index) {
                return AspectRatio(
                  aspectRatio: 9 / 19,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB((index == 0) ? 0 : 10, 10, 10, 10),
                    child: ImageW(
                      first: (index == 0),
                      category: PhotoCategory.screenshot,
                      name: image[index],
                    ),
                  ),
                );
              },
            ),
          )
        : SizedBox(height: 50);
  }
}

//! button that redirect to the auth or the profile screen depending on the auth state
class AccountButtonW extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<UserController>(
      builder: (_userController) {
        if (_userController.isLogged.value) {
          return GestureDetector(
            onTap: () => Get.toNamed("/profile"),
            child: ContainerW(
              (_userController.userData.value.username != "") ? ImageW(category: PhotoCategory.profile, name: _userController.userData.value.username, profileIcon: true) : SizedBox.shrink(),
              height: 40,
              width: 40,
              marginRight: false,
              padding: EdgeInsets.zero,
            ),
          );
        } else {
          return ButtonW(
            "Log in",
            margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
            width: 40 * 2.2,
            onTap: () => Get.toNamed("/auth"),
          );
        }
      },
    );
  }
}

//! display a list of text
class TextListW extends StatelessWidget {
  TextListW(this.data);
  final List<String> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: data.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: ContainerW(
            TextW(data[index], maxLine: 1),
            height: 45,
            width: 210,
          ),
        );
      },
    );
  }
}
