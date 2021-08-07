import 'package:flutter/material.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/screen/uploadedRom_screen.dart';

//! display a list of unverified rom and version
class UnverifiedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      PageView(
        physics: BouncingScrollPhysics(),
        controller: PageController(),
        children: [
          FutureBuilderW<List<RomModel>>(
            future: RomService.getUnverifiedRom(),
            builder: (data) {
              return (data.length > 0) ? UploadedRomW(data, verify: true) : ErrorW(msg: "All rom are verified");
            },
          ),
          FutureBuilderW<List<VersionModel>>(
            future: RomService.getUnverifiedVersion(),
            builder: (data) {
              return (data.length > 0) ? UploadedVersionW(data, true) : ErrorW(msg: "All version are verified");
            },
          ),
        ],
      ),
      auth: true,
    );
  }
}
