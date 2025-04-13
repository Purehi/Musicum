import 'dart:convert';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:you_tube_music/components/artists_circular_card.dart';
import 'package:you_tube_music/components/playlist_card.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:you_tube_music/pages/pagination/pagination_page.dart';
import 'package:you_tube_music/pages/playlist/playlist_section_page.dart';
import 'package:you_tube_music/pages/release/artists_release_page.dart';
import '../../components/album_card.dart';
import '../../components/carsouel_card.dart';
import '../../model/youtube_music_link_manager.dart';
import '../player/song_player_page.dart';
class ArtistsPage extends StatefulWidget {
  const ArtistsPage({super.key, required this.musicVideo});
  final MusicVideo musicVideo;

  @override
  State<ArtistsPage> createState() => _ArtistsPageState();
}

class _ArtistsPageState extends State<ArtistsPage> {
  String? _title;
  String? _subTitle;
  PlaylistSection? _songSection;
  final List<PlaylistSection> _sections = [];
  @override
  void initState() {
    _fetchArtists();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: defaultColorScheme.surface,
        scrolledUnderElevation:0.0,
        shadowColor: Colors.transparent,
        elevation: 0.0,
        title:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _title ?? '',
              style: textTheme.headlineSmall?.copyWith(
                color: defaultColorScheme.primary,
              ),
            ),
            Text(
              _subTitle ?? '',
              style: textTheme.titleMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        leading: BackButton(
          style: const ButtonStyle(visualDensity: VisualDensity(horizontal: -3.0, vertical: -3.0),),
          color: defaultColorScheme.primary,
        ),
      ),
      body:  CustomScrollView(
        slivers: [
          if(_songSection != null)SliverToBoxAdapter(child:PaginationPage(playListSection: _songSection!),),
          if(_songSection == null && _sections.isEmpty)SliverToBoxAdapter(child: Column(
              children: [
                SizedBox(height: 64,),
                CircularProgressIndicator(color: defaultColorScheme.primary,),
              ],
            ),),
          SliverToBoxAdapter(child: Column(
            spacing: 20.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(_sections.isNotEmpty)_buildPlaylistSections(_sections),
            ],
          ),),
        ],
      ),
    );
  }
  Widget _buildPlaylistSections(List<PlaylistSection> playListSections){
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final itemWidth = size.width * 0.8;
    if(playListSections.isNotEmpty){
      List<Widget> listItems = [];
      for(final playListSection in playListSections){
        final first = playListSection.items.firstOrNull;
        if(first?.videoId != null && first!.videoId.isNotEmpty){
          listItems.add(Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(playListSection.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headlineSmall?.copyWith(color: defaultColorScheme.primary),
                      ),
                    ),
                    if(playListSection.browseId != null)InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PlaylistSectionPage(playlistSection: playListSection,)));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                            color: defaultColorScheme.surface,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            border: Border.all(color: defaultColorScheme.onPrimaryContainer)
                        ),
                        child: Text(playListSection.buttonText ?? 'More', style: textTheme.titleMedium?.copyWith(
                            color: defaultColorScheme.primary
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 12.0,
                  children: playListSection.items.asMap().map((index, musicVideo) =>
                      MapEntry(index, SizedBox(
                        width:  itemWidth,
                        child: InkWell(
                          onTap: (){
                            PictureInPicture.stopPiP();
                            YoutubeMusicLinkManager.shared.getYouTubeMusicURL(musicVideo);
                            Future.delayed(Duration(milliseconds: 200), (){
                              if(mounted){
                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                    builder: (_) => SongPlayerPage(musicVideo: musicVideo,)));
                              }
                            });
                          },
                            child: CarsouelCard(musicVideo: musicVideo,)),
                      ))).values.toList(),
                ),)
            ],
          ));
        }
        else if(first?.browseId != null && first!.browseId!.startsWith('MP')){
          if(first.browseId!.startsWith('MPSPPL'))return SizedBox.shrink();
          listItems.add(Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(playListSection.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headlineSmall?.copyWith(color: defaultColorScheme.primary),
                      ),
                    ),
                    if(playListSection.browseId != null)InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ArtistsReleasePage(playlistSection: playListSection,)));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                            color: defaultColorScheme.surface,
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            border: Border.all(color: defaultColorScheme.onPrimaryContainer)
                        ),
                        child: Text(playListSection.buttonText ?? 'More', style: textTheme.titleMedium?.copyWith(
                            color: defaultColorScheme.primary
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: playListSection.items.asMap().map((index, musicVideo) =>
                      MapEntry(index, AlbumCard(musicVideo: musicVideo))).values.toList(),
                ),),
            ],
          ));
        }else if(first?.browseId != null && (first!.browseId!.startsWith('VL') || first.browseId!.startsWith('PL') || first.browseId!.startsWith('OL'))){
          listItems.add(Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(playListSection.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headlineSmall?.copyWith(color: defaultColorScheme.primary),
                      ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: playListSection.items.asMap().map((index, musicVideo) =>
                      MapEntry(index, PlaylistCard(musicVideo: musicVideo))).values.toList(),
                ),),
            ],
          ));
        }else if(first?.browseId != null && first!.browseId!.startsWith('UC')){
          listItems.add(Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
                  top: 20
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(playListSection.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headlineSmall?.copyWith(color: defaultColorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: playListSection.items.asMap().map((index, musicVideo) =>
                      MapEntry(index, ArtistsCircularCard(musicVideo: musicVideo))).values.toList(),
                ),),
            ],
          ));
        }
      }
      return Column(children: listItems);
    }
    return SizedBox.shrink();

  }
  //获取音乐视频首页数据
  Future<void> _fetchArtists() async {
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
      "browse_id":widget.musicVideo.browseId
    };
    final uri = Uri.parse('$musicHost/browse?key=$musicKey&prettyPrint=false');
    final response = await http.post(uri, body: json.encode(body));
    if (response.statusCode == 200) {
      final result = await compute(_parseData, response.body);
      final title = result['title'];
      final subTitle = result['subTitle'];
      final songSection = result['songSection'];
      final sections = result['sections'];

      setState(() {
        _title = title;
        _subTitle = subTitle;
        _songSection = songSection;
        _sections.addAll(sections);
      });

    }
  }
  static Map<String, dynamic> _parseData(String responseBody) {
    final result = jsonDecode(responseBody);
    final header = result?['header'];
    final musicImmersiveHeaderRenderer = header?['musicImmersiveHeaderRenderer'];
    final title = musicImmersiveHeaderRenderer?['title'];
    final titleText = parseText(title?['runs']);

    final subscriptionButton = musicImmersiveHeaderRenderer?['subscriptionButton'];
    final subscribeButtonRenderer = subscriptionButton?['subscribeButtonRenderer'];
    final subscriberCountText = subscribeButtonRenderer?['subscriberCountText'];
    final subscriberCount = parseText(subscriberCountText?['runs']);

    final thumbnail = musicImmersiveHeaderRenderer?['thumbnail'];
    final musicThumbnailRenderer = thumbnail?['musicThumbnailRenderer'];
    final url = parseThumbnail(musicThumbnailRenderer);
    PlaylistSection? songSection;
    List<PlaylistSection> sections = [];
    final tabs = parseTabs(result);
    final tab = tabs?.firstOrNull;
    final contents = parseContents(tab);
    for(final content in contents ?? []){
      final musicShelfRenderer = content?['musicShelfRenderer'];
      if(musicShelfRenderer != null){
        final title = musicShelfRenderer?['title'];
        final titleText = parseText(title?['runs']);
        final bottomText = musicShelfRenderer?['bottomText'];
        final bottom = parseText(bottomText?['runs']);
        final bottomEndpoint = musicShelfRenderer?['bottomEndpoint'];
        final browseEndpoint = bottomEndpoint?['browseEndpoint'];
        final browseId = browseEndpoint?['browseId'];
        final params = browseEndpoint?['params'];
        final items = parseArtistsSongs(musicShelfRenderer);
        if(items != null){
          songSection = PlaylistSection(title: titleText ?? '', items: items);
          songSection.buttonText = bottom;
          songSection.browseId = browseId;
          songSection.params = params;
        }
      }else{
        final musicCarouselShelfRenderer = content?['musicCarouselShelfRenderer'];
        final header = musicCarouselShelfRenderer?['header'];
        final musicCarouselShelfBasicHeaderRenderer = header?['musicCarouselShelfBasicHeaderRenderer'];
        final title = musicCarouselShelfBasicHeaderRenderer?['title'];
        final titleText = parseText(title?['runs']);
        final moreContentButton = musicCarouselShelfBasicHeaderRenderer?['moreContentButton'];
        final buttonRenderer = moreContentButton?['buttonRenderer'];
        final text = buttonRenderer?['text'];
        final button = parseText(text?['runs']);
        final navigationEndpoint = buttonRenderer?['navigationEndpoint'];
        final browseEndpoint = navigationEndpoint?['browseEndpoint'];
        final browseId = browseEndpoint?['browseId'];
        final params = browseEndpoint?['params'];
        final mvs = parseMusicVideos(musicCarouselShelfRenderer);
        if(mvs != null){
          final section = PlaylistSection(title: titleText ?? '', items: mvs);
          section.buttonText = button;
          section.params = params;
          section.browseId = browseId;
          sections.add(section);
        }
      }

    }

    return {
      'title' : titleText,
      'subTitle' : subscriberCount,
      'thumbnail': url,
      'songSection': songSection,
      'sections':sections
    };
  }
}
