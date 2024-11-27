import 'package:flutter/material.dart';

Widget buildFutureWithStream<T, S>({
  required Future<T> future,
  required Stream<S> stream,
  required Widget Function(BuildContext context, T futureData, S streamData)
  onData,
  required Widget loadingWidget,
  required Widget Function(Object? error) errorWidget,
}) {
  return FutureBuilder<T>(
    future: future,
    builder: (context, futureSnapshot) {
      return futureSnapshot.connectionState == ConnectionState.waiting
          ? loadingWidget
          : futureSnapshot.hasError
          ? errorWidget(futureSnapshot.error)
          : StreamBuilder<S>(
        stream: stream,
        builder: (context, streamSnapshot) {
          return streamSnapshot.connectionState ==
              ConnectionState.waiting
              ? loadingWidget
              : streamSnapshot.hasError
              ? errorWidget(streamSnapshot.error)
              : onData(context, futureSnapshot.data!,
              streamSnapshot.data!);
        },
      );
    },
  );
}
