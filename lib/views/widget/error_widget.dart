import 'package:flutter/material.dart';
import 'package:romlinks_frontend/views/theme.dart';
import 'package:romlinks_frontend/views/widget/custom_widget.dart';

//! display an error icon
class ErrorW extends StatelessWidget {
  const ErrorW(this.msg, {this.personIcon = false});

  final String msg;
  final bool personIcon;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon((personIcon) ? Icons.person : Icons.report_problem_outlined, color: ThemeApp.accentColor),
        SpaceW(),
        TextW(msg),
      ],
    ));
  }
}
