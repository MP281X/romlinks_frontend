import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models/device_model.dart';
import 'package:romlinks_frontend/logic/models/romVersion_model.dart';
import 'package:romlinks_frontend/logic/models/rom_model.dart';
import 'package:romlinks_frontend/logic/models/version_model.dart';
import 'package:romlinks_frontend/logic/services/device_service.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/screen/rom_screen.dart';
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
          builder: (device) => PageView(
            physics: BouncingScrollPhysics(),
            controller: PageController(),
            children: [
              (data.rom.length > 0) ? UploadedRomW(data.rom) : ErrorW("No rom found"),
              (data.version.length > 0) ? UploadedVersionW(data.version) : ErrorW("No version found"),
              (device.length > 0) ? UploadedDeviceW(device) : ErrorW("No device found"),
            ],
          ),
        ),
      ),
      auth: true,
    );
  }
}

//! display the uploaded rom
class UploadedRomW extends StatelessWidget {
  const UploadedRomW(this.rom);
  final List<RomModel> rom;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      controller: new ScrollController(),
      child: Column(
        children: [
          TextW("Uploaded rom 2"),
          SpaceW(big: true),
          ListView.builder(
            controller: new ScrollController(),
            shrinkWrap: true,
            itemCount: rom.length,
            itemBuilder: (BuildContext context, int index) {
              return MaxWidthW(
                GestureDetector(
                  onTap: () => bottomSheetW(
                    child: TextW(rom[index].romname, big: true, maxLine: 1),
                    text: "Add new version",
                    onTap: () => Get.toNamed("/addVersion/" + rom[index].id),
                    scrollable: false,
                    height: 150,
                    text2: "View rom data",
                    onTap2: () => Get.to(RomScreen(rom[index])),
                  ),
                  child: ContainerW(
                    Row(
                      children: [
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: ImageW(category: PhotoCategory.logo, name: rom[index].logo),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextW(rom[index].romname, maxLine: 1),
                              SizedBox(height: 5),
                              TextW("Android ${rom[index].androidversion}", maxLine: 1),
                            ],
                          ),
                        ),
                        if (width > 400)
                          ButtonW(
                            (rom[index].verified) ? "Approved" : "Pending",
                            height: 36,
                            width: 40 * 2.2,
                            onTap: () {},
                            color: ThemeApp.primaryColor,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

//!display the uploaded version
class UploadedVersionW extends StatelessWidget {
  const UploadedVersionW(this.version);
  final List<VersionModel> version;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: new ScrollController(),
      child: Column(
        children: [
          TextW("Uploaded version"),
          SpaceW(big: true),
          //TODO: fixare
          // ListView.builder(
          //   controller: new ScrollController(),
          //   shrinkWrap: true,
          //   itemCount: version.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return MaxWidthW(RomVersionW(version: version[index], gapps: true));
          //   },
          // ),
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

//TODO: migliorare
//! widget for displaying the device info
class DeviceW extends StatelessWidget {
  const DeviceW(this.device);
  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ContainerW(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextW(device.name, maxLine: 1),
            TextW(device.codename, maxLine: 1),
          ],
        ),
      ),
      height: 80,
    );
  }
}
