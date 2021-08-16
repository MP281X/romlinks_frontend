import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/user_service.dart';
import 'package:romlinks_frontend/views/theme.dart';

//! container
class ContainerW extends StatelessWidget {
  const ContainerW(
    this.child, {
    this.height = 100,
    this.width = 100,
    this.padding = const EdgeInsets.all(10),
    this.margin = const EdgeInsets.all(10),
    this.color = ThemeApp.secondaryColor,
    this.marginLeft = true,
    this.marginRight = true,
    this.tag,
  });
  final Widget child;
  final double height;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color color;
  final bool marginLeft;
  final bool marginRight;
  final String? tag;
  @override
  Widget build(BuildContext context) {
    EdgeInsets customMargin = margin.copyWith(left: (marginLeft) ? margin.left : 0, right: (marginRight) ? margin.right : 0);
    return HeroW(
      Container(
        child: child,
        height: height,
        width: width,
        padding: padding,
        margin: customMargin,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      tag: tag,
    );
  }
}

//! chip
class ChipW extends StatelessWidget {
  const ChipW({
    this.text,
    this.icon,
    this.color = ThemeApp.secondaryColor,
    required this.height,
    required this.width,
  });
  final String? text;
  final IconData? icon;
  final Color color;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ContainerW(
      (text == null) ? Icon(icon) : TextW(text!, singleLine: true),
      color: color,
      height: height,
      width: width,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
    );
  }
}

//! button
class ButtonW extends StatelessWidget {
  ButtonW(
    this.text1, {
    required this.onTap,
    this.animated = false,
    this.width = 170,
    this.color = ThemeApp.accentColor,
    this.padding = const EdgeInsets.all(10),
    this.margin = const EdgeInsets.all(10),
    this.tag,
  });
  final String text1;
  final double width;
  final bool animated;
  final Function onTap;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final String? tag;
  final RxBool animation = false.obs;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        if (animated) {
          animation.value = true;
          await onTap();
          animation.value = false;
        } else
          onTap();
      },
      child: ContainerW(
        FittedBox(
          child: Obx(
            () => (!animation.value)
                ? TextW(text1, singleLine: true)
                : Center(
                    child: CircularProgressIndicator(color: ThemeApp.primaryColor),
                  ),
          ),
        ),
        color: color,
        padding: padding,
        margin: margin,
        height: 40,
        width: width,
        tag: tag,
      ),
    );
  }
}

//! text
class TextW extends StatelessWidget {
  const TextW(
    this.text, {
    this.singleLine = false,
    this.size = 20,
    this.big = false,
  });
  final String text;
  final double size;
  final bool big;
  final bool singleLine;
  @override
  Widget build(BuildContext context) {
    // text widget
    Widget textW = Text(
      text,
      overflow: TextOverflow.clip,
      style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: (big) ? 30 : size,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      maxLines: singleLine ? 1 : 20,
    );

    return !singleLine ? textW : FittedBox(child: textW);
  }
}

//! textfield
class TextFieldW extends StatelessWidget {
  const TextFieldW(
    this.text, {
    this.onChanged,
    this.onPressed,
    this.number = false,
    this.controller,
    this.prefixIcon,
    this.hide = false,
    this.buttonIcon = Icons.add,
  });
  final String text;
  final void Function(String)? onChanged;
  final void Function()? onPressed;
  final bool number;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final bool hide;
  final IconData buttonIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
                      icon: Icon(buttonIcon),
                      onPressed: onPressed,
                    ),
                  ),
          ),
        ),
      ),
    );
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
        if (snapshot.connectionState != ConnectionState.done) return Center(child: CircularProgressIndicator());
        return (snapshot.data == null) ? ErrorW(msg: "unable to get the data") : builder(snapshot.data);
      },
    );
  }
}

//! network image with error icon
class ImageW extends StatelessWidget {
  const ImageW({required this.category, required this.name, this.profileIcon = false, this.heroTag});
  final PhotoCategory category;
  final String name;
  final bool profileIcon;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (category == PhotoCategory.screenshot)
          ? () {
              dialogW(
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: SizedBox(
                      height: 2000,
                      child: AspectRatio(
                        aspectRatio: 9 / 19,
                        child: HeroW(
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              FileStorageService.imgUrl(category, name),
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => ErrorW(personIcon: profileIcon),
                            ),
                          ),
                          tag: heroTag,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          : null,
      child: HeroW(
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            FileStorageService.imgUrl(category, name),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => ErrorW(personIcon: profileIcon),
          ),
        ),
        tag: heroTag,
      ),
    );
  }
}

//! custom scaffold with padding
class ScaffoldW extends StatelessWidget {
  ScaffoldW(this.child, {this.scroll = false, this.auth = false, this.button});

  final Widget child;
  final bool scroll;
  final bool auth;
  final Widget? button;
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return (_userController.token.isEmpty && auth)
        ? Material(
            color: ThemeApp.primaryColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextW("Unauthorized"),
                  SpaceW(big: true),
                  ButtonW("Auth", onTap: () => Get.toNamed("/auth")),
                ],
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              floatingActionButton: button,
              body: SizedBox(
                height: context.height,
                width: context.width,
                child: (!scroll)
                    ? Padding(padding: EdgeInsets.all(20), child: Center(child: child))
                    : SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: MaxWidthW(child),
                        ),
                      ),
              ),
            ),
          );
  }
}

//! display a list of suggestion
class SuggestionW extends StatelessWidget {
  const SuggestionW({required this.suggestion, required this.onTap});
  final RxList suggestion;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (suggestion.length > 0)
          ? ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 45, maxWidth: 800),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suggestion.length,
                itemBuilder: (BuildContext context, int index) {
                  return ButtonW(
                    suggestion[index],
                    width: 90,
                    color: ThemeApp.secondaryColor,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    onTap: () => onTap(suggestion[index]),
                  );
                },
              ),
            )
          : SizedBox.shrink(),
    );
  }
}

//! dialog widget
class DialogW extends StatelessWidget {
  const DialogW({
    required this.button1,
    required this.text1,
    required this.child,
    required this.height,
    required this.width,
    this.button2,
    this.text2,
    this.alignment = Alignment.bottomCenter,
    this.tag,
    this.text3,
    this.button3,
  });
  final Function button1;
  final Function? button2;
  final String text1;
  final String? text2;
  final Widget child;
  final Alignment alignment;
  final double height;
  final double width;
  final String? tag;
  final String? text3;
  final Function? button3;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: SafeArea(
        minimum: EdgeInsets.all(5),
        child: SizedBox(
          height: height,
          width: width,
          child: HeroW(
            Material(
              color: Colors.transparent,
              child: ContainerW(
                Stack(
                  children: [
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(child: child),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: (button3 == null)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(child: ButtonW(text2 ?? "Close", onTap: () => (button2 != null) ? button2!() : Get.close(1))),
                                Expanded(child: ButtonW(text1, onTap: () => button1())),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(child: ButtonW(text2 ?? "Close", onTap: () => (button2 != null) ? button2!() : Get.close(1))),
                                    Expanded(child: ButtonW(text1, onTap: () => button1())),
                                  ],
                                ),
                                ButtonW(text3!, onTap: () => button3!()),
                              ],
                            ),
                    ),
                  ],
                ),
                margin: EdgeInsets.all(20),
                color: ThemeApp.primaryColor,
              ),
            ),
            tag: tag,
          ),
        ),
      ),
    );
  }
}

//! display a list of screenshot
class ScreenshotW extends StatelessWidget {
  const ScreenshotW(this.image);
  final RxList<String> image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Obx(
        () => ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: (image.length != 0) ? image.length : 1,
          itemBuilder: (BuildContext context, int index) {
            return AspectRatio(
              aspectRatio: 9 / 19,
              child: Padding(
                padding: EdgeInsets.fromLTRB((index == 0) ? 0 : 10, 10, 10, 10),
                child: ImageW(
                  heroTag: image[index],
                  category: PhotoCategory.screenshot,
                  name: (image.length != 0) ? image[index] : "",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

//! button that redirect to the auth or the profile screen depending on the auth state
class AccountButtonW extends StatelessWidget {
  final UserController _userController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (_userController.isLogged.value)
          ? GestureDetector(
              onTap: () => Get.toNamed("/profile"),
              child: ContainerW(
                (_userController.userData.value.username != "")
                    ? ImageW(
                        category: PhotoCategory.profile,
                        name: _userController.userData.value.username,
                        profileIcon: true,
                      )
                    : SizedBox.shrink(),
                height: 40,
                width: 40,
                marginRight: false,
                padding: EdgeInsets.zero,
              ),
            )
          : ButtonW(
              "Log in",
              margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              width: 40 * 2.2,
              onTap: () => Get.toNamed("/auth"),
            ),
    );
  }
}

//! display a list of text
class TextListW extends StatelessWidget {
  TextListW(this.data, {this.vertical = true});
  final RxList<String> data;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: vertical
            ? null
            : (data.length > 0)
                ? 60
                : 0,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: data.length,
          scrollDirection: vertical ? Axis.vertical : Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: ContainerW(
                TextW(data[index], singleLine: true),
                height: 45,
                width: 210,
              ),
            );
          },
        ),
      ),
    );
  }
}

//! display an error icon
class ErrorW extends StatelessWidget {
  const ErrorW({this.msg, this.personIcon = false});

  final String? msg;
  final bool personIcon;

  @override
  Widget build(BuildContext context) {
    Icon icon = Icon((personIcon) ? Icons.person : Icons.report_problem_outlined);
    return (msg == null)
        ? ContainerW(icon, margin: EdgeInsets.zero, padding: EdgeInsets.zero)
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon((personIcon) ? Icons.person : Icons.report_problem_outlined),
                SpaceW(),
                TextW(msg!),
              ],
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

//! hero widget
class HeroW extends StatelessWidget {
  const HeroW(this.child, {this.tag});
  final Widget child;
  final String? tag;

  @override
  Widget build(BuildContext context) => (tag != null)
      ? Hero(
          tag: tag!,
          child: child,
          createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
        )
      : child;
}

//! custom courve for the hero widget
class CustomRectTween extends RectTween {
  CustomRectTween({
    required Rect begin,
    required Rect end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, elasticCurveValue)!,
      lerpDouble(begin!.top, end!.top, elasticCurveValue)!,
      lerpDouble(begin!.right, end!.right, elasticCurveValue)!,
      lerpDouble(begin!.bottom, end!.bottom, elasticCurveValue)!,
    );
  }
}

//! custom page view
class PageViewW extends StatelessWidget {
  PageViewW(this.child, {this.page = 2});
  final List<Widget> child;
  final PageController controller = PageController();
  final RxInt currentPage = 0.obs;
  final int page;

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      currentPage.value = controller.page!.round();
    });
    return Stack(
      children: [
        PageView(
          physics: BouncingScrollPhysics(),
          controller: controller,
          children: child,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ContainerW(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: (currentPage.value == 0) ? ThemeApp.accentColor : ThemeApp.primaryColor,
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    height: 14,
                    width: 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: (currentPage.value == 1) ? ThemeApp.accentColor : ThemeApp.primaryColor,
                    ),
                  ),
                ),
                if (page == 3)
                  Obx(
                    () => Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: (currentPage.value == 2) ? ThemeApp.accentColor : ThemeApp.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
            height: 30,
            width: (page == 2) ? 60 : 80,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}

//! display the username and the profile picture of a user
class UserW extends StatelessWidget {
  const UserW(this.username);
  final String username;

  @override
  Widget build(BuildContext context) {
    return ContainerW(
      GestureDetector(
        onTap: () {
          if (Get.find<UserController>().userData.value.moderator) {
            UserService.editUserPerm(username: username, perm: PermType.verified, value: true);
          }
        },
        child: Column(
          children: [
            SizedBox(
              child: ImageW(category: PhotoCategory.profile, name: username, profileIcon: true),
              height: 100,
              width: 100,
            ),
            SpaceW(),
            TextW(username),
          ],
        ),
      ),
      height: 155,
      width: 140,
    );
  }
}

//! custom dialog
void dialogW(Widget child) {
  navigator!.push(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.9),
      pageBuilder: (_, __, ___) => child,
    ),
  );
}

//! custom snackbar
void snackbarW(String title, String? msg) {
  if (msg != null) if (Get.isSnackbarOpen == false)
    Get.snackbar(
      title,
      msg,
      icon: title.toLowerCase().contains("error") ? Icon(Icons.report_problem_outlined, color: ThemeApp.accentColor) : null,
      shouldIconPulse: false,
      colorText: Colors.white,
      duration: Duration(seconds: 5),
      backgroundColor: ThemeApp.secondaryColor.withOpacity(0.9),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    );
}
