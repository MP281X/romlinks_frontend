import 'package:flutter/material.dart';
import 'package:romlinks_frontend/views/widget/error_widget.dart';

//! futurebuilder with a loading indicator an an error message
class FutureBuilderW<T> extends StatelessWidget {
  const FutureBuilderW({required this.future, required this.builder});
  final Widget Function(T) builder;
  final Future future;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return (snapshot.data == null) ? ErrorW("unable to get the data") : builder(snapshot.data);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
