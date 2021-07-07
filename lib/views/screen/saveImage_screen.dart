import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/saveImage_service.dart';

import '../theme.dart';

class SaveImageScreen extends StatelessWidget {
  SaveImageScreen({
    required this.category,
    required this.romName,
    required this.androidVersion,
    required this.aspectRatio,
  });
  final PhotoCategory category;
  final String romName;
  final double aspectRatio;
  final double androidVersion;
  final SaveImageLink links = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: GetBuilder<ImageSaveController>(
          init: ImageSaveController(),
          builder: (_controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextW(
                  "Image cropper",
                  size: 40,
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 500,
                  width: 500,
                  child: Center(
                    child: (_controller.img != null)
                        ? new Crop(
                            controller: _controller.controller,
                            baseColor: ThemeApp.primaryColor,
                            initialSize: .5,
                            aspectRatio: aspectRatio,
                            image: _controller.img!,
                            onCropped: (croppedImg) async {
                              try {
                                String link =
                                    await FileStorageService.postImage(
                                  category: category,
                                  romName: romName,
                                  androidVersion: androidVersion,
                                  image: croppedImg,
                                );
                                if (link != "") {
                                  links.addLink(link);
                                  _controller.isSaved();
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                            cornerDotBuilder: (size, cornerIndex) =>
                                const DotControl(color: ThemeApp.accentColor),
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
                SizedBox(height: 30),
                if (!_controller.saved)
                  ButtonW(
                    "Save image",
                    height: 50,
                    width: 200,
                    white: true,
                    onTap: _controller.controller!.crop,
                  ),
                if (_controller.saved) TextW("Image saved"),
                SizedBox(height: 10),
                if (_controller.saved)
                  ButtonW(
                    "Go back",
                    height: 50,
                    width: 200,
                    white: true,
                    onTap: () => Get.back(closeOverlays: true),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ImageSaveController extends GetxController {
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

  bool saved = false;

  void isSaved() {
    saved = true;
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
