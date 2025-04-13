import 'package:flutter/material.dart';

class AudioProgressBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;

  const AudioProgressBar({
    super.key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
  });

  @override
  State<AudioProgressBar> createState() => _AudioProgressBarState();
}

class _AudioProgressBarState extends State<AudioProgressBar> {

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final buffer = widget.duration.inMilliseconds > 0 ? widget.bufferedPosition.inMilliseconds / widget.duration.inMilliseconds : 0.0;
    final progress = widget.duration.inMilliseconds > 0 ? widget.position.inMilliseconds / widget.duration.inMilliseconds : 0.0;
    return Stack(
      children: [
        LinearProgressIndicator(
          minHeight: 1,
          value: buffer,
          backgroundColor: defaultColorScheme.onPrimaryContainer,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          color: Colors.grey,
        ),
        LinearProgressIndicator(
          minHeight: 1,
          value: progress,
          backgroundColor: Colors.black,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          color: Colors.white,
        ),
      ],
    );
  }
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
