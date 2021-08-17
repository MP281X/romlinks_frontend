import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/device_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/screen/version_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

//! Add version controller
class AddVersionController extends GetxController {
  AddVersionController(this.romId);
  // initstate clear all the variable value
  @override
  void onInit() {
    super.onInit();
    codenameS = [].obs;
    changelog = <String>[].obs;
    error = <String>[].obs;
    vanillaLink = "";
    gappsLink = "";
    relaseType = "";
    official.value = false;
    date.value = DateTime.now();
  }

  // varaible
  String romId = "";
  TextEditingController codename = TextEditingController();
  String? vanillaLink;
  String? gappsLink;
  String relaseType = "";
  TextEditingController changelogController = TextEditingController();
  var changelog = <String>[].obs;
  TextEditingController errorController = TextEditingController();
  var error = <String>[].obs;
  var codenameS = [].obs;
  var official = false.obs;
  var date = DateTime.now().obs;
  String version = "";

  // setter method
  void setCodenameAndSuggestion() async {
    if (codename.text != "") codenameS.value = await DeviceService.searchDeviceName(codename.text);
  }

  // add a chenge to the cangelog
  void addChangelog() {
    if (changelogController.text != "") changelog.add(changelogController.text);
    changelogController.clear();
    update();
  }

  // ad an error to the error list
  void addError() {
    if (errorController.text != "") error.add(errorController.text);
    errorController.clear();
    update();
  }

  // display a preview of the version
  void versionPreview() async {
    if (vanillaLink == null && gappsLink == null) {
      snackbarW("Error", "Enter a download link");
      return;
    }

    if (romId != "" && codename.text != "" && relaseType != "")
      dialogW(
        DialogW(
          tag: "addVersion",
          button1: () => addVersion(),
          text1: "Add version",
          child: SizedBox(
            child: VersionPreviewW(),
            width: 500,
          ),
          height: 250,
          width: 500,
        ),
      );
    else
      snackbarW("Error", "Enter all the filed");
  }

  // change the relase date
  void selectDate() async {
    date.value = await showDatePicker(
          context: Get.context!,
          initialDate: date.value,
          firstDate: DateTime.utc(2003),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              child: child!,
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: ThemeApp.accentColor,
                  onPrimary: Colors.white,
                  onSurface: Colors.white,
                  brightness: Brightness.light,
                ),
                dialogBackgroundColor: ThemeApp.primaryColor,
              ),
            );
          },
        ) ??
        date.value;
  }

  // add the version to the db
  void addVersion() async {
    final UserController _userController = Get.find();
    await RomService.addVersion(
      romId: romId,
      codename: codename.text.replaceAll(" ", ""),
      changelog: changelog,
      error: error,
      token: _userController.token,
      gappsLink: gappsLink,
      vanillaLink: vanillaLink,
      relasetype: relaseType,
      official: official.value,
      date: date.value,
      version: version,
    );
    await Future.delayed(Duration(seconds: 1, milliseconds: 500));
    Get.offAllNamed("/");
  }
}

//! Screen for adding the version
class AddVersionScreen extends StatelessWidget {
  final AddVersionController controller = Get.put(AddVersionController(Get.parameters["romId"] ?? ""));
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        children: [
          TextW("Add version", big: true),
          SpaceW(big: true),
          TextFieldW("Codename", controller: controller.codename, onChanged: (_) => controller.setCodenameAndSuggestion()),
          SuggestionW(suggestion: controller.codenameS, onTap: (x) => controller.codename.text = x),
          TextFieldW("Vanilla link", onChanged: (x) => controller.vanillaLink = x),
          TextFieldW("Gapps link", onChanged: (x) => controller.gappsLink = x),
          TextFieldW("Relase type", onChanged: (x) => controller.relaseType = x),
          TextFieldW("Version", onChanged: (x) => controller.version = x),
          SizedBox(
            width: 340,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Obx(
                    () => ButtonW(
                      "Official",
                      onTap: () => controller.official.value = true,
                      color: (controller.official.value) ? ThemeApp.accentColor : ThemeApp.secondaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => ButtonW(
                      "Unofficial",
                      onTap: () => controller.official.value = false,
                      color: (!controller.official.value) ? ThemeApp.accentColor : ThemeApp.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SpaceW(),
          Obx(() => TextW("Relase date:  ${controller.date.value.day}/${controller.date.value.month}/${controller.date.value.year}")),
          ButtonW("Change date", onTap: () => controller.selectDate()),
          SpaceW(),
          TextFieldW("Add rom change", controller: controller.changelogController, onPressed: () => controller.addChangelog()),
          ChangelogPreviewW(controller.changelog),
          SpaceW(),
          TextFieldW("Add known error", controller: controller.errorController, onPressed: () => controller.addError()),
          ChangelogPreviewW(controller.error),
          SpaceW(),
          ButtonW("Version preview", onTap: () => controller.versionPreview(), tag: "addVersion"),
        ],
      ),
      auth: true,
      scroll: true,
    );
  }
}

//! display a preview of the version
class VersionPreviewW extends StatelessWidget {
  final AddVersionController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return VersionW(
      VersionModel(
        id: "",
        official: controller.official.value,
        romid: controller.romId,
        codename: controller.codename.text,
        date: controller.date.value,
        changelog: controller.changelog,
        error: controller.error,
        gappslink: controller.gappsLink!,
        vanillalink: controller.vanillaLink!,
        downloadnumber: 0,
        versionNum: controller.version,
        relasetype: controller.relaseType,
      ),
      (controller.gappsLink != null) ? true : false,
    );
  }
}

//! display a list of changelog or error
class ChangelogPreviewW extends StatelessWidget {
  ChangelogPreviewW(this.data);
  final RxList<String> data;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ContainerW(
        ListView.separated(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () => data.removeAt(index),
            child: TextW(data[index]),
          ),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Divider(color: Colors.white, thickness: .5),
          ),
        ),
        width: 300,
        height: 200,
      ),
    );
  }
}
