import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/logic/models/version_model.dart';
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
    codenameS = [];
    changelog = <String>[].obs;
    error = <String>[].obs;
    vanillaLink = "";
    gappsLink = "";
    relaseType = "";
    official.value = false;
    date.value = DateTime.now();

    update();
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
  List codenameS = [];
  var official = false.obs;
  var date = DateTime.now().obs;

  // setter method
  void setCodenameAndSuggestion() async {
    if (codename.text != "") codenameS = await DeviceService.searchDeviceName(codename.text);
    update();
  }

  void setCodename(String x) {
    codename.text = x;
    update();
  }

  void setVanillaLink(String x) {
    vanillaLink = x;
    update();
  }

  void setGappsLink(String x) {
    gappsLink = x;
    update();
  }

  void setRelaseType(String x) {
    relaseType = x;
    update();
  }

  void setOfficial(bool x) {
    official.value = x;
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
      bottomSheetW(child: VersionPreviewW(), text: "Add version", onTap: () => addVersion(), scrollable: false);
    else
      snackbarW("Error", "Enter all the filed");
  }

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
    );
    await Future.delayed(Duration(seconds: 1, milliseconds: 500));
    Get.offAllNamed("/");
  }
}

//! Screen for adding the version
class AddVersionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddVersionController>(
      init: AddVersionController(Get.parameters['romId'] ?? ""),
      builder: (version) {
        return ScaffoldW(
          Column(
            children: [
              TextW("Add version", big: true),
              SpaceW(big: true),
              TextFieldW("Codename", controller: version.codename, onChanged: (_) => version.setCodenameAndSuggestion()),
              SuggestionW(suggestion: version.codenameS, onTap: version.setCodename),
              TextFieldW("Vanilla link", onChanged: version.setVanillaLink),
              TextFieldW("Gapps link", onChanged: version.setGappsLink),
              TextFieldW("Relase type", onChanged: version.setRelaseType),
              SizedBox(
                width: 340,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Obx(
                        () => ButtonW(
                          "Official",
                          onTap: () => version.setOfficial(true),
                          color: (version.official.value) ? ThemeApp.accentColor : ThemeApp.secondaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => ButtonW(
                          "Unofficial",
                          onTap: () => version.setOfficial(false),
                          color: (!version.official.value) ? ThemeApp.accentColor : ThemeApp.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => TextW("Relase date:  ${version.date.value.day}/${version.date.value.month}/${version.date.value.year}")),
              ButtonW("Change date", onTap: () => version.selectDate()),
              TextFieldW("Add change to changelog", controller: version.changelogController, onPressed: () => version.addChangelog()),
              TextListW(version.changelog),
              SpaceW(),
              TextFieldW("Add known error", controller: version.errorController, onPressed: () => version.addError()),
              TextListW(version.error),
              SpaceW(),
              ButtonW("Version preview", onTap: () => version.versionPreview()),
            ],
          ),
          auth: true,
          scroll: true,
        );
      },
    );
  }
}

//! display a list of suggestion for the codename
class SuggestionW extends StatelessWidget {
  const SuggestionW({required this.suggestion, required this.onTap});
  final List suggestion;
  final Function(String) onTap;
  @override
  Widget build(BuildContext context) {
    return (suggestion.length > 0)
        ? ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 55, maxWidth: 800),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: suggestion.length,
              itemBuilder: (BuildContext context, int index) {
                return ButtonW(
                  suggestion[index],
                  width: 90,
                  color: ThemeApp.secondaryColor,
                  onTap: () => onTap(suggestion[index]),
                );
              },
            ),
          )
        : SizedBox.shrink();
  }
}

//TODO: migliorare la ui
//! display a preview of the version
class VersionPreviewW extends StatelessWidget {
  final AddVersionController version = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: VersionW(
        VersionModel(
          id: "",
          official: version.official.value,
          romid: version.romId,
          codename: version.codename.text,
          date: DateTime.now(),
          changelog: version.changelog,
          error: version.error,
          gappslink: version.gappsLink!,
          vanillalink: version.vanillaLink!,
          downloadnumber: 0,
          relasetype: version.relaseType,
        ),
        (version.gappsLink != null) ? true : false,
      ),
    );
  }
}
