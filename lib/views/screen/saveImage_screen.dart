import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/logic/controller/image_controller.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

import '../theme.dart';

//TODO: da fixare
//TODO: controllare se ci sono errori durante l'upload
//TODO: bottone per cambiare immagine o annullare l'upload
//! handle the upload of the image and crop to the required aspect ratio
class SaveImageScreen extends StatelessWidget {
  SaveImageScreen({
    required this.category,
    required this.fileName,
    this.androidVersion = 0,
  });
  final PhotoCategory category;
  final String fileName;
  final double androidVersion;

  @override
  Widget build(BuildContext context) {
    double aspectRatio = 9 / 19;
    if (category == PhotoCategory.logo) {
      aspectRatio = 1;
    }
    return ScaffoldW(
      GetBuilder<SaveImageController>(
        init: SaveImageController(),
        builder: (_controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextW("Image cropper", big: true),
              Spacer(),
              AspectRatio(
                aspectRatio: 1,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 300, minHeight: 300, maxHeight: 500, maxWidth: 500),
                  child: Center(
                    child: (_controller.img != null)
                        ? Crop(
                            controller: _controller.controller,
                            baseColor: ThemeApp.primaryColor,
                            initialSize: .5,
                            aspectRatio: aspectRatio,
                            image: _controller.img!,
                            onCropped: (croppedImg) async => _controller.saveImage(category: category, fileName: fileName, croppedImg: croppedImg),
                            cornerDotBuilder: (size, cornerIndex) => const DotControl(color: ThemeApp.accentColor),
                          )
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
              Spacer(),
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
