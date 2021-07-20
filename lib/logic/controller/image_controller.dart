import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';

//! keep the saved image link
class ImageLinkController extends GetxController {
  List<String> imageLinks = [];

  String logo = "";
  // add a link to the list
  void addLink(String link) {
    link = link.split("/")[1];
    imageLinks.add(link);
    update();
  }

  // add the logo link
  void addLogo(String link) {
    logo = link.split("/")[1];
    update();
  }

  // remove all the link from the list
  void clearLink() {
    logo = "";
    imageLinks.clear();
    update();
  }
}

//! handle the save image screen
class SaveImageController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    controller = CropController();
    await loadImage();
  }

  @override
  void onClose() {
    controller = null;
    img = null;
    super.onClose();
  }

  CropController? controller;

  Uint8List? img;

  String format = "";

  int saved = 0;

  void isLoading() {
    saved = 1;
    update();
  }

  void isSaved() {
    saved = 2;
    update();
  }

  Future saveImage({required PhotoCategory category, required String fileName, required Uint8List croppedImg, required double androidVersion, required int index}) async {
    // clear the image cache becouse the image, if changed has the same name and the displayed image didn't change
    if (imageCache != null) imageCache!.clear();
    final ImageLinkController links = Get.find();
    try {
      String link = "";
      if (category != PhotoCategory.profile) {
        link = await FileStorageService.postImage(
          category: category,
          romName: fileName + format,
          androidVersion: androidVersion,
          image: croppedImg.cast(),
          index: index,
          format: "",
        );
      } else {
        link = await FileStorageService.postProfilePicture(croppedImg);
      }
      if (link != "") {
        (category != PhotoCategory.logo) ? links.addLink(link) : links.addLogo(link);
        isSaved();
      }
    } catch (e) {
      print(e);
    }
  }

  Future loadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      if (GetPlatform.isWeb) {
        img = result.files.first.bytes ?? Uint8List(0);
      } else {
        var file = File(result.files.single.path!);
        img = await file.readAsBytes();
      }
      String x = result.files.first.extension ?? "png";
      format = "." + x;
      update();
    } else {
      Get.back();
    }
  }
}
