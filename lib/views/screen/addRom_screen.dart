import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/screen/rom_screen.dart';
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
    logo = "".obs;
    update();
  }

  // variable
  String romName = "";
  double androidVersion = 0.0;
  String description = "";
  var logo = "".obs;
  var screenshot = <String>[].obs;
  var link = <String>[].obs;
  TextEditingController linkController = TextEditingController();

  // add the rom to the db
  void addRom() async {
    await RomService.addRom(
      romName: romName,
      androidVersion: androidVersion,
      screenshot: screenshot,
      logo: logo.value,
      description: description,
      link: link,
    );
    await Future.delayed(Duration(seconds: 1));
    Get.offAllNamed("/");
  }

  // display a dialog with the preview of the rom
  void romPreview() {
    if (romName != "" && androidVersion != 0.0 && description != "" && logo.value != "" && screenshot.length > 0)
      dialogW(RomPreviewW());
    else
      snackbarW("Error", "Enter all the filed");
  }

  void setLogo() async {
    if (romName.isEmpty)
      snackbarW("Error", "Enter the rom name");
    else if (androidVersion == 0)
      snackbarW("Error", "Enter the android version");
    else {
      logo.value = "";
      String res = await Get.dialog(SaveImageDialog(
        romName: romName.removeAllWhitespace.toLowerCase(),
        category: PhotoCategory.logo,
        androidVersion: androidVersion,
        index: 0,
      ));
      if (res.substring(5) != "") logo.value = res.substring(5);
    }
  }

  void setScreenshot() async {
    if (romName.isEmpty)
      snackbarW("Error", "Enter the rom name");
    else if (androidVersion == 0)
      snackbarW("Error", "Enter the android version");
    else if (screenshot.length > 5)
      snackbarW("Error", "You can upload only 6 screenshot");
    else {
      String res = await Get.dialog(new SaveImageDialog(
        romName: romName.removeAllWhitespace.toLowerCase(),
        category: PhotoCategory.screenshot,
        androidVersion: androidVersion,
        index: screenshot.length,
      ));
      screenshot.add(res.substring(11));
    }
  }

  void editScreenshot(int index) async {
    if (romName.isEmpty)
      snackbarW("Error", "Enter the rom name");
    else if (androidVersion == 0)
      snackbarW("Error", "Enter the android version");
    else if (screenshot.length > 5)
      snackbarW("Error", "You can upload only 6 screenshot");
    else {
      String x = screenshot[index];
      screenshot[index] = "";
      imageCache!.clear();
      String? res = await Get.dialog(new SaveImageDialog(
        romName: romName.removeAllWhitespace.toLowerCase(),
        category: PhotoCategory.screenshot,
        androidVersion: androidVersion,
        index: index,
      ));
      if (res != null && res != "")
        screenshot[index] = res.substring(11);
      else
        screenshot[index] = x;
    }
  }

  void addLink() {
    link.add(linkController.text);
    linkController.clear();
  }
}

//! Screen for adding the rom
class AddRomScreen extends StatelessWidget {
  final AddRomController controller = Get.put(AddRomController());
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextW("Add rom", big: true),
          SpaceW(),
          LogoButtonW(),
          TextFieldW("Rom Name", onChanged: (x) => controller.romName = x),
          TextFieldW("Android Version", onChanged: (x) => controller.androidVersion = double.parse(x), number: true),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: 230,
              child: TextFormField(
                onChanged: (x) => controller.description = x,
                scrollPhysics: BouncingScrollPhysics(),
                maxLines: 7,
                decoration: InputDecoration(hintText: "Description"),
              ),
            ),
          ),
          Column(
            children: [
              ButtonW("Add screenshot", onTap: () => controller.setScreenshot()),
              ScreenshotW(
                controller.screenshot,
                removeImage: controller.editScreenshot,
              ),
            ],
          ),
          TextFieldW("Add link", controller: controller.linkController, onPressed: () => controller.addLink()),
          // ignore: invalid_use_of_protected_member
          Obx(() => LinkW(controller.link.value)),
          ButtonW("Preview", onTap: () => controller.romPreview(), tag: "romPreview"),
        ],
      ),
      auth: true,
      scroll: true,
    );
  }
}

//!button for adding the logo
class LogoButtonW extends StatelessWidget {
  final AddRomController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: SizedBox(
        height: 200,
        width: 200,
        child: Stack(
          children: [
            SizedBox(
              child: Obx(() => ImageW(category: PhotoCategory.logo, name: controller.logo.value)),
              height: 200,
              width: 200,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () => controller.setLogo(),
                iconSize: 30,
                splashRadius: 20,
                icon: Icon(Icons.edit_rounded),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//! display the rom data preview
class RomPreviewW extends StatelessWidget {
  final AddRomController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return DialogW(
      button1: () => controller.addRom(),
      text1: "Add rom",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextW(controller.romName, big: true),
          SpaceW(),
          TextW("Android ${controller.androidVersion}", big: true),
          SpaceW(big: true),
          Center(
            child: SizedBox(
              child: ImageW(category: PhotoCategory.logo, name: controller.logo.value),
              height: 200,
              width: 200,
            ),
          ),
          SpaceW(big: true),
          TextW("Description", big: true),
          SpaceW(),
          TextW(controller.description),
          SpaceW(big: true),
          TextW("Screenshot", big: true),
          ScreenshotW(controller.screenshot),
          SizedBox(height: 100)
        ],
      ),
      height: 1000,
      width: 900,
      tag: "romPreview",
    );
  }
}
