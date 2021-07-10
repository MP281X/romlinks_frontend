import 'package:flutter/material.dart';
import 'package:romlinks_frontend/logic/services/fileStorage_service.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:romlinks_frontend/views/widget/custom_widget.dart';

//! display an image or an icon if there is error
class ImageW extends StatelessWidget {
  const ImageW({required this.category, required this.name, this.profileIcon = false, this.first = false});
  final PhotoCategory category;
  final String name;
  final bool profileIcon;
  final bool first;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        FileStorageService.imgUrl(category, name),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => ContainerW(
          Icon(Icons.report_problem_outlined, color: ThemeApp.accentColor),
          marginLeft: (!first),
        ),
      ),
    );
  }
}
