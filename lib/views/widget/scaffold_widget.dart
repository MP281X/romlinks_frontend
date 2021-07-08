import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScaffoldW extends StatelessWidget {
  const ScaffoldW(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: child),
        ),
      ),
    );
  }
}
