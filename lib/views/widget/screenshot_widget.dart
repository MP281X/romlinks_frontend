//! display a list of screenshot
import 'package:flutter/material.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

class ScreenshotW extends StatelessWidget {
  const ScreenshotW(this.image);
  final List<String> image;

  @override
  Widget build(BuildContext context) {
    return (image.length > 0)
        ? SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: image.length,
              itemBuilder: (BuildContext context, int index) {
                return AspectRatio(
                  aspectRatio: 9 / 19,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB((index == 0) ? 0 : 10, 10, 10, 10),
                    child: ImageW(
                      first: (index == 0),
                      category: PhotoCategory.screenshot,
                      name: image[index],
                    ),
                  ),
                );
              },
            ),
          )
        : SizedBox(height: 50);
  }
}
