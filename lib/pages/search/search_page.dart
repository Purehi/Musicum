import 'dart:convert';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/components/pagination_card.dart';
import 'package:you_tube_music/components/suggestion_card.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:you_tube_music/components/progress_with_icon.dart';
import 'package:you_tube_music/pages/album/album_page.dart';
import 'package:you_tube_music/pages/playlist/playlist_page.dart';
import 'package:you_tube_music/pages/search/search_more_page.dart';
import '../../model/youtube_music_link_manager.dart';
import '../artists/artists_page.dart';
import '../player/song_player_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final txt = TextEditingController();
  bool _isResultNotFound = false;
  bool _isQueryKeyword = false;
  bool _isQuery = false;
  String _queryKeyword = '';
  String _searchKeyword = '';
  List<String> _suggestions = [];
  List<PlaylistSection> _sections = [];
  final _scrollController = ScrollController();

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
          leading: BackButton(
            color: defaultColorScheme.primary,
          ),
          title: TextField(
            autofocus: true,
            controller: txt,
            style: textTheme.titleMedium?.copyWith(color:
            defaultColorScheme.primary),
            onChanged: (query) {
              txt.text = query;
              if(query.isNotEmpty){
                _fetchKeyword(query);
              }
            },
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: defaultColorScheme.onPrimaryContainer,
                hintText: 'Search',
                hintStyle: textTheme.titleMedium?.copyWith(color:
                defaultColorScheme.primary,),
                prefixIcon: Icon(Icons.search, color: defaultColorScheme.primary,),
                suffixIcon: IconButton(
                  /// clear text
                  onPressed: (){
                    txt.text = '';
                    setState(() {
                      _isQueryKeyword = false;
                      _suggestions = [];
                    });
                  },
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: defaultColorScheme.primary,
                  ),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none
                )
            ),

          ),
        ),
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                if(_sections.isNotEmpty)
                  SliverToBoxAdapter(child: Column(
                  spacing: 20.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPlaylistSections(_sections),
                  ],
                ),)
                else
                  SliverToBoxAdapter(child: Builder(builder: (context){
                    if(_isQuery){
                      return const Center(child: ProgressWithIcon(),);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 220),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(_isResultNotFound ? 'Sorry, Please try changing the keywords' : 'Search music in Musicum.',
                              style: const TextStyle(fontSize: 20, color: Colors.grey),
                              textAlign: TextAlign.center)),
                    );
                  }),),
              ],
            ),
            if(_isQueryKeyword) Container(
              color: defaultColorScheme.surface,
              height: 300,
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (BuildContext context, int index) {
                  final text = _suggestions[index];
                  return InkWell(
                      onTap: (){
                        FocusManager.instance.primaryFocus?.unfocus();
                        txt.text = text;
                        setState(() {
                          _isQueryKeyword = false;
                        });
                        _fetchSearchResults(text);
                      },
                      child:SuggestionCard(text: text));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPlaylistSections(List<PlaylistSection> playListSections){
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    if(playListSections.isNotEmpty){
      List<Widget> listItems = [];
      for(final playListSection in playListSections){
        if(playListSection.browseId == 'EgWKAQJIAWoSEAMQBBAJEA4QChAFEBEQEBAV' ||
            playListSection.browseId == 'EgWKAQJQAWoSEAMQBBAJEA4QChAFEBEQEBAV'){
          continue;
        }
        listItems.add(Column(
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
                  if(playListSection.browseId != null)InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => SearchMorePage(playlistSection: playListSection,)));
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
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final musicVideo = playListSection.items[index];
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
              },
              separatorBuilder: (context, position) {
                return SizedBox.shrink();
              },
              itemCount: playListSection.items.length,
            ),
          ],
        ));
      }
      return Column(children: listItems);
    }
    return SizedBox.shrink();

  }
  // keyword
  Future<void> _fetchKeyword(String keyword) async {
    if (keyword != _queryKeyword){
      _queryKeyword = keyword;
      _isQueryKeyword  =false;
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
        "input":keyword,
      };
      final uri = Uri.parse('$musicHost/music/get_search_suggestions?prettyPrint=false');
      final response = await http.post(uri, body: json.encode(body));
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final suggestions = parseSearchSuggestions(result);
        if(suggestions.isNotEmpty){
          setState(() {
            _isQueryKeyword = true;
            _suggestions = suggestions;
          });
        }
      }
    }
  }
  // keyword
  Future<void> _fetchSearchResults(String keyword) async {
    if(keyword != _searchKeyword && keyword != '') {
      _searchKeyword = keyword;
      _isResultNotFound = false;
      setState(() {
        _isQuery = true;
        _isQueryKeyword = false;
        _sections = [];
      });
      _queryKeyword = keyword;
      _isQueryKeyword  =false;

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
        "query":keyword,
        "suggestStats":{
          "validationStatus": "VALID",
          "parameterValidationStatus": "VALID_PARAMETERS",
          "clientName": "youtube-music",
          "searchMethod": "CLICKED_SUGGESTION",
          "inputMethods": [
            "KEYBOARD"
          ],
          "zeroPrefixEnabled": true
        }
      };
      final uri = Uri.parse('$musicHost/search?key=$musicKey&prettyPrint=false');
      final response = await http.post(uri, body: json.encode(body));
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        List<dynamic>?tabs = parseTabs(result);
        List<PlaylistSection> sections = [];
        for(final tab in tabs ?? []){
          List<dynamic>?contents = parseContents(tab);
          for(final content in contents ?? []){
            // dynamic map;
            // map = parseSearchMusicCardShelfRenderer(content);
           final section = parseWebSearchMusicShelfRenderer(content);
           if(section != null){
             sections.add(section);
           }
          }
        }
        setState(() {
          _sections.addAll(sections);
        });
      }else{
        debugPrint('search_page======${response.body}');
      }
    }

  }
}
