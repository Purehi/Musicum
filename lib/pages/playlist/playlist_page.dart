import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/components/playlist_song_card.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:http/http.dart' as http;
import 'package:you_tube_music/components/progress_with_icon.dart';
import 'package:you_tube_music/model/youtube_music_link_manager.dart';
import '../../components/glass_morphism_card.dart';
import '../player/song_player_page.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key, required this.musicVideo});
  final MusicVideo musicVideo;
  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  String? _continuation;
  final List<MusicVideo> _videos = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_loadMore);
    _fetchMoreMusicVideos();
    super.initState();

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
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(child: Column(
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
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleLarge?.copyWith(
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
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        if (_videos.isEmpty){
                          return const ProgressWithIcon();
                        }else{
                          final musicVideo = _videos[index];
                          if(index == _videos.length - 1){
                            return Column(
                              children: [
                                InkWell(
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
                                    child: PlaylistSongCard(musicVideo: musicVideo)),
                                const ProgressWithIcon()
                              ],
                            );
                          }else{
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
                                child: PlaylistSongCard(musicVideo: musicVideo));
                          }
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
    if(widget.musicVideo.browseId == null)return;
    String browseId = widget.musicVideo.browseId!;
    if(!widget.musicVideo.browseId!.startsWith('VL')){
      browseId = 'VL$browseId';
    }
    Map<String, dynamic> body = {
      "context": {
        "client": {
          "hl": languageCode,
          "gl": countryCode,
          "clientVersion": clientVersion,
          "clientName": clientName,
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
    final uri = Uri.parse('$host/browse?key=$key&prettyPrint=false');
    final response = await http.post(uri, body: json.encode(body));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List<dynamic>?tabs = parseTabs(result);
      String? nextContinuation;
      List<MusicVideo> videos = [];
      for(final tab in tabs ?? []){
        List<dynamic>?contents = parseContents(tab);
        for(final content in contents ?? []){
          final List<MusicVideo>? mvs = parsePlaylistMusicVideos(content);
          if(mvs != null){
            videos.addAll(mvs..shuffle());
          }
          nextContinuation ??= parsePlaylistContinuations(content);
        }
      }
      if(videos.isNotEmpty){
        setState(() {
          _continuation = nextContinuation;
          _videos.addAll(videos);
        });
      }

    }
  }
  void _loadMore() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if(!_isLoading){
        _isLoading = true;
        if(_continuation != null){
          _fetchMoreMusicVideosContinuation(_continuation!);
        }
      }
    }
  }
  Future<void> _fetchMoreMusicVideosContinuation(String continuation) async {
    Map<String, dynamic> body = {
      "context": {
        "client": {
          "hl": languageCode,
          "gl": countryCode,
          "clientVersion": clientVersion,
          "clientName": clientName,
          "osName": osName,
          "deviceMake": deviceMake,
          "clientFormFactor": clientFormFactor,
          "platform": platform,
          "osVersion": osVersion,
          'deviceModel': model
        }
      },
      "continuation":continuation,
    };
    final uri = Uri.parse('$host/browse?key=$key&prettyPrint=false');
    final response = await http.post(uri, body: json.encode(body));
    if (response.statusCode == 200) {
      _isLoading = false;
      final result = jsonDecode(response.body);
      final continuationContents = result?["continuationContents"];
      if(continuationContents != null){
        final List<MusicVideo> videos = [];
        final List<MusicVideo>?mvs = parsePlaylistContinuationVideos(continuationContents);
        if(mvs != null){
          videos.addAll(mvs);
        }
        if(videos.isNotEmpty){
          setState(() {
            _videos.addAll(videos..shuffle());
          });
        }
      }
    }
  }
}
