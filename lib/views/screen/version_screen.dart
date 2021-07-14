import 'package:flutter/material.dart';
import 'package:romlinks_frontend/logic/models/version_model.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:romlinks_frontend/views/custom_widget.dart';

//TODO: da fixare
class VersionScreen extends StatelessWidget {
  const VersionScreen({required this.version, required this.gapps});
  final VersionModel version;
  final bool gapps;

  @override
  Widget build(BuildContext context) {
    return ScaffoldW(
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500, maxHeight: 1000),
        child: ContainerW(
          Column(
            children: [
              ButtonW(version.relasetype, onTap: () {}, color: ThemeApp.primaryColor, width: 90),
              TextW("Date: ${version.date.day}/${version.date.month}/${version.date.year}"),
              Column(children: List<Widget>.generate(version.changelog.length, (index) => TextW(version.changelog[index]))),
              Column(children: List<Widget>.generate(version.error.length, (index) => TextW(version.error[index]))),
              SpaceW(),
              TextW("Download: ${version.downloadnumber}"),
              TextW(version.error.toString()),
            ],
          ),
          width: 1000,
          height: 1000,
        ),
      ),
    );
  }
}
