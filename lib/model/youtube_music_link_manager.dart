import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'youtube_explode_dart.dart';
import 'data.dart';


final ValueNotifier<MusicVideo?> getYoutubeLinkSuccess = ValueNotifier<MusicVideo?>(null);
final ValueNotifier<MusicVideo?> getYoutubeLinkFail = ValueNotifier<MusicVideo?>(null);
final ValueNotifier<dynamic> getYoutubeNextSuccess = ValueNotifier<dynamic>(null);

final ValueNotifier<bool> scrollEndNotification = ValueNotifier<bool>(false);
final ValueNotifier<bool> scrollStartNotification = ValueNotifier<bool>(false);

class YoutubeMusicLinkManager {
  static final shared = YoutubeMusicLinkManager._();
  final Map<String, String> links = {};
  final List<String> _loadingData = [];
  final List<String> _loadingNextData = [];
  YoutubeMusicLinkManager._();
  factory YoutubeMusicLinkManager() {
    return shared;
  }
  Future<void> getYouTubeMusicURL(MusicVideo video) async{
    if(_loadingData.contains(video.videoId))return;
    _loadingData.add(video.videoId);
    if(video.videoUrl != null){
      getYoutubeLinkSuccess.value = null;
      getYoutubeLinkSuccess.value = video;
      _loadingData.remove(video.videoId);
      return;
    }else{
      final link = links[video.videoId];
      if(link != null){
        video.videoUrl = link;
        getYoutubeLinkSuccess.value = null;
        getYoutubeLinkSuccess.value = video;
        _loadingData.remove(video.videoId);
        return;
      }else{
        final map = await compute(_parseURL, video);
        final urlString = map?['videoUrl'];
        if(urlString != null){
          video.videoUrl = urlString;
          //reset
          links[video.videoId] = urlString;
          getYoutubeLinkSuccess.value = null;
          getYoutubeLinkSuccess.value = video;
        }else{
          getYoutubeLinkFail.value = null;
          getYoutubeLinkFail.value = video;
        }
        _loadingData.remove(video.videoId);
      }
    }
  }
  static Future<Map<String, String>?> _parseURL(MusicVideo video) async {
    final yt = YoutubeExplode();
    try{
      final androidManifest = await yt.videos.streams.getManifest(video.videoId,
          ytClients: [
            YoutubeApiClient.android,
          ]);
      final hlsManifestUrl = androidManifest.hlsManifestUrl;
      if(hlsManifestUrl != null){//如果有hls链接，则优先使用
        yt.close();
        return {'videoUrl': hlsManifestUrl};
      }else{
        Uri? uri;
        if(androidManifest.muxed.isNotEmpty ){
          uri = androidManifest.muxed.first.url;
        }else{
          final audioOnly = androidManifest.audioOnly;
          uri = audioOnly.firstOrNull?.url;
        }
        yt.close();
        return {'videoUrl': uri.toString()};
      }
    }catch(error){
      debugPrint('urlError======$error');
      yt.close();
      if(error is Map){
        final reason = error['reason'];
        final subReason = error['subReason'];
        return {'reason': reason, 'subReason': subReason};
      }
      return null;
    }
  }
  //获取音乐视频首页数据
  Future<void> getYouTubeMusicNext(MusicVideo musicVideo) async {
    if(_loadingNextData.contains(musicVideo.videoId))return;
    _loadingNextData.add(musicVideo.videoId);
    String playlistId = musicVideo.browseId ?? '';
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
      "videoId": musicVideo.videoId,
      "enablePersistentPlaylistPanel":true,
      "isAudioOnly":true,
      "tunerSettingValue": "AUTOMIX_SETTING_NORMAL",
      "queueContextParams":"",
      "playlistId":playlistId
    };
    final uri = Uri.parse('$musicHost/next?key=$musicKey&prettyPrint=false');
    final response = await http.post(uri, body: json.encode(body));
    if (response.statusCode == 200) {
      if(playlistId.isNotEmpty){
        //开启异步线程
        final result = await compute(_parseData, response.body);
        final List<PlaylistSection> sections = result['sections'];
        final section = sections.firstOrNull;
        if(section != null && section.items.isNotEmpty){
          getYoutubeNextSuccess.value = null;
          getYoutubeNextSuccess.value = {'videoId': musicVideo.videoId, 'sections': sections};
        }
      }else{
        final result = jsonDecode(response.body);
        final tabs = parseTabs(result);
        for(final tab in tabs ?? []){
          final tabRenderer = tab?['tabRenderer'];
          final content = tabRenderer?['content'];
          final musicQueueRenderer = content?['musicQueueRenderer'];
          final tmpContent = musicQueueRenderer?['content'];
          final playlistPanelRenderer = tmpContent?['playlistPanelRenderer'];
          final List<dynamic>? contents = playlistPanelRenderer?['contents'];
          for(final tempContent in contents ?? []){
            final automixPreviewVideoRenderer = tempContent?['automixPreviewVideoRenderer'];
            final content_ = automixPreviewVideoRenderer?['content'];
            final automixPlaylistVideoRenderer = content_?['automixPlaylistVideoRenderer'];
            final navigationEndpoint = automixPlaylistVideoRenderer?['navigationEndpoint'];
            final watchPlaylistEndpoint = navigationEndpoint?['watchPlaylistEndpoint'];
            final playlistId = watchPlaylistEndpoint?['playlistId'];
            final params = watchPlaylistEndpoint?['params'];
            musicVideo.browseId = playlistId;
            musicVideo.queueContextParams = params;
            if(playlistId != null){
              _loadingNextData.remove(musicVideo.videoId);
              getYouTubeMusicNext(musicVideo);
            }
          }
        }
      }

    }else{
      _loadingNextData.remove(musicVideo.videoId);
    }
  }
  static Map<String, dynamic> _parseData(String responseBody) {
    final result = jsonDecode(responseBody);
    final tabs = parseTabs(result);
    List<PlaylistSection> sections = [];
    for(final tab in tabs ?? []){
      final tabRenderer = tab?['tabRenderer'];
      final content = tabRenderer?['content'];
      final musicQueueRenderer = content?['musicQueueRenderer'];
      final tmpContent = musicQueueRenderer?['content'];
      final playlistPanelRenderer = tmpContent?['playlistPanelRenderer'];
      final mvs = parseNextContents(playlistPanelRenderer);
      final title = tabRenderer?['title'];
      final endpoint = tabRenderer?['endpoint'];
      final browseEndpoint = endpoint?['browseEndpoint'];
      final browseEndpointContextSupportedConfigs = browseEndpoint?['browseEndpointContextSupportedConfigs'];
      final browseId = browseEndpointContextSupportedConfigs?['browseId'];
      final section = PlaylistSection(title: title, items: mvs);
      section.browseId = browseId;
      sections.add(section);
    }

    return {'sections' : sections};
  }
}
