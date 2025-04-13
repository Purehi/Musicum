import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:http/http.dart' as http;
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/components/pagination_card.dart';
import 'package:you_tube_music/components/progress_with_icon.dart';
import 'package:you_tube_music/model/data.dart';

import '../../model/youtube_music_link_manager.dart';
import '../album/album_page.dart';
import '../artists/artists_page.dart';
import '../player/song_player_page.dart';
import '../playlist/playlist_page.dart';

class SearchMorePage extends StatefulWidget {
  const SearchMorePage({super.key, required this.playlistSection,});
  final PlaylistSection playlistSection;

  @override
  State<SearchMorePage> createState() => _SearchMorePageState();
}

class _SearchMorePageState extends State<SearchMorePage> {
  List<MusicVideo> _videos = [];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final params = widget.playlistSection.browseId;
    final query = widget.playlistSection.params;
    if(params != null && query != null){
      _fetchSearchResultsByPrams(query, params);
    }

  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.playlistSection.title, style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold, color:Colors.white),),
          backgroundColor: defaultColorScheme.surface,
          elevation: 0,
          leading: BackButton(
            color: defaultColorScheme.primary,
          ),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if(_videos.isEmpty){
                        return const ProgressWithIcon();
                      }else{
                        final musicVideo = _videos[index];
                        return InkWell(
                            onTap: (){
                              if(musicVideo.videoId.isNotEmpty){//跳转音乐播放器
                                PictureInPicture.stopPiP();
                                YoutubeMusicLinkManager.shared.getYouTubeMusicURL(musicVideo);
                                Future.delayed(Duration(milliseconds: 200), (){
                                  if(context.mounted){
                                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                        builder: (_) => SongPlayerPage(musicVideo: musicVideo,)));
                                  }
                                });
                              }else if(musicVideo.browseId != null){
                                if(musicVideo.browseId!.startsWith('UC')){//artists
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ArtistsPage(musicVideo: musicVideo,)));
                                }else if(musicVideo.browseId!.startsWith('MP')){//jump to album
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => AlbumPage(musicVideo: musicVideo,)));
                                }else{//jump to playlist
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => PlaylistPage(musicVideo: musicVideo,)));
                                }
                              }
                            },
                            child: PaginationCard(musicVideo: musicVideo));
                      }
                },
                childCount: _videos.isEmpty ? 1 : _videos.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  // keyword
  Future<void> _fetchSearchResultsByPrams(String query, String prams) async {
    Map<String, dynamic> body = {
      "context": {
        "client": {
          "hl": languageCode,
          "gl": countryCode,
          "clientVersion": musicClientVersion,
          "clientName": musicClientName,
          "osName": osName,
          "deviceMake": deviceMake,
          "clientFormFactor": clientFormFactor,
          "platform": platform,
          "osVersion": osVersion,
          "visitorData": visitorData,
          'deviceModel': model
        }
      },
      "query":query,
      "params":prams
    };
    final uri = Uri.parse('$host/search?key=$key&prettyPrint=false');
    final response = await http.post(uri, body: json.encode(body));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List<dynamic>?tabs = parseTabs(result);
      List<MusicVideo> videos = [];
      if(tabs != null){
        for(final tab in tabs){
          List<dynamic>?contents = parseContents(tab);
          if(contents != null){
            for(final content in contents){
              final List<MusicVideo>? mvs = parseSearchMusicVideos(content);
              if(mvs != null){
                videos.addAll(mvs);
              }
              // final musicShelfRenderer = content["musicShelfRenderer"];
              // if(musicShelfRenderer != null){
              //   final List<dynamic>?continuations = musicShelfRenderer["continuations"];
              //   if(continuations != null){
              //     for(final continuation in continuations){
              //       final nextContinuationData = continuation["nextContinuationData"];
              //       if(nextContinuationData != null){
              //         final continuation = nextContinuationData["continuation"];
              //       }
              //     }
              //   }
              // }
            }
          }
        }
      }
      if(videos.isNotEmpty){
        setState(() {
          _videos = videos;
        });
      }
    }
  }
}
