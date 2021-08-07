import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romlinks_frontend/logic/models.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';
import 'package:romlinks_frontend/views/screen/uploadedRom_screen.dart';

//TODO: fixare

class SearchRomController extends GetxController {
  String romName = "no rom";

  void searchRom(String x) {
    if (x != "") {
      romName = x;
      update();
    }
  }
}

class SearchRomScreen extends StatelessWidget {
  final SearchRomController _controller = Get.put(SearchRomController());
  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      Column(
        children: [
          TextFieldW("Rom name", onChanged: _controller.searchRom),
          GetBuilder<SearchRomController>(builder: (controller) {
            return FutureBuilderW<List<RomModel>>(
              future: RomService.searchRomName(controller.romName),
              builder: (data) {
                return (data.length > 0) ? UploadedRomW(data, search: true) : ErrorW(msg: "All rom are verified");
              },
            );
          })
        ],
      ),
      scroll: true,
    );
  }
}
