import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:you_tube_music/pages/pagination/pagination_page.dart';

import '../../model/youtube_music_link_manager.dart';
import '../player/song_player_page.dart';

class MusicSectionPage extends StatefulWidget {
  const MusicSectionPage({super.key});

  @override
  State<MusicSectionPage> createState() => _MusicSectionPageState();
}

class _MusicSectionPageState extends State<MusicSectionPage> {
  String? _title;
  final List<MusicVideo> _videos = [];
  final List<PlaylistSection> _sections = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _fetchHotMusicVideos();
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
        appBar: AppBar(
          backgroundColor: defaultColorScheme.surface,
          elevation: 0,
          title: Row(
            children: [
              if(_title != null)Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text: _title!,
                        style: textTheme.headlineSmall?.copyWith(
                            color:defaultColorScheme.primary,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        extendBody: true,
        body:CustomScrollView(
            controller: _scrollController,
            slivers: [
              if(_videos.isNotEmpty)SliverToBoxAdapter(child:
              ExpandableCarousel.builder(
                itemCount: _videos.length,
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            PictureInPicture.stopPiP();
                            YoutubeMusicLinkManager.shared.getYouTubeMusicURL(_videos[itemIndex]);
                            Future.delayed(Duration(milliseconds: 200), (){
                              if(context.mounted){
                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                                    builder: (_) => SongPlayerPage(musicVideo: _videos[itemIndex],)));
                              }
                            });
                          },
                          child: Container(
                            width:MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.25,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(_videos[itemIndex].thumbnail ?? ''),
                                  fit: BoxFit.cover
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_videos[itemIndex].title ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleMedium?.copyWith(color: defaultColorScheme.primary),),
                                Text(_videos[itemIndex].subtitle ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(color: defaultColorScheme.onPrimary),),

                              ]),
                        ),
                      ],
                    ),
                options: ExpandableCarouselOptions(
                  showIndicator: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),),
              )),
              SliverToBoxAdapter(child: _buildItem(_sections),),
            ]
        ),
      ),
    );
  }
  Widget? _buildItem(List<PlaylistSection>? sections){

    if(sections != null){
      List<Widget> list = [];
      for(final section in sections){
        final item = PaginationPage(playListSection: section);
        list.add(item);
      }
      if(list.isNotEmpty){
        return Column(
          children: list,
        );
      }
    }
    return null;
  }


  Future<void> _fetchHotMusicVideos() async {
    try {
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
        "browse_id": "UC-9-kyTW8ZkZNDHQJ6FgpwQ",
      };
      final uri = Uri.parse('$host/browse?alt=json&key=$key&prettyPrint=false');
      final response = await http.post(uri, body: json.encode(body));
      if (response.statusCode == 200) {
        final result = await compute(_parseData, response.body);
        final videos = result['videos'];
        final sections = result['sections'];
        final title = result['title'];

        setState(() {
          _videos.addAll(videos);
          _sections.addAll(sections);
          _title = title;
        });
      }
    } catch (error) {
      rethrow;
    }
  }
  static Map<String, dynamic> _parseData(String responseBody) {
    final result = jsonDecode(responseBody);
    List<dynamic>?tabs = parseTabs(result);
    List<MusicVideo>? videos = [];
    List<PlaylistSection>? sections = [];
    String? titleText;
    if (tabs != null) {
      List<dynamic>?contents = parseContents(tabs.first);
      if (contents != null) {
        for (final content in contents) {
          final List<MusicVideo>?mvs = parseMusicCarouselItems(content);
          if (mvs != null) {
            videos.addAll(mvs);
          } else {
            final section = parseMusicPlaylistSections(content);
            if (section != null && section.items.isNotEmpty) {
              sections.add(section);
            }
          }
        }
      }
      if (sections.isNotEmpty) {
        final header = result["header"];
        if (header != null) {
          final feedTabbedHeaderRenderer = header["feedTabbedHeaderRenderer"];
          if (feedTabbedHeaderRenderer != null) {
            final title = feedTabbedHeaderRenderer["title"];
            if (title != null) {
              titleText = parseText(title["runs"]);
            }
          }
        }
      }
    }
    return {
      'videos' : videos,
      'sections' : sections,
      'title': titleText,
    };
  }
}
