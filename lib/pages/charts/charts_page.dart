import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/components/carsouel_card.dart';
import 'package:you_tube_music/components/playlist_card.dart';
import 'package:you_tube_music/pages/pagination/pagination_page.dart';
import 'package:you_tube_music/pages/playlist/playlist_section_page.dart';
import '../../model/data.dart';
import '../../model/youtube_music_link_manager.dart';
import '../country_page.dart';
import '../player/song_player_page.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});
  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  String _primaryText = 'Select a country';
  final List<MusicSortFilter> _filters = [];
  MusicSortFilter? _selectedFilter;
  PlaylistSection? _topMusicSection;
  PlaylistSection? _genresMusicSection;
  PlaylistSection? _topArtistsSection;
  PlaylistSection? _trendingMusicSection;
  @override
  void initState() {
    // TODO: implement initState
    _fetchChartMusic();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final itemWidth = size.width * 0.8;
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body:  CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: defaultColorScheme.surface,
              elevation: 0,
              title: InkWell(
                onTap: (){
                  Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                      builder: (_) => CountryPage(
                        filters: _filters,
                        title: _primaryText,
                        selectedFilter: _selectedFilter,
                        onTap: (filer){
                          _topArtistsSection = null;
                          _trendingMusicSection = null;
                          _genresMusicSection = null;
                          _topMusicSection = null;
                          _selectedFilter = filer;
                          setState(() {});
                          _fetchChartMusic(country: filer.opaqueToken);
                        },
                      )));
                },
                child: Flex(direction: Axis.horizontal,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_selectedFilter?.title ?? '', style: textTheme.headlineSmall?.copyWith(
                        color: defaultColorScheme.primary,
                        fontWeight: FontWeight.bold
                    ),overflow: TextOverflow.ellipsis,maxLines: 1,),
                    Icon(Icons.arrow_drop_down_outlined,color: defaultColorScheme.primary),
                  ],),),
            ),
            if(_topMusicSection != null)
              SliverToBoxAdapter(child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(
                        bottom: 6
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(_topMusicSection!.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.headlineSmall?.copyWith(
                                color: defaultColorScheme.primary,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        if(_topMusicSection?.browseId != null)InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => PlaylistSectionPage(playlistSection: _topMusicSection!,)));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                color: defaultColorScheme.surface,
                                borderRadius: BorderRadius.all(Radius.circular(18)),
                                border: Border.all(color: defaultColorScheme.onPrimaryContainer)
                            ),
                            child: Text(_topMusicSection!.buttonText ?? 'More', style: textTheme.titleMedium?.copyWith(
                                color: defaultColorScheme.primary
                            ),),
                          ),
                        ),
                      ],),
                  ),
                  SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 12.0,
                    children: _topMusicSection!.items.asMap().map((index, musicVideo) =>
                        MapEntry(index, SizedBox(
                          width:  itemWidth,
                          child: InkWell(
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
                              child: CarsouelCard(musicVideo: musicVideo,)),
                        ))).values.toList(),
                  ),),
                ],
              ),)
            else
              SliverToBoxAdapter(child: Column(
                children: [
                  SizedBox(height: 64,),
                  CircularProgressIndicator(color: defaultColorScheme.primary,),
                ],
              ),),
            if(_topArtistsSection != null)SliverToBoxAdapter(child: PaginationPage(playListSection: _topArtistsSection!,),),
            if(_genresMusicSection != null)SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(
                      bottom: 6
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(_genresMusicSection!.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.headlineSmall?.copyWith(
                                color: defaultColorScheme.primary,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _genresMusicSection!.items.asMap().map((index, musicVideo) =>
                          MapEntry(index, PlaylistCard(musicVideo: musicVideo))).values.toList(),
                    ),),
                  SizedBox(height: 12.0,)
                ],
              ),
            ),
            if(_trendingMusicSection != null)SliverToBoxAdapter(child: PaginationPage(playListSection: _trendingMusicSection!,),)
          ],
        ),
      ),
    );
  }
  //获取音乐视频首页数据
  Future<void> _fetchChartMusic({String? country}) async {
    Map<String, dynamic> body = {
      "context": {
        "client": {
          "hl": languageCode,
          "gl": country ?? countryCode,
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
      "formData":{
        "selectedValues":[country ?? countryCode]
      },
      "browse_id":"FEmusic_charts"
    };
    final uri = Uri.parse('$musicHost/browse?key=$musicKey&prettyPrint=false');
    final response = await http.post(uri, body: json.encode(body));

    if (response.statusCode == 200) {
      final result = await compute(_parseData, response.body);
      final primaryText = result['primaryText'];
      final filters = result['filters'];
      final topMusicSection = result['topMusicSection'];
      final genresMusicSection = result['genresMusicSection'];
      final trendingMusicSection = result['trendingMusicSection'];
      final topArtistsSection = result['topArtistsSection'];
      if(_filters.isEmpty){
        _selectedFilter = filters.first;
        _filters.addAll(filters);
      }
      setState(() {
        _primaryText = primaryText ?? 'Select a country';
        _topMusicSection = topMusicSection;
        _genresMusicSection = genresMusicSection;
        _trendingMusicSection = trendingMusicSection;
        _topArtistsSection = topArtistsSection;
      });
    }
  }
  static Map<String, dynamic> _parseData(String responseBody) {
    final result = jsonDecode(responseBody);
    List<dynamic>?tabs = parseTabs(result);
    PlaylistSection? topMusicSection;
    PlaylistSection? genresMusicSection;
    PlaylistSection? trendingMusicSection;
    PlaylistSection? topArtistsSection;
    String? primaryTextString;
    final tab = tabs?.firstOrNull;
    List<dynamic>?contents = parseContents(tab);
    List<MusicSortFilter> filters = [];
    for(final content in contents ?? []) {
      final musicShelfRenderer = content["musicShelfRenderer"];
      if (musicShelfRenderer != null) {
        final List<dynamic>? subheaders = musicShelfRenderer?['subheaders'];
        final subheader = subheaders?.firstOrNull;
        final musicSideAlignedItemRenderer = subheader?['musicSideAlignedItemRenderer'];
        final List<
            dynamic>? startItems = musicSideAlignedItemRenderer?['startItems'];
        final startItem = startItems?.firstOrNull;
        final musicSortFilterButtonRenderer = startItem?['musicSortFilterButtonRenderer'];
        final menu = musicSortFilterButtonRenderer?['menu'];
        final title = menu?['title'];
        final musicMenuTitleRenderer = title?['musicMenuTitleRenderer'];
        final primaryText = musicMenuTitleRenderer?['primaryText'];
        primaryTextString ??= parseText(primaryText?['runs']);

        final musicMultiSelectMenuRenderer = menu?['musicMultiSelectMenuRenderer'];
        final List<
            dynamic>? options = musicMultiSelectMenuRenderer?['options'];
        for (final option in options ?? []) {
          final musicMultiSelectMenuItemRenderer = option?['musicMultiSelectMenuItemRenderer'];
          final title = musicMultiSelectMenuItemRenderer?['title'];
          final titleText = parseText(title?['runs']);
          final formItemEntityKey = musicMultiSelectMenuItemRenderer?['formItemEntityKey'];
          if (formItemEntityKey != null) {
            final filter = MusicSortFilter(
                id: formItemEntityKey, title: titleText ?? '');
            filters.add(filter);
          }
        }
      } else {
        final itemSectionRenderer = content?['itemSectionRenderer'];
        final List<dynamic>? tmpContents = itemSectionRenderer?['contents'];
        final tmpContent = tmpContents?.firstOrNull;
        final model = parseModel(tmpContent);
        final musicListItemCarouselModel = model?['musicListItemCarouselModel'];
        if (musicListItemCarouselModel != null) {
          final tmpHeader = musicListItemCarouselModel?['header'];
          final otherTitle = tmpHeader?['title'];
          final items = parseItems(musicListItemCarouselModel);
          final onTap = tmpHeader?['onTap'];
          final innertubeCommand = onTap?['innertubeCommand'];
          final browseEndpoint1 = innertubeCommand?['browseEndpoint'];
          final browseId1 = browseEndpoint1?['browseId'];
          if (browseId1 != null && items != null) {
            trendingMusicSection =
                PlaylistSection(title: otherTitle, items: items);
            trendingMusicSection.buttonText = topMusicSection?.buttonText;
            trendingMusicSection.browseId = browseId1;
          } else if (items != null) {
            topArtistsSection =
                PlaylistSection(title: otherTitle, items: items);
          }
        } else {
          final musicGridItemCarouselModel = model?['musicGridItemCarouselModel'];
          final shelf = musicGridItemCarouselModel?['shelf'];
          final items = parseItems(shelf);
          final header = shelf?['header'];
          final title = header?['title'];
          final onTap = header?['onTap'];
          final innertubeCommand = onTap?['innertubeCommand'];
          final browseEndpoint = innertubeCommand?['browseEndpoint'];
          final browseId = browseEndpoint?['browseId'];
          if (browseId != null && items != null) {
            topMusicSection = PlaylistSection(title: title, items: items);
            topMusicSection.browseId = browseId;
          } else if (items != null) {
            genresMusicSection = PlaylistSection(title: title, items: items);
          }
        }
      }
    }
    final frameworkUpdates = result?['frameworkUpdates'];
    final entityBatchUpdate = frameworkUpdates?['entityBatchUpdate'];
    final List<dynamic>? mutations = entityBatchUpdate?['mutations'];
    for(final mutation in mutations ?? []){
      final payload = mutation?['payload'];
      final musicFormBooleanChoice = payload?['musicFormBooleanChoice'];
      final id = musicFormBooleanChoice?['id'];
      final opaqueToken = musicFormBooleanChoice?['opaqueToken'];
      if(id != null){
        final filter = filters.firstWhereOrNull((e)=> e.id == id);
        filter?.opaqueToken = opaqueToken;
      }
    }

    return {
      'primaryText' : primaryTextString,
      'filters' : filters,
      'topMusicSection': topMusicSection,
      'genresMusicSection': genresMusicSection,
      'trendingMusicSection': trendingMusicSection,
      'topArtistsSection': topArtistsSection
    };
  }
}
