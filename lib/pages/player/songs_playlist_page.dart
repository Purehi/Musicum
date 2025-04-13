import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/components/songs_playlist_card.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:you_tube_music/components/progress_with_icon.dart';

class SongsPlaylistPage extends StatefulWidget {
  const SongsPlaylistPage({super.key, required this.musicVideos, required this.index, required this.onTap});
  final List<MusicVideo> musicVideos;
  final int index;
  final Function(MusicVideo musicVideo) onTap;
  @override
  State<SongsPlaylistPage> createState() => _SongsPlaylistPageState();
}

class _SongsPlaylistPageState extends State<SongsPlaylistPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: Container(
        color: Colors.black,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.62,
        ),
        child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (widget.musicVideos.isEmpty){
                      return const ProgressWithIcon();
                    }else{
                      final musicVideo = widget.musicVideos[index];
                      if(widget.index == index){
                        return SongsPlaylistCard(musicVideo: musicVideo, index: index, playing: true,);
                      }
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                          widget.onTap(musicVideo);
                        },
                          child: SongsPlaylistCard(musicVideo: musicVideo, index: index, playing: false,));
                    }
                  },
                  childCount:widget.musicVideos.isEmpty ? 1 : widget.musicVideos.length,
                ),
              ),
            ]
        ),
      ),
    );
  }
}
