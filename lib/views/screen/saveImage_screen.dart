import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/controller/image_controller.dart';
import 'package:romlinks_frontend/views/widget/custom_widget.dart';
import 'package:romlinks_frontend/views/widget/scaffold_widget.dart';

import '../theme.dart';

//TODO: controllare se ci sono errori durante l'upload
//! handle the upload of the image and crop to the required aspect ratio
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
  final ImageLinkController links = Get.find();
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      GetBuilder<SaveImageController>(
        init: SaveImageController(),
        builder: (_controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextW("Image cropper", big: true),
              SpaceW(big: true),
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
              SpaceW(big: true),
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
              SpaceW(),
              if (_controller.saved == 2) ButtonW("Go back", onTap: () => Get.back(closeOverlays: true)),
            ],
          );
        },
      ),
    );
  }
}
