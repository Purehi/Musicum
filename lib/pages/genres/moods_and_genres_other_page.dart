import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:group_grid_view/group_grid_view.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/components/progress_with_icon.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:http/http.dart' as http;
import 'package:you_tube_music/components/playlist_other_card.dart';

class MoodsAndGenresOtherPage extends StatefulWidget {
  const MoodsAndGenresOtherPage({super.key, required this.browseId, required this.params});
  final String browseId;
  final String params;

  @override
  State<MoodsAndGenresOtherPage> createState() => _MoodsAndGenresOtherPageState();
}

class _MoodsAndGenresOtherPageState extends State<MoodsAndGenresOtherPage> {
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
          title: Text(_titleText ?? "", style: textTheme.headlineMedium?.copyWith(color: defaultColorScheme.primary),),
        ),
        body: Stack(children: [
          GroupGridView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1/1.5,
              ),
              sectionCount: _maps.length,
              headerForSection: (section) => Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(_maps[section]["title"],
                      style: textTheme.titleMedium?.copyWith(color: defaultColorScheme.primary))),
              itemInSectionBuilder: (_, indexPath) {
                final musicVideo =
                _maps[indexPath.section]["videos"][indexPath.index];
                return PlaylistOtherCard(musicVideo: musicVideo);
              },
              itemInSectionCount: (section) => _maps[section]["videos"]
                  .length),
          if(_maps.isEmpty) const ProgressWithIcon()
        ],),
      ),
    );
  }
  Future<void> _fetchMoodsAndGenres() async {
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
          'deviceModel': model
        }
      },
      "browse_id":widget.browseId,
      "params":widget.params
    };
    final uri = Uri.parse('$musicHost/browse?key=$musicKey&prettyPrint=false');
    final response = await http.post(uri, body: json.encode(body),
        headers: {"Connection":"Keep-Alive", "connection":"keep-alive"});
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
          _maps = maps;
          _titleText = titleText;
        });
      }
    }
  }

}
