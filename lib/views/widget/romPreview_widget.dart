import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models/rom_model.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/views/screen/rom_screen.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:romlinks_frontend/views/widget/custom_widget.dart';
import 'package:romlinks_frontend/views/widget/image_widget.dart';

//! display the rom name, the logo and basic rom info in the romlist widget
class RomPreviewW extends StatelessWidget {
  const RomPreviewW({
    Key? key,
    required this.data,
    this.first = false,
  }) : super(key: key);
  final RomModel data;
  final bool first;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () => Get.to(RomScreen(data)),
        child: ContainerW(
          Column(
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: ImageW(category: PhotoCategory.logo, name: data.logo),
              ),
              SpaceW(),
              TextW(data.romname),
              ButtonW(
                (data.official) ? "Official" : "Unofficial",
                height: 36,
                width: 40 * 2.2,
                onTap: () {},
                color: ThemeApp.primaryColor,
              ),
            ],
          ),
          marginLeft: (!first),
        ),
      ),
    );
  }
}
