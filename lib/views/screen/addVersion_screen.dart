import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/controller/user_controller.dart';
import 'package:romlinks_frontend/logic/models/version_model.dart';
import 'package:romlinks_frontend/logic/services/device_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/screen/rom_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

//! Add version controller
class AddVersionController extends GetxController {
  AddVersionController(this.romId);

  // initstate clear all the variable value
  @override
  void onInit() {
    super.onInit();
    codename = "";
    suggestion = [];
    changelog = [];
    error = [];
    vanillaLink = "";
    gappsLink = "";
    relaseType = "";
    update();
  }

  // varaible
  final String romId;
  String codename = "";
  String vanillaLink = "";
  String gappsLink = "";
  String relaseType = "";
  TextEditingController changelogController = TextEditingController();
  List<String> changelog = [];
  TextEditingController errorController = TextEditingController();
  List<String> error = [];
  List suggestion = [];

  // setter method
  void setCodenameAndSuggestion(String x) async {
    codename = x;
    if (x != "") suggestion = await DeviceService.searchDeviceName(x);
    update();
  }

  void setCodename(String x) {
    codename = x;
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
    if (vanillaLink == "" && gappsLink == "") snackbarW("Error", "Enter a download link");

    if (romId != "" && codename != "" && relaseType != "")
      Get.dialog(VersionPreviewW());
    else
      snackbarW("Error", "Enter all the filed");
  }

  // add the version to the db
  void addVersion() async {
    final UserController _userController = Get.find();
    await RomService.addVersion(
      romId: romId,
      codename: codename,
      changelog: changelog,
      error: error,
      token: _userController.token,
      gappsLink: gappsLink,
      vanillaLink: vanillaLink,
      relasetype: relaseType,
    );
    await Future.delayed(Duration(seconds: 1, milliseconds: 500));
    Get.offAllNamed("/");
  }
}

//! Screen for adding the version
class AddVersionScreen extends StatelessWidget {
  AddVersionScreen(this.romId);
  final String romId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddVersionController>(
      init: AddVersionController(romId),
      builder: (version) {
        return ScaffoldW(
          Column(
            children: [
              SpaceW(),
              if (version.codename != "") TextW(version.codename),
              SpaceW(),
              TextFieldW("Codename", onChanged: version.setCodenameAndSuggestion),
              CodenameSuggestionW(),
              TextFieldW("Vanilla link", onChanged: version.setVanillaLink),
              TextFieldW("Gapps link", onChanged: version.setGappsLink),
              TextFieldW("Relase type", onChanged: version.setRelaseType),
              //TODO: improve changelog and error ui
              TextFieldW("Add change to changelog", controller: version.changelogController, onPressed: () => version.addChangelog()),
              TextW(version.changelog.toString()),
              SpaceW(),
              TextFieldW("Add known error", controller: version.errorController, onPressed: () => version.addError()),
              TextW(version.error.toString()),
              SpaceW(),
              ButtonW("Add version", onTap: () => version.versionPreview()),
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
class CodenameSuggestionW extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddVersionController>(
      builder: (version) {
        return (version.suggestion.length > 0)
            ? ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 55, maxWidth: 800),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: version.suggestion.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ButtonW(
                      version.suggestion[index],
                      width: 90,
                      color: ThemeApp.secondaryColor,
                      onTap: () => version.setCodename(
                        version.suggestion[index],
                      ),
                    );
                  },
                ),
              )
            : SizedBox.shrink();
      },
    );
  }
}

//! display a preview of the version
class VersionPreviewW extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddVersionController>(builder: (version) {
      return ScaffoldW(
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: RomVersionW(
                version: VersionModel(
                  id: "",
                  romid: version.romId,
                  codename: version.codename,
                  date: DateTime.now(),
                  changelog: version.changelog,
                  error: version.error,
                  gappslink: version.gappsLink,
                  vanillalink: version.vanillaLink,
                  downloadnumber: 0,
                  relasetype: version.relaseType,
                ),
                gapps: (version.gappsLink != ""),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ButtonW("Edit data", onTap: () => Get.close(1)),
                  ButtonW("Add version", onTap: () => version.addVersion()),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
