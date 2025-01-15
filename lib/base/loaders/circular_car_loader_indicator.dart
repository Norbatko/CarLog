import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CircularCarLoaderIndicator extends StatelessWidget {
  const CircularCarLoaderIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Center(
        child: Lottie.network(
            "https://lottie.host/630f73c1-22b6-42aa-8a56-83629d3a1792/TyXDBpswR2.json"
        )
     );
  }
}
