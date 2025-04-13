import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';
import 'package:you_tube_music/components/artists_card.dart';
import 'package:you_tube_music/components/pagination_card.dart';
import 'package:you_tube_music/model/youtube_music_link_manager.dart';
import 'package:you_tube_music/pages/artists/artists_page.dart';
import 'package:you_tube_music/pages/player/song_player_page.dart';
import 'package:you_tube_music/pages/playlist/playlist_page.dart';

import '../../model/data.dart';
class PaginationSubPage extends StatefulWidget {
  const PaginationSubPage({super.key, required this.musicVideos});
  final List<MusicVideo> musicVideos;

  @override
  State<PaginationSubPage> createState() => _PaginationSubPageState();
}

class _PaginationSubPageState extends State<PaginationSubPage> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final musicVideo = widget.musicVideos[index];
          if(musicVideo.browseId != null && musicVideo.browseId!.startsWith('UC')){//artists
            return InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ArtistsPage(musicVideo: musicVideo,)));
                },
                child: ArtistsCard(musicVideo: musicVideo));
          }
          return InkWell(
            onTap: (){
              if(musicVideo.videoId.isNotEmpty){//jump to song player
                PictureInPicture.stopPiP();
                YoutubeMusicLinkManager.shared.getYouTubeMusicURL(musicVideo);
                Future.delayed(Duration(milliseconds: 200), (){
                  if(context.mounted){
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                        builder: (_) => SongPlayerPage(musicVideo: musicVideo,)));
                  }
                });

              }else if(musicVideo.browseId != null){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PlaylistPage(musicVideo: musicVideo,)));
              }
            },
              child: PaginationCard(musicVideo: musicVideo));
        },
        separatorBuilder: (context, position) {
          return SizedBox.shrink();
        },
        itemCount: widget.musicVideos.length,
      ),
    );
  }
}
