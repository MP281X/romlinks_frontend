import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/services/saveImage_service.dart';
import 'package:romlinks_frontend/views/widget/custom_widget.dart';
import 'package:romlinks_frontend/views/widget/scaffold_widget.dart';

import '../theme.dart';

//TODO: controllare se ci sono errori durante l'upload
class SaveImageScreen extends StatelessWidget {
  SaveImageScreen({
    required this.category,
    required this.fileName,
    this.androidVersion = 0,
    required this.aspectRatio,
  });
  final PhotoCategory category;
  final String fileName;
  final double aspectRatio;
  final double androidVersion;
  final SaveImageLink links = Get.find();
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      GetBuilder<ImageSaveController>(
        init: ImageSaveController(),
        builder: (_controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextW(
                "Image cropper",
                big: true,
              ),
              SizedBox(height: 30),
              SizedBox(
                height: 400,
                width: 400,
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
                              String link = "";
                              if (category != PhotoCategory.profile) {
                                link = await FileStorageService.postImage(
                                  category: category,
                                  romName: fileName,
                                  androidVersion: androidVersion,
                                  image: croppedImg,
                                );
                              } else {
                                link = await FileStorageService.postProfilePicture(fileName, croppedImg);
                              }
                              if (link != "") {
                                links.addLink(link);
                                _controller.isSaved();
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          cornerDotBuilder: (size, cornerIndex) => const DotControl(color: ThemeApp.accentColor),
                        )
                      : CircularProgressIndicator(),
                ),
              ),
              SizedBox(height: 30),
              if (_controller.saved == 0)
                ButtonW(
                  "Save image",
                  animated: true,
                  onTap: () async {
                    _controller.controller!.crop();
                    _controller.isLoading();
                    await Future.delayed(Duration(seconds: 20));
                  },
                ),
              if (_controller.saved == 1) CircularProgressIndicator(),
              if (_controller.saved == 2) TextW("Image saved"),
              SizedBox(height: 10),
              if (_controller.saved == 2) ButtonW("Go back", onTap: () => Get.back(closeOverlays: true)),
            ],
          );
        },
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
