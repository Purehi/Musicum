import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/components/moods_and_genres_card.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:http/http.dart' as http;
import 'package:group_grid_view/group_grid_view.dart';
import 'package:you_tube_music/components/progress_with_icon.dart';

class MoodsAndGenresPage extends StatefulWidget {
  const MoodsAndGenresPage({super.key});

  @override
  State<MoodsAndGenresPage> createState() => _MoodsAndGenresPageState();
}

class _MoodsAndGenresPageState extends State<MoodsAndGenresPage> {
  final List<MoodsAndGenresSection> _moodsAndGenresSections = [];
  String? _titleText;

  @override
  void initState() {
    super.initState();
    _fetchMoodsAndGenres();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titleText ?? "", style: textTheme.headlineSmall?.copyWith(
              color: defaultColorScheme.primary),),
        ),
        body: Stack(
          children: [
            GroupGridView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  childAspectRatio: 4,
                ),
                sectionCount: _moodsAndGenresSections.length,
                headerForSection: (section) => Container(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: Text(_moodsAndGenresSections[section].title,
                        style: textTheme.headlineSmall?.copyWith(color: defaultColorScheme.primary))),
                itemInSectionBuilder: (_, indexPath) {
                  final moodsAndGenres =
                  _moodsAndGenresSections[indexPath.section].items[indexPath.index];
                  return MoodsAndGenresCard(moodsAndGenres: moodsAndGenres);
                },
                itemInSectionCount: (section) => _moodsAndGenresSections[section]
                    .items
                    .length),
            if(_moodsAndGenresSections.isEmpty) const ProgressWithIcon()
          ],
        )
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
          "visitorData": visitorData,
          'deviceModel': model
        }
      },
      "browse_id":"FEmusic_moods_and_genres",
    };
    final uri = Uri.parse('$musicHost/browse?key=$musicKey&prettyPrint=false');
    final response = await http.post(uri, body: json.encode(body));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List<dynamic>?tabs = parseTabs(result);
      List<MoodsAndGenresSection>? sections = [];
      if(tabs != null) {
        for(final tab in tabs) {
          List<dynamic>?contents = parseContents(tab);
          for(final content in contents ?? []){
            // final gridRenderer = content?['gridRenderer'];
            final section = parseMoodsAndGenresSection(content);// gridRender
            if(section != null){
              sections.add(section);
            }

          }
        }
      }
      if(sections.isNotEmpty){
        final header = result["header"];
        var musicTwoLineHeaderRenderer = header?["musicTwoLineHeaderRenderer"];
        musicTwoLineHeaderRenderer = musicTwoLineHeaderRenderer ?? header?['musicHeaderRenderer'];
        final title = musicTwoLineHeaderRenderer?["title"];
        String? titleText = parseText(title?["runs"]);
        setState(() {
          _moodsAndGenresSections.addAll(sections);
          _titleText = titleText;
        });

      }
    }
  }

}
