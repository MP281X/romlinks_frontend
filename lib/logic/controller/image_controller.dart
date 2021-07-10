import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

//! keep the saved image link
class ImageLinkController extends GetxController {
  List<String> imageLinks = [];

  // add a link to the list
  void addLink(String link) {
    imageLinks.add(link);
    update();
  }

  // remove all the link from the list
  void clearLink() {
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

  int saved = 0;

  void isLoading() {
    saved = 1;
    update();
  }

  void isSaved() {
    saved = 2;
    update();
  }

  Future loadImage() async {
    final picker = ImagePicker();
    PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);
    img = await pickedFile!.readAsBytes();
    if (img != null) {
      update();
    }
  }
}
