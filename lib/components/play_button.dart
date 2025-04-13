
import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:video_player/video_player.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({super.key,
    required this.previous, required this.next, required this.controller, required this.shuffle, required this.loop});
  final VideoPlayerController? controller;
  final VoidCallback previous;
  final VoidCallback next;
  final Function(bool) shuffle;
  final Function(bool) loop;


  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool _isShuffle = false;
  bool _isLoop = false;

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final isPlaying = widget.controller?.value.isPlaying ?? false;
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: (){
                setState(() {
                  _isShuffle = !_isShuffle;
                  _isLoop = false;
                });
                widget.shuffle(_isShuffle);
              },
              icon: Icon(
                Icons.shuffle_rounded,
                color: _isShuffle ? Colors.pinkAccent:defaultColorScheme.primary,
              )),
           IconButton(
              iconSize: 45,
              onPressed: widget.previous,
              icon: Icon(
                Icons.skip_previous,
                color: defaultColorScheme.primary,
              )),
          if(widget.controller != null)
            IconButton(
              iconSize: 60,
              onPressed: (){
                if(widget.controller?.value.isPlaying == true){
                  widget.controller?.pause();
                }else{
                  widget.controller?.play();
                }
                setState(() {});
              }, icon: Icon(isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded, color: Colors.white,))
           else
            SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(color: defaultColorScheme.primary,)),
           IconButton(
              iconSize: 45,
              onPressed: widget.next,
              icon: Icon(
                Icons.skip_next,
                color: defaultColorScheme.primary,
              )),
          IconButton(
              onPressed: (){
                setState(() {
                  _isLoop = !_isLoop;
                  _isShuffle = false;
                });
                widget.loop(_isLoop);
              },
              icon: Icon(
                Icons.loop_rounded,
                color: _isLoop ? Colors.pinkAccent:defaultColorScheme.primary,
              )),
        ],
      ),
    );
  }
}
