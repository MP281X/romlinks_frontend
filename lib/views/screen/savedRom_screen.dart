import 'package:flutter/material.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/screen/uploaded_screen.dart';

//! display a list of saved rom
class SavedRomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextW("Saved rom", big: true),
          SpaceW(),
          FutureBuilderW<List<RomModel>>(
            future: RomService.getRomById(),
            builder: (data) => UploadedRomW(data, search: true),
          ),
        ],
      ),
      scroll: true,
    );
  }
}
