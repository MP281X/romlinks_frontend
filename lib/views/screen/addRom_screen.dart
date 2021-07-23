import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/screen/saveImage_screen.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

//! Add rom controller
class AddRomController extends GetxController {
  // intitstate, clear all the previus value
  @override
  void onInit() async {
    super.onInit();
    romName = "";
    androidVersion = 0;
    description = "";
    screenshot.value = <String>[];
    logo = "";
    update();
  }

  // variable
  String romName = "";
  double androidVersion = 0.0;
  String description = "";
  String logo = "";
  var screenshot = <String>[].obs;

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

  void setLogo(String x) {
    if (x != "") {
      logo = x;
      update();
    }
  }

  void addScreenshot(String x) {
    print(x);
    if (x != "") {
      screenshot.add(x);
      update();
    }
  }

  // add the rom to the db
  void addRom() async {
    await RomService.addRom(
      romName: romName,
      androidVersion: androidVersion,
      screenshot: screenshot,
      logo: logo,
      description: description,
    );
    await Future.delayed(Duration(seconds: 1, milliseconds: 500));
    Get.offAllNamed("/");
  }

  // display a dialog with the preview of the rom
  void romPreview() {
    if (romName != "" && androidVersion != 0.0 && description != "" && logo != "" && screenshot.length > 0)
      // dialogW(child: RomPreviewW(), height: 500, width: Get.width, text1: "Add rom", button1: () => addRom(), heroTag: "addRom");
      bottomSheetW(child: RomPreviewW(), text: "Add rom", onTap: () => addRom());
    else
      snackbarW("Error", "Enter all the filed");
  }
}

//! Screen for adding the rom
class AddRomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      GetBuilder<AddRomController>(
        init: AddRomController(),
        builder: (rom) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextW("Add rom", big: true),
              SpaceW(),
              LogoButtonW(),
              TextFieldW("Rom Name", onChanged: rom.setRomName),
              TextFieldW("Android Version", onChanged: rom.setAndroidVersion, number: true),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: 230,
                  child: TextFormField(
                    onChanged: rom.setDescription,
                    maxLines: 7,
                    decoration: InputDecoration(hintText: "Description"),
                  ),
                ),
              ),
              ScreenshotButtonW(),
              ButtonW(
                "Preview",
                onTap: () => rom.romPreview(),
                tag: "addRom",
              ),
            ],
          );
        },
      ),
      auth: true,
      scroll: true,
    );
  }
}

//!button for adding the logo
class LogoButtonW extends StatelessWidget {
  final AddRomController rom = Get.find();

  @override
  Widget build(BuildContext context) {
    void onTap() async {
      if (rom.romName.isEmpty)
        snackbarW("Error", "Enter the rom name");
      else if (rom.androidVersion == 0)
        snackbarW("Error", "Enter the android version");
      else {
        rom.setLogo("");
        String res = await Get.dialog(SaveImageDialog(
          romName: rom.romName.removeAllWhitespace.toLowerCase(),
          category: PhotoCategory.logo,
          androidVersion: rom.androidVersion,
          index: 0,
        ));
        rom.setLogo(res.substring(5));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: SizedBox(
        height: 200,
        width: 200,
        child: Stack(
          children: [
            SizedBox(
              child: ImageW(category: PhotoCategory.logo, name: rom.logo),
              height: 200,
              width: 200,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () => onTap(),
                iconSize: 30,
                splashRadius: 20,
                icon: Icon(Icons.edit),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//! button for adding the screenshot
class ScreenshotButtonW extends StatelessWidget {
  final AddRomController rom = Get.find();

  @override
  Widget build(BuildContext context) {
    void onTap() async {
      if (rom.romName.isEmpty)
        snackbarW("Error", "Enter the rom name");
      else if (rom.androidVersion == 0)
        snackbarW("Error", "Enter the android version");
      else if (rom.screenshot.length > 5)
        snackbarW("Error", "You can upload only 6 screenshot");
      else {
        String res = await Get.dialog(new SaveImageDialog(
          romName: rom.romName.removeAllWhitespace.toLowerCase(),
          category: PhotoCategory.screenshot,
          androidVersion: rom.androidVersion,
          index: rom.screenshot.length,
        ));
        rom.addScreenshot(res.substring(11));
      }
    }

    return Column(
      children: [
        ButtonW("Add screenshot", onTap: onTap),
        ScreenshotW((rom.screenshot.length > 0) ? rom.screenshot : RxList<String>([""])),
      ],
    );
  }
}

//! display the rom data preview
class RomPreviewW extends StatelessWidget {
  final AddRomController rom = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextW(rom.romName, big: true),
        SpaceW(),
        TextW("Android ${rom.androidVersion}", big: true),
        SpaceW(big: true),
        Center(
          child: SizedBox(
            child: ImageW(category: PhotoCategory.logo, name: rom.logo),
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
        ScreenshotW((rom.screenshot.length > 0) ? rom.screenshot : RxList<String>([""])),
        SizedBox(height: 50),
      ],
    );
  }
}
