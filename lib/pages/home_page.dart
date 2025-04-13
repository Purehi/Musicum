import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/components/album_card.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:http/http.dart' as http;
import 'package:you_tube_music/pages/pagination/pagination_page.dart';
import 'package:you_tube_music/pages/search/search_page.dart';

import '../components/artists_circular_card.dart';
import '../components/playlist_card.dart';


class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  String? _slogan;

  List<PlaylistSection> _playListSections = [];
  String _titleText = 'Home';
  @override
  void initState() {
    _fetchHomeMusic();
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Builder(builder: (context){
          if(_playListSections.isEmpty) {
            return Center(child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator()));
          }
         return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: defaultColorScheme.surface,
                elevation: 0,
                title: Flex(direction: Axis.horizontal,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_titleText, style: textTheme.headlineSmall?.copyWith(
                        color: defaultColorScheme.primary,
                        fontWeight: FontWeight.bold
                    ),overflow: TextOverflow.ellipsis,maxLines: 1,),
                  ],),
              ),
              SliverToBoxAdapter(child: Column(
                spacing: 20.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(_slogan ?? 'Listen the world, listen to your heart.',
                      style: textTheme.titleMedium?.copyWith(color: defaultColorScheme.primary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const SearchPage()));
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: defaultColorScheme.onPrimaryContainer,
                          hintText: 'Search',
                          hintStyle: textTheme.bodyMedium?.copyWith(color:
                          defaultColorScheme.primary),
                          prefixIcon: const Icon(Icons.search, color: Colors.white,),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none
                          )
                      ),
                    ),
                  ),
                  if(_playListSections.isNotEmpty)_buildPlaylistSections(_playListSections),
                ],
              ),),
            ],
          );
        })
      ),
    );
  }

  Widget _buildPlaylistSections(List<PlaylistSection> playListSections){
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    if(playListSections.isNotEmpty){
      List<Widget> listItems = [];
      for(final playListSection in playListSections){
        final first = playListSection.items.firstOrNull;
        if(first?.videoId != null && first!.videoId.isNotEmpty){
          listItems.add(PaginationPage(playListSection: playListSection));
        }else if(first?.browseId != null && first!.browseId!.startsWith('MP')){
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
    return Container();

  }


  //获取音乐视频首页数据
  Future<void> _fetchHomeMusic() async {
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
      "browse_id":"FEmusic_home"
    };
    final uri = Uri.parse('$musicHost/browse?key=$musicKey&prettyPrint=false');
    final response = await http.post(uri, body: json.encode(body));

    if (response.statusCode == 200) {
      //开启异步线程
      final result = await compute(_parseData, response.body);
      final tmpVisitorData = result['visitorData'];
      visitorData = tmpVisitorData;
      final title = result['title'];
      final sections = result['sections'];
      setState(() {
        _titleText = title;
        _playListSections = sections;
      });

    }
  }
  static Map<String, dynamic> _parseData(String responseBody) {
    final result = jsonDecode(responseBody);
    String? tempVisitorData;
    final responseContext = result["responseContext"];
    if (responseContext != null) {
      tempVisitorData = responseContext["visitorData"];
    }
    List<dynamic>?tabs = parseTabs(result);
    String? nextContinuation;
    List<PlaylistSection> tempPlayListSections = [];
    final tab = tabs?.firstOrNull;
    final tabRenderer = tab?['tabRenderer'];
    final title = tabRenderer?['title'];
    List<dynamic>?contents = parseContents(tab);
    for(final content in contents ?? []){
      final itemSectionRenderer = content["itemSectionRenderer"];
      final List<dynamic>? contents_ = itemSectionRenderer["contents"];
      if(contents_ != null){
        for(final content_ in contents_){
          final model = parseModel(content_);
          if(model != null){
            PlaylistSection? playlistSection = parseMusicListItemCarouselModel(model);
            playlistSection ??= parseMusicContainerCardShelfModel(model);
            if(playlistSection != null){
              playlistSection.style = ItemType.item;
              playlistSection.allItems = playlistSection.items;
            }

            if(playlistSection != null && playlistSection.items.isNotEmpty){
              tempPlayListSections.add(playlistSection);
            }else{
              playlistSection ??= parseMusicGridItemCarouselModel(model);
              final firstItem = playlistSection?.items.firstOrNull;
              if(firstItem != null && firstItem.videoId.isNotEmpty){
                playlistSection?.style = ItemType.item;
              }else{
                playlistSection?.style = ItemType.playlist;
              }
              if(playlistSection != null){
                playlistSection.allItems = playlistSection.items;
                tempPlayListSections.add(playlistSection);
              }
            }
          }
        }
      }
    }
    List<dynamic>? continuations = parseContinuations(tab);
    nextContinuation ??= parseNextContinuation(continuations);

    return {'visitorData' : tempVisitorData, 'title' : title, 'sections':tempPlayListSections,'nextContinuation': nextContinuation };
  }
}