import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/theme.dart';

//! controller for the save image dialog
class SaveImageController extends GetxController {
  // constructor
  SaveImageController({
    required this.category,
    this.romName = "",
    this.androidVersion = 0,
  });

  // variable
  CropController? controller;
  final PhotoCategory category;
  final String romName;
  final double androidVersion;
  Uint8List? image;
  String format = "";
  bool loading = false;

  // load the image in memory
  Future<Uint8List?> loadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      format = result.files.single.extension!;
      return (GetPlatform.isWeb) ? result.files.single.bytes! : await File(result.files.single.path!).readAsBytes();
    } else {
      Get.close(1);
      snackbarW("Error", "Unable to load the image");
      return null;
    }
  }

  // save the image in the db
  Future<void> saveImage(Uint8List croppedImage, int index) async {
    if (image != null) {
      String link = (category != PhotoCategory.profile)
          ? await FileStorageService.postImage(
              category: category,
              romName: romName,
              androidVersion: androidVersion,
              image: croppedImage.cast(),
              index: index,
              format: format,
            )
          : await FileStorageService.postProfilePicture(croppedImage.cast());
      if (link != "") Get.back(result: link);
      loading = false;
      update();
    }
  }

  // crop the image
  void cropImage() {
    loading = true;
    update();
    controller!.crop();
  }

  @override
  void onInit() async {
    controller = new CropController();
    image = await loadImage();
    update();
    super.onInit();
  }
}

//! dialog for cropping and saving images
class SaveImageDialog extends StatelessWidget {
  const SaveImageDialog({this.romName = "", required this.category, this.androidVersion = 0, required this.index});
  final String romName;
  final PhotoCategory category;
  final double androidVersion;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AspectRatio(
        aspectRatio: 1.5 / 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ScaffoldW(
            GetBuilder<SaveImageController>(
              global: false,
              init: SaveImageController(androidVersion: androidVersion, category: category, romName: romName),
              builder: (img) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 300, minHeight: 300, maxHeight: 500, maxWidth: 500),
                          child: Center(
                            child: (img.image != null)
                                ? new Crop(
                                    controller: img.controller,
                                    image: img.image!,
                                    aspectRatio: (category == PhotoCategory.screenshot) ? 9 / 19 : 1,
                                    baseColor: ThemeApp.primaryColor,
                                    onCropped: (croppedImg) async => img.saveImage(croppedImg, index),
                                    cornerDotBuilder: (size, cornerIndex) => DotControl(color: ThemeApp.accentColor),
                                  )
                                : CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                    SpaceW(big: (img.loading)),
                    (img.loading) ? CircularProgressIndicator() : ButtonW("Save image", onTap: () => img.cropImage())
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
