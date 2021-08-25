import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/device_service.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/screen/editRom_screen.dart';
import 'package:romlinks_frontend/views/screen/home_screen.dart';
import 'package:romlinks_frontend/views/screen/rom_screen.dart';
import 'package:romlinks_frontend/views/screen/version_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';

//! pageview for the uploaded version and rom
class UploadedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      FutureBuilderW<RomVersionModel>(
        future: RomService.getUploaded(),
        builder: (data) => FutureBuilderW<List<DeviceModel>>(
          future: DeviceService.getUploaded(),
          builder: (device) => PageViewW([
            (data.rom.length > 0) ? UploadedRomW(data.rom) : ErrorW(msg: "No rom found"),
            (data.version.length > 0) ? UploadedVersionW(data.version, false) : ErrorW(msg: "No version found"),
            (device.length > 0) ? UploadedDeviceW(device) : ErrorW(msg: "No device found"),
          ], page: 3),
        ),
      ),
      auth: true,
    );
  }
}

//! display the uploaded rom
class UploadedRomW extends StatelessWidget {
  const UploadedRomW(this.rom, {this.search = false, this.verify = false});
  final List<RomModel> rom;
  final bool search;
  final bool verify;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Widget titleColumn(Widget child) {
      return (!search)
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: new ScrollController(),
              child: Column(
                children: [TextW("Uploaded rom"), SpaceW(big: true), child],
              ),
            )
          : child;
    }

    return titleColumn(
      (rom.length > 0)
          ? ListView.builder(
              physics: BouncingScrollPhysics(),
              controller: new ScrollController(),
              shrinkWrap: true,
              itemCount: rom.length,
              itemBuilder: (BuildContext context, int index) {
                String? heroTag = new Random().nextInt(1000).toString();

                return MaxWidthW(
                  GestureDetector(
                    onTap: () => dialogW(
                      DialogW(
                        text1: verify ? "Approve" : "Add version",
                        button1: () => verify ? RomService.verifyRom(rom[index].id) : Get.toNamed("/addVersion/" + rom[index].id),
                        text2: "View rom data",
                        button2: () {
                          Get.close(1);
                          Get.to(RomScreen(
                            rom[index],
                            codename: search ? Get.find<HomeScreenController>().codename : null,
                            heroTag: heroTag,
                          ));
                        },
                        text3: !search ? "Delete rom" : null,
                        button3: !search
                            ? () async {
                                RomService.deleteRom(rom[index].id);
                                rom.removeAt(index);
                                await Future.delayed(Duration(seconds: 1, milliseconds: 300));
                                Get.close(3);
                              }
                            : null,
                        text4: !search ? "Edit rom" : null,
                        button4: !search ? () => Get.to(EditRomScreen(rom[index])) : null,
                        child: TextW(rom[index].romname, big: true, singleLine: true),
                        height: !search ? 230 : 170,
                        width: 400,
                      ),
                    ),
                    child: ContainerW(
                      Row(
                        children: [
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: ImageW(
                              category: PhotoCategory.logo,
                              name: rom[index].logo,
                              heroTag: heroTag,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextW(rom[index].romname, singleLine: true),
                                SizedBox(height: 5),
                                TextW("Android ${rom[index].androidversion}", singleLine: true),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          (width > 400)
                              ? ChipW(
                                  text: (rom[index].verified) ? "Approved" : "Pending",
                                  color: ThemeApp.primaryColor,
                                  height: 36,
                                  width: 40 * 2.2,
                                )
                              : Icon(
                                  rom[index].verified ? Icons.check_circle_outline_rounded : Icons.highlight_off_rounded,
                                  color: Colors.white,
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: ErrorW(msg: "no rom found for this device"),
            ),
    );
  }
}

//!display the uploaded version
class UploadedVersionW extends StatelessWidget {
  const UploadedVersionW(this.version, this.verify);
  final List<VersionModel> version;
  final bool verify;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: new ScrollController(),
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          TextW("Uploaded version"),
          SpaceW(big: true),
          ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: new ScrollController(),
            shrinkWrap: true,
            itemCount: version.length,
            itemBuilder: (BuildContext context, int index) {
              return MaxWidthW(
                VersionW(
                  version[index],
                  (version[index].gappslink != "") ? true : false,
                  hasUploaded: true,
                  verify: verify,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

//! display the uploaded devices list
class UploadedDeviceW extends StatelessWidget {
  const UploadedDeviceW(this.device);
  final List<DeviceModel> device;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: new ScrollController(),
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          TextW("Uploaded devices"),
          SpaceW(big: true),
          ListView.builder(
            controller: new ScrollController(),
            shrinkWrap: true,
            itemCount: device.length,
            itemBuilder: (BuildContext context, int index) {
              return MaxWidthW(DeviceW(device[index]));
            },
          ),
        ],
      ),
    );
  }
}

//! widget for displaying the device info
class DeviceW extends StatelessWidget {
  const DeviceW(this.device);
  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return ContainerW(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(child: TextW(device.name, singleLine: true), height: 20),
          SizedBox(child: TextW(device.codename, singleLine: true), height: 20),
        ],
      ),
      height: 60,
    );
  }
}
