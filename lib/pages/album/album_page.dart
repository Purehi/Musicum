import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/components/album_song_card.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:http/http.dart' as http;
import 'package:you_tube_music/components/progress_with_icon.dart';
import '../../components/glass_morphism_card.dart';
import '../../model/youtube_music_link_manager.dart';
import '../player/song_player_page.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key, required this.musicVideo});
  final MusicVideo musicVideo;

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final List<MusicVideo> _videos = [];

  @override
  void initState() {
    super.initState();
    _fetchMoreMusicVideos();
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
                image: CachedNetworkImageProvider(widget.musicVideo.thumbnail ?? ''),)
          ),
          child: GlassMorphismCard(
            blur: 30,
            color: Colors.black54,
            opacity: 0.6,
            borderRadius: BorderRadius.circular(0),
            child: CustomScrollView(
              slivers: [
                if(widget.musicVideo.thumbnail != null)SliverToBoxAdapter(child: Column(
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
                            imageUrl: widget.musicVideo.thumbnail ?? '',
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
                            musicVideo.thumbnail = widget.musicVideo.thumbnail;
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
                            widget.musicVideo.title ?? '',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            widget.musicVideo.subtitle?.replaceAll('YouTube', '') ?? '',
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
                SliverList.builder(
                    itemCount: _videos.isEmpty ? 1 : _videos.length,
                    itemBuilder: (context, index){
                      if (_videos.isEmpty){
                        return const ProgressWithIcon();
                      }else{
                        final musicVideo = _videos[index];
                        musicVideo.thumbnail = widget.musicVideo.thumbnail;
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
                          child: AlbumSongCard(musicVideo: musicVideo,
                            index: index,),
                        );
                      }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _fetchMoreMusicVideos() async {
    if(widget.musicVideo.browseId == null)return;
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
      "browse_id":widget.musicVideo.browseId,
    };
    final uri = Uri.parse('$host/browse?key=$key&prettyPrint=false');
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
              final List<MusicVideo>? mvs = parseAlbumMusicVideos(content);
              if(mvs != null){
                videos.addAll(mvs);
              }
            }
          }
        }
      }
      if(videos.isNotEmpty){
        if(!mounted)return;
        setState(() {
          _videos.addAll(videos);
        });
      }
    }
  }
}
