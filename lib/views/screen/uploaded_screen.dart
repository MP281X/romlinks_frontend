// ignore_for_file: unnecessary_new

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/filestorage_service.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/screen/editRom_screen.dart';
import 'package:romlinks_frontend/views/screen/home_screen.dart';
import 'package:romlinks_frontend/views/screen/rom_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';

//! pageview for the uploaded version and rom
class UploadedScreen extends StatelessWidget {
  const UploadedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      FutureBuilderW<List<RomModel>>(
        future: RomService.getRomList(),
        builder: (data) => (data.isNotEmpty) ? UploadedRomW(data, uploadedVersion: true) : const ErrorW(msg: "No rom found"),
      ),
      auth: true,
      scroll: true,
    );
  }
}

//! display the uploaded rom
class UploadedRomW extends StatelessWidget {
  const UploadedRomW(this.rom, {this.search = false, this.verify = false, this.uploadedVersion = false, Key? key}) : super(key: key);
  final List<RomModel> rom;
  final bool search;
  final bool verify;
  final bool uploadedVersion;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Widget titleColumn(Widget child) {
      return (!search)
          ? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: ScrollController(),
              child: Column(
                children: [const TextW("Uploaded rom"), const SpaceW(big: true), child],
              ),
            )
          : child;
    }

    return titleColumn(
      (rom.isNotEmpty)
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: ScrollController(),
              shrinkWrap: true,
              itemCount: rom.length,
              itemBuilder: (BuildContext context, int index) {
                String? heroTag = new Random().nextInt(100).toString() + new Random().nextInt(100).toString();

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
                            uploadedVersion: uploadedVersion,
                          ));
                        },
                        text3: !search ? "Delete rom" : null,
                        button3: !search
                            ? () async {
                                RomService.deleteRom(rom[index]);
                                rom.removeAt(index);
                                await Future.delayed(const Duration(seconds: 1, milliseconds: 300));
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
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextW(rom[index].romname, singleLine: true),
                                const SizedBox(height: 5),
                                TextW("Android ${rom[index].androidversion}", singleLine: true),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
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
          : const Expanded(child: ErrorW(msg: "no rom found for this device")),
    );
  }
}
