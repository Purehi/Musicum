import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/components/playlist_section_song_card.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:http/http.dart' as http;
import 'package:you_tube_music/components/progress_with_icon.dart';

import '../../components/glass_morphism_card.dart';
import '../../model/youtube_music_link_manager.dart';
import '../player/song_player_page.dart';


class PlaylistSectionPage extends StatefulWidget {
  const PlaylistSectionPage({super.key, required this.playlistSection});
  final PlaylistSection playlistSection;
  @override
  State<PlaylistSectionPage> createState() => _PlaylistSectionPageState();
}

class _PlaylistSectionPageState extends State<PlaylistSectionPage> {
  final List<MusicVideo> _videos = [];
  String? _title;
  String? _subtitle;
  String? _thumbnail;
  @override
  void initState() {
    _fetchMoreMusicVideos();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          scrolledUnderElevation:0.0,
          shadowColor: Colors.transparent,
          leading: BackButton(
            style: ButtonStyle(visualDensity: VisualDensity(horizontal: -3.0, vertical: -3.0),),
            color: Colors.white,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(_thumbnail ?? ''),)
          ),
          child: GlassMorphismCard(
            blur: 30,
            color: Colors.black54,
            opacity: 0.6,
            borderRadius: BorderRadius.circular(0),
            child: CustomScrollView(
                slivers: [
                  if(_thumbnail != null)SliverToBoxAdapter(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: kToolbarHeight + 24.0),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 16/9,
                            child:CachedNetworkImage(
                              fadeInDuration: Duration.zero,
                              fadeOutDuration: Duration.zero,
                              imageUrl: _thumbnail ?? '',
                              imageBuilder: (context, imageProvider){
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 24.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,),
                                  ),
                                );
                              },
                              placeholder: (context, url) => Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: defaultColorScheme.onPrimaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),

                          ),
                          IconButton(
                            onPressed: (){
                              final musicVideo = _videos.first;
                              PictureInPicture.stopPiP();
                              YoutubeMusicLinkManager.shared.getYouTubeMusicURL(musicVideo);
                              Future.delayed(Duration(milliseconds: 200), (){
                                if(context.mounted){
                                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                      builder: (_) => SongPlayerPage(musicVideo: musicVideo,)));
                                }
                              });
                            },
                            icon: Icon(Icons.play_circle_fill_outlined, size: 60, color: defaultColorScheme.primary),),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(
                          top: 12.0,
                        ),
                        child: Column(
                          children: [
                            Text(
                              _title ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              _subtitle?.replaceAll('YouTube', '') ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        if (_videos.isEmpty){
                          return Column(
                            children: [
                              SizedBox(height: 64,),
                              const ProgressWithIcon(),
                            ],
                          );
                        }else{
                          final musicVideo = _videos[index];
                          return InkWell(
                            onTap: (){
                              PictureInPicture.stopPiP();
                              YoutubeMusicLinkManager.shared.getYouTubeMusicURL(musicVideo);
                              Future.delayed(Duration(milliseconds: 200), (){
                                if(context.mounted){
                                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                      builder: (_) => SongPlayerPage(musicVideo: musicVideo,)));
                                }
                              });
                            },
                              child: PlaylistSectionSongCard(musicVideo: musicVideo));
                        }
                      },
                      childCount:_videos.isEmpty ? 1 : _videos.length,
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchMoreMusicVideos() async {
    if(widget.playlistSection.browseId == null)return;
    String browseId = widget.playlistSection.browseId!;
    if(!widget.playlistSection.browseId!.startsWith('VL')){
      browseId = 'VL$browseId';
    }
    Map<String, dynamic> body = {
      "context": {
        "client": {
          "hl": languageCode,
          "gl": countryCode,
          "clientVersion": musicWebClientVersion,
          "clientName": musicWebClientName,
          "osName": osName,
          "deviceMake": deviceMake,
          "clientFormFactor": clientFormFactor,
          "platform": platform,
          "osVersion": osVersion,
          "visitorData": visitorData,
          'deviceModel': model
        }
      },
      "browse_id":browseId,
    };
    final uri = Uri.parse('$musicHost/browse?key=$key&prettyPrint=false');
    final response = await http.post(uri, body: json.encode(body));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List<MusicVideo> videos = [];
      final contents = result?['contents'];
      final twoColumnBrowseResultsRenderer = contents?['twoColumnBrowseResultsRenderer'];
      final secondaryContents = twoColumnBrowseResultsRenderer?['secondaryContents'];
      final sectionListRenderer = secondaryContents?['sectionListRenderer'];
      final List<dynamic>? tmpContents = sectionListRenderer?['contents'];
      final tmpContent = tmpContents?.firstOrNull;
      final musicPlaylistShelfRenderer = tmpContent?['musicPlaylistShelfRenderer'];
      final mvs = parseArtistsSongs(musicPlaylistShelfRenderer);
      if(mvs != null){
        videos.addAll(mvs);
      }

      final List<dynamic>? tabs = twoColumnBrowseResultsRenderer?['tabs'];
      final tab = tabs?.firstOrNull;
      final tabRenderer = tab?['tabRenderer'];
      final content = tabRenderer?['content'];
      final tmpSectionListRenderer = content?['sectionListRenderer'];
      final List<dynamic>? tempContents = tmpSectionListRenderer?['contents'];
      final tempContent = tempContents?.firstOrNull;
      final musicResponsiveHeaderRenderer = tempContent?['musicResponsiveHeaderRenderer'];
      final thumbnail = musicResponsiveHeaderRenderer?['thumbnail'];
      final musicThumbnailRenderer = thumbnail?['musicThumbnailRenderer'];
      final tempThumbnail = musicThumbnailRenderer?['thumbnail'];
      final List<dynamic>? thumbnails = tempThumbnail?['thumbnails'];
      final tmpThumbnail = thumbnails?.firstOrNull;
      final url = tmpThumbnail?['url'];
      final title = musicResponsiveHeaderRenderer?['title'];
      final titleText = parseText(title?['runs']);
      final subtitle = musicResponsiveHeaderRenderer?['subtitle'];
      final subtitleText = parseText(subtitle?['runs']);
      final secondSubtitle = musicResponsiveHeaderRenderer?['secondSubtitle'];
      final secondSubtitleText = parseText(secondSubtitle?['runs']);

      final description = musicResponsiveHeaderRenderer?['description'];
      final musicDescriptionShelfRenderer = description?['musicDescriptionShelfRenderer'];
      final tmpDescription = musicDescriptionShelfRenderer?['description'];
      final descriptionText = parseText(tmpDescription?['runs']) ?? '';

      if(videos.isNotEmpty){
        setState(() {
          _title = titleText;
          _thumbnail = url;
          _subtitle = '$subtitleText $secondSubtitleText\n$descriptionText';
          _videos.addAll(videos);
        });
      }

    }
  }
}
