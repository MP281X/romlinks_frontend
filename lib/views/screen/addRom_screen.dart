import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/image_controller.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/screen/saveImage_screen.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/widget/screenshot_widget.dart';

//! Add rom controller
class AddRomController extends GetxController {
  // intitstate, clear all the previus value
  @override
  void onInit() async {
    super.onInit();
    _link.clearLink();
    romName = "";
    androidVersion = 0;
    description = "";

    update();
  }

  // user and link controller
  final UserController userController = Get.find();
  final ImageLinkController _link = Get.find();

  // variable
  String romName = "";
  double androidVersion = 0.0;
  String description = "";

  // setter method
  void setRomName(String x) {
    romName = x;
    update();
  }

  void setAndroidVersion(String x) {
    androidVersion = double.parse(x);
    update();
  }

  void setDescription(String x) {
    description = x;
    update();
  }

  // add the rom to the db
  void addRom() async {
    await RomService.addRom(
      romName: romName,
      androidVersion: androidVersion,
      screenshot: _link.imageLinks,
      logo: _link.logo,
      description: description,
      token: userController.token,
    );
    await Future.delayed(Duration(seconds: 1, milliseconds: 500));
    Get.offAllNamed("/");
  }

  // display a dialog with the preview of the rom
  void romPreview() {
    if (romName != "" && androidVersion != 0.0 && description != "" && _link.logo != "" && _link.imageLinks.length > 0 && userController.token != "")
      Get.dialog(RomPreviewW());
    else
      snackbarW("Error", "Enter all the filed");
  }
}

//! Screen for adding the rom
class AddRomScreen extends StatelessWidget {
  final AddRomController _rom = Get.put(AddRomController());
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextW("Add rom", big: true),
          SpaceW(),
          LogoButtonW(),
          TextFieldW("Rom Name", onChanged: _rom.setRomName),
          TextFieldW("Android Version", onChanged: _rom.setAndroidVersion, number: true),
          TextFieldW("Description", onChanged: _rom.setDescription),
          ScreenshotButtonW(),
          ButtonW("Preview", onTap: () => _rom.romPreview()),
        ],
      ),
      auth: true,
      scroll: true,
    );
  }
}

//!button for adding the logo
class LogoButtonW extends StatelessWidget {
  final AddRomController _rom = Get.find();

  @override
  Widget build(BuildContext context) {
    void onTap() {
      if (_rom.romName.isEmpty)
        snackbarW("Error", "Enter the rom name");
      else
        Get.to(SaveImageScreen(
          category: PhotoCategory.logo,
          fileName: _rom.romName.removeAllWhitespace.toLowerCase(),
        ));
    }

    return GetBuilder<ImageLinkController>(
      builder: (_link) {
        return Column(
          children: [
            ButtonW((_link.logo == "") ? "Add logo" : "Edit logo", onTap: onTap),
            SpaceW(),
            SizedBox(
              child: ImageW(category: PhotoCategory.logo, name: _link.logo),
              height: 200,
              width: 200,
            ),
            SpaceW(),
          ],
        );
      },
    );
  }
}

//! button for adding the screenshot
class ScreenshotButtonW extends StatelessWidget {
  final AddRomController _rom = Get.find();

  @override
  Widget build(BuildContext context) {
    void onTap() {
      if (_rom.romName.isEmpty)
        snackbarW("Error", "Enter the rom name");
      else
        Get.to(SaveImageScreen(
          category: PhotoCategory.screenshot,
          fileName: _rom.romName.removeAllWhitespace.toLowerCase(),
        ));
    }

    return GetBuilder<ImageLinkController>(
      builder: (_link) {
        return Column(
          children: [
            ButtonW("Add screenshot", onTap: onTap),
            ConstrainedBox(
              child: ScreenshotW((_link.imageLinks.length > 0) ? _link.imageLinks : [""]),
              constraints: BoxConstraints(maxWidth: 800),
            ),
          ],
        );
      },
    );
  }
}

//! display the rom data preview
class RomPreviewW extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GetBuilder<AddRomController>(
          builder: (rom) {
            return ScaffoldW(
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextW(rom.romName, big: true),
                      SpaceW(),
                      TextW("Android ${rom.androidVersion}", big: true),
                      SpaceW(big: true),
                      Center(
                        child: SizedBox(
                          child: ImageW(category: PhotoCategory.logo, name: rom._link.logo),
                          height: 200,
                          width: 200,
                        ),
                      ),
                      SpaceW(big: true),
                      TextW("Description", big: true),
                      SpaceW(),
                      TextW(rom.description),
                      SpaceW(big: true),
                      TextW("Screenshot", big: true),
                      ScreenshotW((rom._link.imageLinks.length > 0) ? rom._link.imageLinks : [""]),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ButtonW("Edit data", onTap: () => Get.close(1)),
                        ButtonW("Add rom", onTap: () => rom.addRom()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
