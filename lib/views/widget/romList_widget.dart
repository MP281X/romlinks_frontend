import 'package:flutter/material.dart';
import 'package:romlinks_frontend/logic/models/rom_model.dart';
import 'package:romlinks_frontend/logic/services/rom_service.dart';
import 'package:romlinks_frontend/views/widget/custom_widget.dart';
import 'package:romlinks_frontend/views/widget/error_widget.dart';
import 'package:romlinks_frontend/views/widget/futureBuilder_widget.dart';
import 'package:romlinks_frontend/views/widget/romPreview_widget.dart';

//! display a list of rom
class RomListW extends StatelessWidget {
  const RomListW({Key? key, required this.codename, required this.androidVersion, required this.orderBy}) : super(key: key);
  final String codename;
  final double androidVersion;
  final OrderBy orderBy;

  String categoryName() {
    String orderByString;
    switch (orderBy) {
      case OrderBy.performance:
        orderByString = "Performance";
        break;
      case OrderBy.battery:
        orderByString = "Battery";
        break;
      case OrderBy.stability:
        orderByString = "Stability";
        break;
      case OrderBy.customization:
        orderByString = "Customization";
        break;
      default:
        orderByString = "";
    }
    orderByString = orderByString + " rom";
    return orderByString;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpaceW(),
        TextW(categoryName(), big: true),
        SpaceW(),
        SizedBox(
          height: 200,
          child: FutureBuilderW<List<RomModel>>(
            future: RomService.getRomList(codename: codename, androidVersion: androidVersion, orderBy: orderBy),
            builder: (data) {
              return (data.length != 0)
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) => RomPreviewW(
                        data: data[index],
                        key: Key(data[index].id),
                        first: (index == 0),
                      ),
                    )
                  : ErrorW("No rom found for this device");
            },
          ),
        ),
      ],
    );
  }
}
