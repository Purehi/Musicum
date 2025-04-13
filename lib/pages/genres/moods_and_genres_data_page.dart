import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/components/playlist_card.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:http/http.dart' as http;
import 'package:you_tube_music/components/progress_with_icon.dart';

import 'moods_and_genres_other_page.dart';


class MoodsAndGenresDataPage extends StatefulWidget {
  const MoodsAndGenresDataPage({super.key,required this.browseId,
    required this.params});
  final String browseId;
  final String params;

  @override
  State<MoodsAndGenresDataPage> createState() => _MoodsAndGenresDataPageState();
}

class _MoodsAndGenresDataPageState extends State<MoodsAndGenresDataPage> {
  String? _titleText;
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> _maps = [];

  @override
  void initState() {
    _fetchMoodsAndGenres();
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
        appBar: AppBar(
          backgroundColor: defaultColorScheme.surface,
          elevation: 0,
          leading: BackButton(
            color: defaultColorScheme.primary,
          ),
          title: Text(_titleText ?? "", style: textTheme.headlineSmall?.copyWith(color: defaultColorScheme.primary),),
        ),
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(child: _buildItem(_maps),),
              ],
            ),
            if(_maps.isEmpty) const ProgressWithIcon()
          ],
        ),
      ),
    );
  }
  Future<void> _fetchMoodsAndGenres() async {
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
          'deviceModel': model
        }
      },
      "browse_id":widget.browseId,
      "params":widget.params
    };
    final uri = Uri.parse('$musicHost/browse?key=$musicKey&prettyPrint=false');
    final response = await http.post(uri, body: json.encode(body));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List<dynamic>?tabs = parseTabs(result);
      List<Map<String, dynamic>> maps = [];

      if(tabs != null) {
        for(final tab in tabs) {
          List<dynamic>?contents = parseContents(tab);
          if(contents != null){
            for(final content in  contents){
              final tempMap = parseMoodsAndGenresMusicVideos(content);
              if(tempMap != null){
                maps.add(tempMap);
              }
            }
          }
        }
      }
      if(maps.isNotEmpty){
        final header = result["header"];
        String? titleText;
        if(header != null){
          final musicHeaderRenderer = header["musicHeaderRenderer"];
          if(musicHeaderRenderer != null){
            final title = musicHeaderRenderer["title"];
            titleText = parseText(title["runs"]);
          }
        }
        setState(() {
          _maps = maps..shuffle();
          _titleText = titleText;
        });
      }
    }
  }
  Widget? _buildItem(List<Map<String, dynamic>>? maps){
    if(maps != null){
      List<Widget> list = [];
      for(final map in maps){
        final item = _buildItems(map);
        if(item != null){
          list.add(item);
        }
      }
      if(list.isNotEmpty){
        return Column(
          children: list,
        );
      }
    }
    return null;
  }
  Widget? _buildItems(Map<String, dynamic> map){
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final List<MusicVideo>?items = map["videos"];
    if(items != null){
      return Column(
        children: [
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(map["title"] != null)Expanded(
                  child: Text(map["title"],
                    overflow: TextOverflow.ellipsis,
                    style:textTheme.headlineSmall?.copyWith (color: defaultColorScheme.primary),
                  ),
                ),
                if(map["moreText"] != null)InkWell(
                  onTap: (){
                    final browseId = map["browseId"];
                    final params = map["params"];
                    if(browseId != null && params != null){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => MoodsAndGenresOtherPage(browseId: browseId, params: params,)));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.transparent,
                        border: Border.all(width: 1, color: defaultColorScheme.surface)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                      child: Text(map["moreText"],
                        style: textTheme.titleMedium?.copyWith(color: defaultColorScheme.primary),
                      ),
                    ),
                  ),
                ),
              ],),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child: Row(
            children: items.asMap().map((index, musicVideo) =>
                MapEntry(index, PlaylistCard(musicVideo: musicVideo))).values.toList(),
          ),),
        ],
      );
    }
    return null;
  }
}
