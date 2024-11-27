import 'package:flutter/material.dart';

Widget buildFuture<T>({
  required Future<T> future,
  required Widget Function(BuildContext context, T futureData) onData,
  required Widget loadingWidget,
  required Widget Function(Object? error) errorWidget,
}) {
  return FutureBuilder<T>(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return loadingWidget;
      } else if (snapshot.hasError) {
        return errorWidget(snapshot.error);
      } else {
        return onData(context, snapshot.data!);
      }
    },
  );
}
