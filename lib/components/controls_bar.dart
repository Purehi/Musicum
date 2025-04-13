import 'dart:math';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:you_tube_music/model/data.dart';

class ControlsBar extends StatefulWidget {
  const ControlsBar({super.key,
    required this.video,
    required this.controller,
    required this.popup,
    required this.endPlay,
    this.remainPlay,
  });
  final MusicVideo video;
  final ChewieController controller;
  final VoidCallback popup;
  final Function(bool) endPlay;
  final Function(int)? remainPlay;

  @override
  State<ControlsBar> createState() => _ControlsBarState();
}

class _ControlsBarState extends State<ControlsBar> {
  double? _dragValue;
  late String _total;
  String _remain = '--:--';
  late VideoPlayerController _playerController;

  @override
  void initState() {
    super.initState();
    _playerController = widget.controller.videoPlayerController;
    final isLive = (widget.video.timestampStyle=='LIVE') ? true : false;
    if(!isLive){
      _playerController.addListener(_listener);
    }
    _total = _printDuration(_playerController.value.duration);
  }
  @override
  void dispose() {
    _playerController.removeListener(_listener);
    super.dispose();
  }
  void _listener(){
    final position = _playerController.value.position.inSeconds;
    final total = _playerController.value.duration.inSeconds;
    setState(() {
      _dragValue = position.toDouble();
      _remain = _printDuration(Duration(seconds: (total - position)));
      _total = _printDuration(Duration(seconds: total));
    });
    if(_playerController.value.isCompleted == true){
      widget.endPlay(true);
    }else{
      if(widget.remainPlay != null){
        widget.remainPlay!(total - position);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(top: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Builder(
            builder: (context) {
              final isLive = (widget.video.timestampStyle=='LIVE') ? true : false;
              if(isLive){
                return Row(
                  children: [
                    Text('LIVE', style: textTheme.bodySmall?.copyWith(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold
                    ),),
                    Expanded(
                      child: SliderTheme(data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(
                            disabledThumbRadius: 8,
                            enabledThumbRadius: 8,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 10,
                          ),
                          activeTrackColor: Colors.redAccent,
                          inactiveTrackColor: Colors.white70,
                          thumbColor: Colors.redAccent,
                          overlayColor: Colors.white70
                      ), child: Slider(
                        min: 0.0,
                        max: 1.0,
                        value: 1.0,
                        onChanged: (double value) {  },),
                      ),
                    ),
                    Text('--:--', style: textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                );
              }
              return Column(
                children: [
                  SliderTheme(data: SliderTheme.of(context).copyWith(
                      trackHeight: 2,
                      thumbShape: const RoundSliderThumbShape(
                        disabledThumbRadius: 8,
                        enabledThumbRadius: 8,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 10,
                      ),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white70,
                      thumbColor: Colors.white,
                      overlayColor: Colors.white70
                  ), child: Slider(
                    min: 0.0,
                    max:widget.controller.videoPlayerController.value.duration.inSeconds.toDouble(),
                    value: min(_dragValue ?? widget.controller.videoPlayerController.value.position.inSeconds.toDouble(),
                        widget.controller.videoPlayerController.value.duration.inSeconds.toDouble()),

                    onChanged: (value) async{
                      setState(() {
                        _dragValue = value;
                      });
                      _playerController.pause();
                      _playerController.seekTo(Duration(seconds: value.toInt())).then((_){
                        _playerController.play();
                      });
                    },
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0).copyWith(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_total, style: textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),),
                        Text('- $_remain', style: textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                  ),
                ],
              );
            }
        ),
      ),
    );
  }

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    if(duration.inHours > 0){
      return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }


}
