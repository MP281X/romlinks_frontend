import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/screen/rom_screen.dart';
import 'package:romlinks_frontend/views/screen/saveImage_screen.dart';

//! controller for the edit rom screen
class EditRomController extends GetxController {
  EditRomController(this.romData);
  final RomModel romData;

  @override
  void onInit() {
    super.onInit();
    link.value = List<String>.from(romData.link);
    screenshot = romData.screenshot ?? screenshot;
    logo = romData.logo.obs;
  }

  var link = <String>[].obs;
  var screenshot = <String>[].obs;
  var logo = "".obs;
  String description = "";
  TextEditingController linkController = TextEditingController();

  void addLink() {
    link.add(linkController.text);
    linkController.clear();
  }

  void setScreenshot() async {
    if (romData.romname.isEmpty)
      snackbarW("Error", "Enter the rom name");
    else if (romData.androidversion == 0)
      snackbarW("Error", "Enter the android version");
    else if (screenshot.length > 5)
      snackbarW("Error", "You can upload only 6 screenshot");
    else {
      String res = await Get.dialog(new SaveImageDialog(
        romName: romData.romname.removeAllWhitespace.toLowerCase(),
        category: PhotoCategory.screenshot,
        androidVersion: romData.androidversion.toDouble(),
        index: screenshot.length,
      ));
      screenshot.add(res.substring(11));
    }
  }

  void editScreenshot(int index) async {
    if (romData.romname.isEmpty)
      snackbarW("Error", "Enter the rom name");
    else if (romData.androidversion == 0)
      snackbarW("Error", "Enter the android version");
    else if (screenshot.length > 5)
      snackbarW("Error", "You can upload only 6 screenshot");
    else {
      String x = screenshot[index];
      screenshot[index] = "";
      imageCache!.clear();
      String? res = await Get.dialog(new SaveImageDialog(
        romName: romData.romname.removeAllWhitespace.toLowerCase(),
        category: PhotoCategory.screenshot,
        androidVersion: romData.androidversion.toDouble(),
        index: index,
      ));
      if (res != null && res != "")
        screenshot[index] = res.substring(11);
      else
        screenshot[index] = x;
    }
  }

  void setLogo() async {
    logo.value = "";
    imageCache!.clear();
    String? res = await Get.dialog(new SaveImageDialog(
      romName: romData.romname.removeAllWhitespace.toLowerCase(),
      category: PhotoCategory.logo,
      androidVersion: romData.androidversion.toDouble(),
      index: 0,
    ));
    if (res != null && res != "")
      logo.value = res.substring(5);
    else
      logo.value = romData.logo;
  }

  void editRom() async {
    await RomService.editRom(romData.id, screenshot, description, link, logo.value);
    await Future.delayed(Duration(seconds: 1));
    Get.offAllNamed("/");
  }
}

//! screen for editing the data of a rom
class EditRomScreen extends StatelessWidget {
  EditRomScreen(this.romData);
  final RomModel romData;

  @override
  Widget build(BuildContext context) {
    final EditRomController controller = Get.put(EditRomController(romData));
    return ScaffoldW(
      Column(children: [
        TextW("Edit rom - " + romData.romname, big: true),
        Padding(
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
        ),
        TextFieldW("Add link", controller: controller.linkController, onPressed: () => controller.addLink()),
        Obx(() => (controller.link.length > 0) ? LinkW(controller.link, true) : SizedBox.shrink()),
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
            SpaceW(),
          ],
        ),
        ButtonW("Edit rom data", onTap: () => controller.editRom()),
      ]),
      scroll: true,
      auth: true,
    );
  }
}
