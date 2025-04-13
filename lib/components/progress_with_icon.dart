import 'package:flutter/material.dart';
import 'package:colorful_circular_progress_indicator/colorful_circular_progress_indicator.dart';

class ProgressWithIcon extends StatelessWidget {
  const ProgressWithIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return // Inside your widget build method
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
            child: ColorfulCircularProgressIndicator(
              colors: [Colors.red, Colors.amber, Colors.green],
              strokeWidth: 3,
              indicatorHeight: 20,
              indicatorWidth: 20,
            )),
      );
  }
}