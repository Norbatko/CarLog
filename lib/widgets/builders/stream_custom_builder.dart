import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StreamCustomBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data) builder;

  const StreamCustomBuilder({
    super.key,
    required this.stream,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: _buildLoading());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }

        return builder(context, snapshot.data!);
      },
    );
  }

  Widget _buildLoading() => Center(
      child: Lottie.network(
          "https://lottie.host/630f73c1-22b6-42aa-8a56-83629d3a1792/TyXDBpswR2.json"));
}
