import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/components/release_card.dart';
import '../../model/data.dart';

class ArtistsReleasePage extends StatefulWidget {
  const ArtistsReleasePage({super.key, required this.playlistSection});
  final PlaylistSection playlistSection;

  @override
  State<ArtistsReleasePage> createState() => _ArtistsReleasePageState();
}

class _ArtistsReleasePageState extends State<ArtistsReleasePage> {
  List<MusicVideo> _videos = [];
  String? _title;
  @override
  void initState() {
    super.initState();
    _fetchReleaseMusic();
    ///更改国家
    _countryCodeChangedListener();
  }
  ///更改国家
  void _countryCodeChangedListener(){
    countryCodeChanged.addListener(() async {
      if(countryCodeChanged.value == true){
        _title = null;
        _videos = [];
        setState(() {
        });
        _fetchReleaseMusic();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: defaultColorScheme.surface,
          elevation: 0,
          title: Text(
            _title ?? 'Albums & singles',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(
                color:defaultColorScheme.primary,
                fontWeight: FontWeight.bold
            ),),
          leading: BackButton(
            style: const ButtonStyle(visualDensity: VisualDensity(horizontal: -3.0, vertical: -3.0),),
            color: defaultColorScheme.primary,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal:12.0),
          child: Builder(builder: (context){
            if(_videos.isNotEmpty){
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // number of items in each row
                    mainAxisSpacing: 12.0, // spacing between rows
                    crossAxisSpacing: 12.0, // spacing between columns
                    childAspectRatio: 0.64,
                  ), // padding around the grid
                  itemCount: _videos.length,
                  itemBuilder: (context, index){
                    final video = _videos[index];
                    return ReleaseCard(musicVideo: video);
                  });
            }
            return Center(child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(strokeWidth: 2.0,)));
          }),
        ),
      ),
    );
  }
  //获取音乐视频首页数据
  Future<void> _fetchReleaseMusic() async {
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
          'deviceModel': model,
          "browserVersion": browserVersion,
          "browserName": browserName,
          'clientScreen':clientScreen,
        }
      },
      "browse_id":widget.playlistSection.browseId,
      "params": widget.playlistSection.params
    };
    final uri = Uri.parse('$musicHost/browse?key=$musicKey&prettyPrint=false');
    final response = await http.post(uri, body: json.encode(body));
    if (response.statusCode == 200) {
      //开启异步线程
      final result = await compute(_parseData, response.body);
      final videos = result['videos'];
      final title = result['title'];
      if(videos != null && videos.isNotEmpty){
        setState(() {
          _videos.addAll(videos..shuffle());
          _title = title;
        });

      }
    }
  }
  static Map<String, dynamic> _parseData(String responseBody) {
    final result = jsonDecode(responseBody);
    final header = result?['header'];
    final musicHeaderRenderer = header?['musicHeaderRenderer'];
    final title = musicHeaderRenderer?['title'];
    final titleText = parseText(title?['runs']);

    List<MusicVideo> tempVideos = [];
    final contents = result?['contents'];
    final singleColumnBrowseResultsRenderer = contents?['singleColumnBrowseResultsRenderer'];
    final List<dynamic>? tabs = singleColumnBrowseResultsRenderer?['tabs'];
    final tab = tabs?.firstOrNull;
    final tempContents = parseContents(tab);
    for(final tempContent in tempContents ?? []){
      final videos = parseNewReleaseAlbumMusicVideos(tempContent);
      if(videos != null){
        tempVideos.addAll(videos..shuffle());
      }
    }

    return {'videos' : tempVideos, 'title' : titleText };
  }
}
