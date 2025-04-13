import 'package:flutter/cupertino.dart';

const String clientVersion = '20.05.35';
const String musicClientVersion = '8.04.52';
const String clientName = 'ANDROID';
const String musicClientName = "ANDROID_MUSIC";
const String musicKey = "AIzaSyAOghZGza2MQSZkY_zfZ370N-PUdXEo8AI";
const String osName = 'ANDROID';
String deviceMake = 'GOOGLE';
const String clientFormFactor = 'SMALL_FORM_FACTOR';
const String platform = "MOBILE";
String osVersion = "15";
String model = 'Pixel 9 Pro';
const String key = 'AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8';
const String host = 'https://www.youtube.com/youtubei/v1';
const String musicHost = 'https://music.youtube.com/youtubei/v1';
const String inlineSettingStatus = 'INLINE_SETTING_STATUS_ON';
const String webHost = 'https://www.youtube.com/watch?v=';
const String userAgent = "com.google.android.apps.youtube.music/";


const String webClientVersion = "2.20250205.01.00";
const String browserName = 'Chrome';
const String webClientName = 'WEB';
const String browserVersion = '132.0.0.0';
const String clientScreen = 'WATCH';

const String musicWebClientVersion = "1.20250203.01.00";
const String musicWebClientName = 'WEB_REMIX';

String visitorData = "";
String countryCode = 'US';
String languageCode = 'en';

int currentIndexKey = 0;

//visible position changed
final ValueNotifier<bool> countryCodeChanged = ValueNotifier<bool>(false);


/// 本地化语言翻译
const List<Map<String, Map<String, String>>> translateLocal = [
  {"zh":{"title":"欢迎您!", "subTitle":"聆听世界，聆听内心!"}},
  {"en":{"title":"Welcome!", "subTitle":"Listen the world, listen to your heart."}},
  {"pt":{"title":"Bem-vindo", "subTitle":"Ouça o mundo, ouça o seu coração."}},
  {"hr":{"title":"Dobrodošli", "subTitle":"Slušajte svijet, slušajte svoje srce."}},
  {"cs":{"title":"Vítejte", "subTitle":"Slušajte svijet, slušajte svoje srce."}},
  {"da":{"title":"Velkommen", "subTitle":"Lyt til verden, lyt til dit hjerte."}},
  {"de":{"title":"Willkommen", "subTitle":"Höre auf die Welt, höre auf dein Herz."}},
  {"el":{"title":"καλως ΗΡΘΑΤΕ", "subTitle":"Άκου τον κόσμο, άκου την καρδιά σου."}},
  {"et":{"title":"Tere tulemast", "subTitle":"Kuulake maailma, kuulake oma südant."}},
  {"es":{"title":"Bienvenido", "subTitle":"Escucha el mundo, escucha tu corazón."}},
  {"fi":{"title":"Tervetuloa", "subTitle":"Kuuntele maailmaa, kuuntele sydäntäsi."}},
  {"fr":{"title":"Bienvenu", "subTitle":"Écoutez le monde, écoutez votre cœur."}},
  {"ga":{"title":"Fáilte", "subTitle":"Éist leis an domhan, éist le do chroí."}},
  {"hu":{"title":"Üdvözöljük", "subTitle":"Hallgass a világra, hallgass a szívedre."}},
  {"it":{"title":"Benvenuto", "subTitle":"Ascolta il mondo, ascolta il tuo cuore."}},
  {"ja":{"title":"いらっしゃいませ", "subTitle":"世界に耳を傾け、自分の心に耳を傾けてください。"}},
  {"ko":{"title":"환영", "subTitle":"세상의 소리를 듣고, 당신의 마음에 귀를 기울이십시오."}},
  {"lv":{"title":"Laipni lūdzam", "subTitle":"Klausieties pasauli, klausieties savā sirdī."}},
  {"lt":{"title":"Welkom", "subTitle":"Luister naar de wereld, luister naar je hart."}},
  {"no":{"title":"Velkommen", "subTitle":"Lytt til verden, lytt til hjertet ditt."}},
  {"pl":{"title":"Witamy", "subTitle":"Słuchaj świata, słuchaj swojego serca."}},
  {"sv":{"title":"Välkommen", "subTitle":"Lyssna världen, lyssna på ditt hjärta."}},
  {"ro":{"title":"Bine ati venit", "subTitle":"Ascultă lumea, ascultă-ți inima."}},
  {"ru":{"title":"добро пожаловать", "subTitle":"Слушайте мир, слушайте свое сердце."}},
  {"sr":{"title":"Добродошли", "subTitle":"Слушајте свет, слушајте своје срце."}},
  {"sk":{"title":"Vitajte", "subTitle":"Počúvaj svet, počúvaj svoje srdce."}},
  {"sl":{"title":"Dobrodošli", "subTitle":"Poslušaj svet, poslušaj svoje srce."}},
  {"th":{"title":"ยินดีต้อนรับ", "subTitle":"ฟังโลก ฟังหัวใจของคุณ."}},
  {"tr":{"title":"Hoş geldin", "subTitle":"Dünyayı dinle, kalbinin sesini dinle."}},
  {"ms":{"title":"Selamat datang", "subTitle":"Dengar dunia, dengarkan hati anda."}},
  {"vi":{"title":"Chào mừng", "subTitle":"Hãy lắng nghe thế giới, lắng nghe trái tim bạn."}},
  {"uk":{"title":"Ласкаво просимо", "subTitle":"Слухай світ, слухай своє серце."}},
  {"uz":{"title":"Xush kelibsiz", "subTitle":"Dunyoni tinglang, yuragingizni tinglang."}},
  {"id":{"title":"Selamat datang", "subTitle":"Dengarkan dunia, dengarkan hatimu."}},
];

//首页音乐分类
//放松 ggM8SgQIBxADSgQIBBABSgQICRABSgQICBABSgQIDhABSgQIDRABSgQIAxABSgQIChABSgQIBhABSgQIBRAB
//健身 ggM8SgQIBxABSgQIBBADSgQICRABSgQICBABSgQIDhABSgQIDRABSgQIAxABSgQIChABSgQIBhABSgQIBRAB
//充电 ggM8SgQIBxABSgQIBBABSgQICRADSgQICBABSgQIDhABSgQIDRABSgQIAxABSgQIChABSgQIBhABSgQIBRAB
//轻松愉悦 ggM8SgQIBxABSgQIBBABSgQICRABSgQICBADSgQIDhABSgQIDRABSgQIAxABSgQIChABSgQIBhABSgQIBRAB
//派对 ggM8SgQIBxABSgQIBBABSgQICRABSgQICBABSgQIDhADSgQIDRABSgQIAxABSgQIChABSgQIBhABSgQIBRAB
//浪漫 ggM8SgQIBxABSgQIBBABSgQICRABSgQICBABSgQIDhABSgQIDRADSgQIAxABSgQIChABSgQIBhABSgQIBRAB
//通勤 ggM8SgQIBxABSgQIBBABSgQICRABSgQICBABSgQIDhABSgQIDRABSgQIAxADSgQIChABSgQIBhABSgQIBRAB
//伤心难过 ggM8SgQIBxABSgQIBBABSgQICRABSgQICBABSgQIDhABSgQIDRABSgQIAxABSgQIChADSgQIBhABSgQIBRAB
//专注 ggM8SgQIBxABSgQIBBABSgQICRABSgQICBABSgQIDhABSgQIDRABSgQIAxABSgQIChABSgQIBhADSgQIBRAB
//睡眠 ggM8SgQIBxABSgQIBBABSgQICRABSgQICBABSgQIDhABSgQIDRABSgQIAxABSgQIChABSgQIBhABSgQIBRAD

class MusicVideo {
  final String videoId;
  final String? title;
  final String? subtitle;
  String? thumbnail;
  final String? index;
  final String? iconType;
  String? browseId;
  final String? style;
  final String? musicVideoType;
  final String? avatar;
  final String? timestampText;
  final String? timestampStyle;
  String? videoUrl;
  String? queueContextParams;
  List<PlaylistSection> sections = [];

  MusicVideo({
    required this.videoId,
    this.title,
    this.subtitle,
    this.thumbnail,
    this.index,
    this.iconType,
    this.browseId,
    this.style,
    this.avatar,
    this.timestampText,
    this.timestampStyle,
    this.musicVideoType
  });
}
class Payload {
  final String id;
  final String text;
  Payload({
    required this.id,
    required this.text,
  });
}

class MoodsAndGenres{
  final String buttonText;
  final int leftStripeColor;
  final String browseId;
  final String params;
  MoodsAndGenres({
    required this.buttonText,
    required this.leftStripeColor,
    required this.browseId,
    required this.params});

  MoodsAndGenres.fromJson(Map json)
      : buttonText = json['buttonText'],
        leftStripeColor = json['leftStripeColor'],
        browseId = json['browseId'],
        params = json['params'];

        toJSONEncode() {
          Map<String, dynamic> m = {};
          m['buttonText'] = buttonText;
          m['leftStripeColor'] = leftStripeColor;
          m['browseId'] = browseId;
          m['params'] = params;
          return m;
        }
}

class MoodsAndGenresSection{
  final String title;
  final List<MoodsAndGenres> items;

  MoodsAndGenresSection({
    required this.title,
    required this.items,});

  MoodsAndGenresSection.fromJson(Map json)
      : title = json['title'],
        items = (json['items'] as List)
            .map((item) => MoodsAndGenres.fromJson(item))
            .toList();

  toJSONEncode() {
    Map<String, dynamic> m = {};
    m['title'] = title;
    m['items'] = items.map((inner) => inner.toJSONEncode()).toList();
    return m;
  }
}

class PlaylistSection{
  final String title;
  final List<MusicVideo> items;
  List<MusicVideo> allItems = [];
  ItemType? style;
  String? buttonText;
  String? browseId;
  String? params;
  PlaylistSection({
    required this.title,
    required this.items
  });
}
class MusicSortFilter{
  MusicSortFilter({
    required this.id,
    required this.title
  });
  String id;
  String title;
  String opaqueToken = 'ZZ';
}
/// Types of pages
enum ItemType {
  item,
  playlist
}
List<dynamic>? parseTabs(dynamic result){
  final contents = result?['contents'];
  final singleColumnBrowseResultsRenderer = contents?['singleColumnBrowseResultsRenderer'];
  if(singleColumnBrowseResultsRenderer != null){
    final List<dynamic>?tabs = singleColumnBrowseResultsRenderer?['tabs'];
    return tabs;
  }
  final tabbedSearchResultsRenderer = contents?["tabbedSearchResultsRenderer"];
  if(tabbedSearchResultsRenderer != null){
    final List<dynamic>?tabs = tabbedSearchResultsRenderer?['tabs'];
    return tabs;
  }
  final twoColumnBrowseResultsRenderer = contents?["twoColumnBrowseResultsRenderer"];
  if(twoColumnBrowseResultsRenderer != null){
    final List<dynamic>?tabs = twoColumnBrowseResultsRenderer?['tabs'];
    return tabs;
  }
  final singleColumnMusicWatchNextResultsRenderer = contents?['singleColumnMusicWatchNextResultsRenderer'];
  if(singleColumnMusicWatchNextResultsRenderer != null){
    final tabbedRenderer = singleColumnMusicWatchNextResultsRenderer?['tabbedRenderer'];
    final watchNextTabbedResultsRenderer = tabbedRenderer?['watchNextTabbedResultsRenderer'];
    final List<dynamic>?tabs = watchNextTabbedResultsRenderer?['tabs'];
    return tabs;
  }
  return null;

}
List<MusicVideo> parseNextContents(dynamic playlistPanelRenderer){
  final List<dynamic>? contents = playlistPanelRenderer?['contents'];
  List<MusicVideo> musicVideos = [];
  for(final content in contents ?? []){
    final mv = _parsePlaylistPanelVideoRenderer(content);
    if(mv != null){
      musicVideos.add(mv);
    }
  }
  return musicVideos;
}
MusicVideo? _parsePlaylistPanelVideoRenderer(dynamic content){
  final playlistPanelVideoRenderer = content?['playlistPanelVideoRenderer'];
  final title = playlistPanelVideoRenderer?['title'];
  final titleText = parseText(title?['runs']);
  final thumbnail = playlistPanelVideoRenderer?['thumbnail'];
  final List<dynamic>? thumbnails = thumbnail?['thumbnails'];
  final url = thumbnails?.firstOrNull?['url'];

  final shortBylineText = playlistPanelVideoRenderer?['shortBylineText'];
  final subtitle = parseText(shortBylineText?['runs']);

  final videoId = playlistPanelVideoRenderer?['videoId'];

  final navigationEndpoint = playlistPanelVideoRenderer?['navigationEndpoint'];
  final watchEndpoint = navigationEndpoint?['watchEndpoint'];
  final playlistId = watchEndpoint?['playlistId'];

  final watchEndpointMusicSupportedConfigs = watchEndpoint?['watchEndpointMusicSupportedConfigs'];
  final watchEndpointMusicConfig = watchEndpointMusicSupportedConfigs?['watchEndpointMusicConfig'];
  final musicVideoType = watchEndpointMusicConfig?['musicVideoType'];

  final lengthText = playlistPanelVideoRenderer?["lengthText"];
  final length = parseText(lengthText?['runs']);


  if(videoId != null){
    final video = MusicVideo(
        videoId: videoId,
        title: titleText ?? '',
        thumbnail: url,
        subtitle: subtitle ?? '',
        timestampText:length ?? '',
        browseId: playlistId,
        musicVideoType: musicVideoType
    );
    return video;
  }
  return null;
}

List<dynamic>? parseContents(dynamic tab){
  final tabRenderer = tab?['tabRenderer'];
  if(tabRenderer != null){
    final content = tabRenderer?['content'];
    if(content != null){
      final richGridRenderer = content?['richGridRenderer'];
      if(richGridRenderer != null){
        final List<dynamic>? contents = richGridRenderer?["contents"];
        return contents;
      }else{
        final sectionListRenderer = content?['sectionListRenderer'];
        final List<dynamic>? contents = sectionListRenderer?["contents"];
        return contents;
      }
    }
  }
  return null;
}
List<dynamic>? parseContinuations(dynamic tab){
  final tabRenderer = tab['tabRenderer'];
  if(tabRenderer != null){
    final content = tabRenderer['content'];
    if(content != null){
      final sectionListRenderer = content['sectionListRenderer'];
      if(sectionListRenderer != null){
        final List<dynamic>? continuations = sectionListRenderer["continuations"];
        return continuations;
      }
    }
  }
  return null;
}
String? _parseText(List<dynamic>? runs){
  if(runs != null){
    String text = "";
    for (final run in runs){
      final innerText = run["text"];
      text += innerText ?? "";
    }
    return text;
  }else{
    return null;
  }

}
String? parseText(List<dynamic>? runs){
  if(runs != null){
    String text = "";
    for (final run in runs){
      final innerText = run["text"];
      text += innerText ?? "";
    }
    return text;
  }else{
    return null;
  }

}
Map<String,dynamic>? _parseCustomIndexColumn(dynamic musicTwoRowItemRenderer){
  final customIndexColumn = musicTwoRowItemRenderer["customIndexColumn"];
  if(customIndexColumn != null){
    final musicCustomIndexColumnRenderer = customIndexColumn["musicCustomIndexColumnRenderer"];
    if(musicCustomIndexColumnRenderer != null){
      final icon = musicCustomIndexColumnRenderer["icon"];
      final iconType = icon?["iconType"];

      final text = musicCustomIndexColumnRenderer["text"];
      final index = _parseText(text["runs"]);
      return {"index":index, "iconType":iconType};
    }
  }
  return null;
}
String? _parseVideoId(dynamic musicTwoRowItemRenderer){
  final navigationEndpoint = musicTwoRowItemRenderer["navigationEndpoint"];
  if(navigationEndpoint != null){
    final watchEndpoint = navigationEndpoint["watchEndpoint"];
    if(watchEndpoint != null){
      final videoId = watchEndpoint["videoId"];
      return videoId;
    }
  }
  return null;
}
String? _parseBrowseId(dynamic musicTwoRowItemRenderer){
  final navigationEndpoint = musicTwoRowItemRenderer?["navigationEndpoint"];
  final browseEndpoint = navigationEndpoint?["browseEndpoint"];
  final browseId = browseEndpoint?["browseId"];
  return browseId;
}
MusicVideo? _parseMusicTwoRowItemRenderer(dynamic content){
  dynamic musicTwoRowItemRenderer = content["musicTwoRowItemRenderer"];
  musicTwoRowItemRenderer ??= content['musicTwoColumnItemRenderer'];
  if(musicTwoRowItemRenderer != null){
    final thumbnail = _parseThumbnailRenderer(musicTwoRowItemRenderer);

    final title = musicTwoRowItemRenderer["title"];
    final titleText = _parseText(title["runs"]);

    final subtitle = musicTwoRowItemRenderer["subtitle"];
    final subtitleText = _parseText(subtitle["runs"]);

    final customIndexColumn = _parseCustomIndexColumn(musicTwoRowItemRenderer);
    final index = customIndexColumn?["index"];
    final iconType = customIndexColumn?["iconType"];

    final videoId = _parseVideoId(musicTwoRowItemRenderer);
    final browseId = _parseBrowseId(musicTwoRowItemRenderer);

    final mv = MusicVideo(
        videoId: videoId ?? "",
        title: titleText ?? "",
        subtitle: subtitleText ?? "",
        thumbnail: thumbnail ?? "",
        index: index,
        iconType: iconType,
        browseId: browseId
    );
    return mv;

  }
  return null;
}
MusicVideo? _parseMusicTwoColumnItemRenderer(dynamic content){
  final musicTwoColumnItemRenderer = content["musicTwoColumnItemRenderer"];
  if(musicTwoColumnItemRenderer != null){
    final thumbnail = _parseThumbnailRenderer(musicTwoColumnItemRenderer);

    final title = musicTwoColumnItemRenderer["title"];
    final titleText = _parseText(title["runs"]);

    final subtitle = musicTwoColumnItemRenderer["subtitle"];
    final subtitleText = _parseText(subtitle["runs"]);

    final customIndexColumn = _parseCustomIndexColumn(musicTwoColumnItemRenderer);
    final index = customIndexColumn?["index"];
    final iconType = customIndexColumn?["iconType"];

    final videoId = _parseVideoId(musicTwoColumnItemRenderer);
    final navigationEndpoint = musicTwoColumnItemRenderer["navigationEndpoint"];
    final browseEndpoint = navigationEndpoint?['browseEndpoint'];
    final browseId = browseEndpoint?['browseId'];
    final mv = MusicVideo(
      videoId: videoId ?? "",
      title: titleText ?? "",
      subtitle: subtitleText ?? "",
      thumbnail: thumbnail ?? "",
      index: index,
      iconType: iconType,
      browseId: browseId
    );
    return mv;

  }
  return null;
}
String? _parseThumbnailRenderer(dynamic musicTwoRowItemRenderer){
  dynamic thumbnailRenderer;
   thumbnailRenderer = musicTwoRowItemRenderer["thumbnailRenderer"];
  if(thumbnailRenderer == null){
    final thumbnail = musicTwoRowItemRenderer["thumbnail"];
    if(thumbnail != null){
      thumbnailRenderer = thumbnail;
    }
  }
  if(thumbnailRenderer != null){
    final musicThumbnailRenderer = thumbnailRenderer["musicThumbnailRenderer"];
    if(musicThumbnailRenderer != null){
      final thumbnail = _parseThumbnail(musicThumbnailRenderer);
      return thumbnail;
    }
  }
  return null;
}
String? _parseThumbnail(dynamic thumbnailRenderer){
  final thumbnail = thumbnailRenderer["thumbnail"];
  if(thumbnail != null){
    List<dynamic>?thumbnails = thumbnail["thumbnails"];
    if(thumbnails != null && thumbnails.lastOrNull != null){
      final url = thumbnails.lastOrNull["url"];
      return url;
    }else{
      final image = thumbnail["image"];
      if(image != null){
        List<dynamic>?sources = image["sources"];
        if(sources != null && sources.lastOrNull != null){
          final url = sources.lastOrNull["url"];
          return url;
        }
      }
    }
  }
  return null;
}
Map<String, dynamic>? parseTopMusicVideos(dynamic content){
  String? titleText;
  String? moreText;
  String? browseId;
  final musicCarouselShelfRenderer = content['musicCarouselShelfRenderer'];
  if(musicCarouselShelfRenderer != null){
    final header = musicCarouselShelfRenderer["header"];
    if(header != null){
      final musicCarouselShelfBasicHeaderRenderer = header["musicCarouselShelfBasicHeaderRenderer"];
      if(musicCarouselShelfBasicHeaderRenderer != null){
        final navigationEndpoint = musicCarouselShelfBasicHeaderRenderer["navigationEndpoint"];
        if(navigationEndpoint != null){
          final title = musicCarouselShelfBasicHeaderRenderer["title"];
          if(title != null){
            titleText = _parseText(title["runs"]);
          }
          final browseEndpoint = navigationEndpoint["browseEndpoint"];
          if(browseEndpoint != null){
             browseId = browseEndpoint["browseId"];
          }
          final moreContentButton = musicCarouselShelfBasicHeaderRenderer["moreContentButton"];
          if(moreContentButton != null){
            final buttonRenderer = moreContentButton["buttonRenderer"];
            if(buttonRenderer != null){
              final text = buttonRenderer["text"];
              if(text != null){
                moreText = _parseText(text["runs"]);
              }
            }
          }

          final videos = parseMusicVideos(musicCarouselShelfRenderer);
          return {"title":titleText,"moreText":moreText,"videos":videos,"browseId":browseId};
        }
      }
    }
  }
  return null;
}
List<MusicVideo>? parseMusicVideos(dynamic musicPlaylistShelfRenderer){
  if(musicPlaylistShelfRenderer == null)return null;
  final List<MusicVideo> videos = [];
  final List<dynamic>? contents = musicPlaylistShelfRenderer["contents"];
  if(contents != null){
    for (final content in contents){
      final mv = _parseMusicTwoRowItemRenderer(content);
      if(mv != null){
        videos.add(mv);
      }
    }
    if(videos.isNotEmpty){
      return videos;
    }
  }
  return null;
}
List<MusicVideo>? parseArtistsSongs(dynamic musicShelfRenderer){
  if(musicShelfRenderer == null)return null;
  final List<MusicVideo> videos = [];
  final List<dynamic>? contents = musicShelfRenderer["contents"];
  if(contents != null){
    for (final content in contents){
      final mv = _parseMusicResponsiveListItemRenderer(content);
      if(mv != null){
        videos.add(mv);
      }
    }
    if(videos.isNotEmpty){
      return videos;
    }
  }
  return null;
}
MusicVideo? _parseMusicResponsiveListItemRenderer(dynamic content){
  final musicResponsiveListItemRenderer = content?["musicResponsiveListItemRenderer"];
  final playlistItemData = musicResponsiveListItemRenderer?['playlistItemData'];
  final videoId = playlistItemData?['videoId'];
  final thumbnail = musicResponsiveListItemRenderer?['thumbnail'];
  final musicThumbnailRenderer = thumbnail?['musicThumbnailRenderer'];
  final url = parseThumbnail(musicThumbnailRenderer);
  final List<dynamic>? flexColumns = musicResponsiveListItemRenderer?['flexColumns'];
  final flexColumn = flexColumns?.firstOrNull;
  final musicResponsiveListItemFlexColumnRenderer = flexColumn?['musicResponsiveListItemFlexColumnRenderer'];
  final text = musicResponsiveListItemFlexColumnRenderer?['text'];
  final title = parseText(text?['runs']);
  String subTitle = '';
  for(final flexColumn in flexColumns ?? []){
    final musicResponsiveListItemFlexColumnRenderer = flexColumn?['musicResponsiveListItemFlexColumnRenderer'];
    final text = musicResponsiveListItemFlexColumnRenderer?['text'];
    final titleText = parseText(text?['runs']);
    if(titleText != title){
      subTitle += titleText ?? '';
      subTitle += ' · ';
    }
  }
  subTitle += title ?? '';
  final customIndexColumn = musicResponsiveListItemRenderer?['customIndexColumn'];
  final musicCustomIndexColumnRenderer = customIndexColumn?['musicCustomIndexColumnRenderer'];
  final icon = musicCustomIndexColumnRenderer?['icon'];
  final iconType = icon?['iconType'];
  final indexText = musicCustomIndexColumnRenderer?['text'];
  final index = parseText(indexText?['runs']);

  final navigationEndpoint = musicResponsiveListItemRenderer?['navigationEndpoint'];
  final browseEndpoint = navigationEndpoint?['browseEndpoint'];
  final browseId = browseEndpoint?['browseId'];
  if(videoId != null || browseId != null){
    final mv = MusicVideo(
        videoId: videoId ?? '',
        thumbnail: url,
        title: title,
        subtitle: subTitle,
        index: index,
        iconType: iconType,
        browseId: browseId
    );
    return mv;
  }

  return null;
}
Map<String, dynamic>? parseModel(dynamic content){
  final elementRenderer = content?["elementRenderer"];
  final newElement = elementRenderer?["newElement"];
  final type = newElement?["type"];
  final componentType = type?["componentType"];
  final model = componentType?["model"];
  return model;
}
String? parsePlaylistHeader(dynamic result){
  final header = result?["header"];
  final playlistHeaderRenderer = header?["playlistHeaderRenderer"];
  final title = playlistHeaderRenderer?["title"];
  final text = _parseText(title?["runs"]);
  return text;
}
MusicVideo? parsePlaylistVideoRenderer(dynamic content){
  final playlistVideoRenderer = content["playlistVideoRenderer"];
  if(playlistVideoRenderer != null){
    final videoId = playlistVideoRenderer["videoId"];
    final thumbnail = _parseThumbnail(playlistVideoRenderer);
    String? titleText;
    String? indexText;
    String? shortByline;
    String? length;

    final title = playlistVideoRenderer["title"];
    if(title != null){
      titleText = _parseText(title["runs"]);
    }
    final index = playlistVideoRenderer["index"];
    if(index != null){
      indexText = _parseText(index["runs"]);
    }
    final shortBylineText = playlistVideoRenderer["shortBylineText"];
    if(shortBylineText != null){
      shortByline = _parseText(shortBylineText["runs"]);
    }

    final lengthText = playlistVideoRenderer["lengthText"];
    if(lengthText != null){
      length = _parseText(lengthText["runs"]);
    }
    final subtitle = "${shortByline ?? ""} · ${length ?? ""}";

    final mv =  MusicVideo(
        videoId: videoId,
        title: titleText ?? "",
        subtitle: subtitle,
        thumbnail: thumbnail ?? "",
        index: indexText,
        iconType: null,
        browseId: null);
    return mv;

  }
  return null;
}
MusicVideo? parseAlbumVideoRenderer(dynamic content){
  final model = parseModel(content);
  final musicListItemWrapperModel = model?['musicListItemWrapperModel'];
  final musicListItemData = musicListItemWrapperModel?['musicListItemData'];
  final title = musicListItemData?['title'];
  final subtitle = musicListItemData?['subtitle'];
  final onTap = musicListItemData?['onTap'];
  final innertubeCommand = onTap?['innertubeCommand'];
  final watchEndpoint = innertubeCommand?['watchEndpoint'];
  final browseEndpoint = innertubeCommand?['browseEndpoint'];
  final browseId = browseEndpoint?['browseId'];
  final videoId = watchEndpoint?['videoId'];
  final style = musicListItemData?['style'];
  final indexText = musicListItemData?['indexText'];
  final mv = MusicVideo(
      videoId: videoId ?? '',
      title: title,
      subtitle: subtitle,
      style: style,
      index: indexText,
      browseId: browseId);
  return mv;
}
Map<String, dynamic>? parseTrendingMusicVideos(dynamic content){
  final itemSectionRenderer = content['itemSectionRenderer'];
  if(itemSectionRenderer != null){
    final List<dynamic>? contents = itemSectionRenderer['contents'];
    if(contents != null){
      for(final content in contents){
        final model = parseModel(content);
        final musicListItemCarouselModel = model?['musicListItemCarouselModel'];
        final header = musicListItemCarouselModel?['header'];
        final title = header?['title'];

        final endButton = header?['endButton'];
        if(endButton != null){
          final videos = parseItems(musicListItemCarouselModel);
          return {"title":title,"videos":videos};
        }
      }
    }
    return null;
  }
  return null;
}
List<MusicVideo>?parseItems(dynamic musicListItemCarouselModel){
  if(musicListItemCarouselModel == null) return null;
  final List<MusicVideo> videos = [];
  final List<dynamic>? items = musicListItemCarouselModel['items'];
  for(final item in items ?? []){
    final mv = parseItem(item);
    if(mv != null){
      videos.add(mv);
    }
  }
  if(videos.isNotEmpty){
    return videos;
  }
  return null;
}
MusicVideo? parseItem(dynamic item){
  if(item == null)return null;
  final thumbnail = item['thumbnail'];
  final image = thumbnail?['image'];
  final List<dynamic>? sources = image['sources'];
  String? imageUrl = sources?.firstOrNull['url'];
  final title = item['title'];
  final subtitle = item['subtitle'];

  final onTap = item['onTap'];
  final innertubeCommand = onTap?['innertubeCommand'];
  final watchEndpoint = innertubeCommand?['watchEndpoint'];

  final videoId = watchEndpoint?['videoId'];
  final playlistId = watchEndpoint?['playlistId"'];

  final thumbnailRankedItemText = item['thumbnailRankedItemText'];
  final rankingBadgeData = item['rankingBadgeData'];
  final text = rankingBadgeData?['text'];
  final iconName = rankingBadgeData?['iconName'];//arrow_drop_up,arrow_drop_down,chart_neutral

  if(videoId != null){
    final mv = MusicVideo(
        videoId: videoId,
        title: title,
        subtitle: subtitle,
        thumbnail: imageUrl,
        browseId: playlistId,
        index: thumbnailRankedItemText ?? text,
        iconType: iconName
    );
    return mv;
  }else{
    final nowPlayingItem = item['nowPlayingItem'];
    final tempPlaylistId = nowPlayingItem?['playlistId'];
    if(tempPlaylistId != null){
      final mv = MusicVideo(
          videoId: videoId ?? '',
          title: title,
          subtitle: subtitle,
          thumbnail: imageUrl,
          browseId: tempPlaylistId,
          index: thumbnailRankedItemText ?? text,
          iconType: iconName
      );
      return mv;
    }else{
      final browseEndpoint = innertubeCommand?['browseEndpoint'];
      final browseId = browseEndpoint?['browseId'];
      if(browseId != null){
        final mv = MusicVideo(
            videoId: videoId ?? '',
            title: title,
            subtitle: subtitle,
            thumbnail: imageUrl,
            browseId: browseId,
            index: thumbnailRankedItemText ?? text,
            iconType: iconName
        );
        return mv;
      }
    }
  }

  return null;
}
List<MusicVideo>? parsePlaylistMusicVideos(dynamic content){
  final playlistVideoListRenderer = content['playlistVideoListRenderer'];
  if(playlistVideoListRenderer != null){
    final List<dynamic>? contents = playlistVideoListRenderer['contents'];
    if(contents != null){
      List<MusicVideo> tempVideos = [];
      for(final content in contents){
        final video = parsePlaylistVideoRenderer(content);
        if(video != null){
          tempVideos.add(video);
        }
      }
      if(tempVideos.isNotEmpty){
        return tempVideos;
      }
    }
    return null;
  }
  return null;
}
List<MusicVideo>? parseAlbumMusicVideos(dynamic content){
  final itemSectionRenderer = content['itemSectionRenderer'];
  final List<dynamic>? contents = itemSectionRenderer?['contents'];
  if(contents != null){
    List<MusicVideo> tempVideos = [];
    for(final content in contents){
      final video = parseAlbumVideoRenderer(content);
      if(video != null){
        tempVideos.add(video);
      }
    }
    if(tempVideos.isNotEmpty){
      return tempVideos;
    }
  }
  return null;
}
List<MusicVideo>? parseNewReleaseAlbumMusicVideos(dynamic content){
  final gridRenderer = content['gridRenderer'];
  final List<dynamic>? items = gridRenderer?['items'];
  List<MusicVideo> tempVideos = [];
  for(final item in items ?? []){
    final video = _parseMusicTwoRowItemRenderer(item);
    if(video != null){
      tempVideos.add(video);
    }
  }
  if(tempVideos.isNotEmpty){
    return tempVideos;
  }
  return null;
}
List<MusicVideo>? parsePlaylistContinuationVideos(dynamic content){
  final List<MusicVideo> videos = [];
  final playlistVideoListContinuation = content['playlistVideoListContinuation'];
  if(playlistVideoListContinuation != null){
    final List<dynamic>? contents = playlistVideoListContinuation["contents"];
    if(contents != null){
      for(final content in contents){
        final mv = parsePlaylistVideoRenderer(content);
        if(mv != null){
          videos.add(mv);
        }
      }
    }
    return videos;
  }
  return null;
}
String? parseNextContinuation(List<dynamic>?continuations){
  if(continuations != null){
    for(final continuation in continuations){
      final nextContinuationData = continuation["nextContinuationData"];
      if(nextContinuationData != null){
        final continuation = nextContinuationData["continuation"];
        return continuation;
      }
    }
  }
  return null;
}
List<MusicVideo>? parseMoreMusicVideos(dynamic musicPlaylistShelfRenderer){
  final List<MusicVideo> videos = [];
  final List<dynamic>?contents = musicPlaylistShelfRenderer["contents"];
  if(contents != null){
    for(final content in contents){
      final mv = _parseMusicTwoColumnItemRenderer(content);
      if(mv != null){
        videos.add(mv);
      }
    }
    return videos;
  }
  return null;
}
MusicVideo? _parseCarouselItem(dynamic content){
  final defaultPromoPanelRenderer = content["defaultPromoPanelRenderer"];
  String? titleText;
  String? descriptionText;
  String? thumbnail;
  if(defaultPromoPanelRenderer != null){
    final title = defaultPromoPanelRenderer["title"];
    if(title != null){
       titleText = _parseText(title["runs"]);
    }
    final description = defaultPromoPanelRenderer["description"];
    if(description != null){
       descriptionText = _parseText(description["runs"]);
    }
    final videoId = _parseVideoId(defaultPromoPanelRenderer);
    final smallFormFactorBackgroundThumbnail = defaultPromoPanelRenderer["smallFormFactorBackgroundThumbnail"];
    if(smallFormFactorBackgroundThumbnail != null){
      final thumbnailLandscapePortraitRenderer = smallFormFactorBackgroundThumbnail["thumbnailLandscapePortraitRenderer"];
      if(thumbnailLandscapePortraitRenderer != null){
        final landscape = thumbnailLandscapePortraitRenderer["landscape"];
        if(landscape != null){
          List<dynamic>? thumbnails = landscape["thumbnails"];
          if(thumbnails != null && thumbnails.lastOrNull != null){
            thumbnail = thumbnails.last["url"];
          }
        }
      }
    }
    if(videoId != null){
      final mv = MusicVideo(videoId: videoId,
          title: titleText ?? "",
          subtitle: descriptionText ?? "",
          thumbnail: thumbnail ?? "",
          index: null,
          iconType: null,
          browseId: null);
      return mv;
    }

  }
  return null;
}
List<MusicVideo>? _parseCarouselItems(dynamic content){
  final List<MusicVideo> carouselVideos = [];
  final carouselItemRenderer = content["carouselItemRenderer"];
  if(carouselItemRenderer != null){
    final List<dynamic>?carouselItems = carouselItemRenderer["carouselItems"];
    if(carouselItems != null){
      for(final carouselItem in carouselItems){
        final mv = _parseCarouselItem(carouselItem);
        if(mv != null){
          carouselVideos.add(mv);
        }
      }
      if(carouselVideos.isNotEmpty){
        return carouselVideos;
      }
      return null;
    }
  }

  return null;
}
String? _parsePlaylistThumbnail(dynamic thumbnailRenderer){
  final thumbnail = thumbnailRenderer["thumbnail"];
  if(thumbnail != null){
    List<dynamic>?thumbnails = thumbnail["thumbnails"];
    if(thumbnails != null && thumbnails.firstOrNull != null){
      final url = thumbnails.firstOrNull["url"];
      return url;
    }else{
      final image = thumbnail["image"];
      if(image != null){
        List<dynamic>?sources = image["sources"];
        if(sources != null && sources.firstOrNull != null){
          final url = sources.firstOrNull["url"];
          return url;
        }
      }
    }
  }
  return null;
}
MusicVideo? _parseTopChartPlaylistItem(dynamic item){
  final model = parseModel(item);
  if(model != null){
    final gridVideoModel = model["gridVideoModel"];
    String? titleText;
    String? thumbnail;
    String? videoCountText;
    if(gridVideoModel != null){
      final onTap = gridVideoModel["onTap"];
      if(onTap != null){
        final innertubeCommand = onTap["innertubeCommand"];
        if(innertubeCommand != null){
          final browseEndpoint = innertubeCommand["browseEndpoint"];
          if(browseEndpoint != null){
            final browseId = browseEndpoint["browseId"];
            final videoData = gridVideoModel["videoData"];
            if(videoData != null){
              thumbnail = _parsePlaylistThumbnail(videoData);
              final metadata = videoData["metadata"];
              if(metadata != null){
                titleText = metadata["title"];
                videoCountText = metadata["metadataDetails"];
              }
            }
            if(browseId != null){
              final mv = MusicVideo(
                  videoId: "",
                  title: titleText ?? "",
                  subtitle: videoCountText ?? "",
                  thumbnail: thumbnail ?? "",
                  index: null,
                  iconType: null,
                  browseId: browseId);
              return mv;
            }
          }
        }
      }
    }
  }

  return null;
}
MusicVideo? _parsePlaylistItem(dynamic item){
  final compactStationRenderer = item["compactStationRenderer"];
  String? titleText;
  // String? descriptionText;
  String? videoCountText;
  if(compactStationRenderer != null){
    final title = compactStationRenderer["title"];
    if(title != null){
      titleText = _parseText(title["runs"]);
    }
    // final description = compactStationRenderer["description"];
    // if(description != null){
    //   descriptionText = _parseText(description["runs"]);
    // }

    final videoCount = compactStationRenderer["videoCountText"];
    if(videoCount != null){
      videoCountText = _parseText(videoCount["runs"]);
    }
    final browseId = _parseBrowseId(compactStationRenderer);
    final thumbnail = _parsePlaylistThumbnail(compactStationRenderer);
    if(browseId != null){
      final mv = MusicVideo(
          videoId: "",
          title: titleText ?? "",
          subtitle: videoCountText ?? "",
          thumbnail: thumbnail ?? "",
          index: null,
          iconType: null,
          browseId: browseId);
      return mv;
    }
  }
  return null;
}
PlaylistSection? _parseShelfRenderer(dynamic content){
  final shelfRenderer = content["shelfRenderer"];
  if(shelfRenderer != null){
    final content_ = shelfRenderer["content"];
    final title = shelfRenderer["title"];
    String? headerText;
    if(title != null){
       headerText = _parseText(title["runs"]);
    }
    if(content_ != null){

      final horizontalListRenderer = content_["horizontalListRenderer"];
      if(horizontalListRenderer != null){
        final List<dynamic>?items = horizontalListRenderer["items"];
        if(items != null){
          List<MusicVideo> playlistItems = [];
          for(final item in items){
             MusicVideo? pid = _parsePlaylistItem(item);
             pid ??= _parseTopChartPlaylistItem(item);
            if(pid != null){
              playlistItems.add(pid);
            }
          }
          final section = PlaylistSection(title: headerText ?? "", items: playlistItems);
          return section;
        }
      }
    }
  }

  return null;
}
PlaylistSection? parseMusicPlaylistSections(dynamic content){
  final section = _parseShelfRenderer(content);
  return section;
}
List<MusicVideo>? parseMusicCarouselItems(dynamic content){
  final List<MusicVideo> videos = [];
  final itemSectionRenderer = content["itemSectionRenderer"];
  if(itemSectionRenderer != null){
    List<dynamic>? contents = itemSectionRenderer["contents"];
    if(contents != null){
      for(final content in  contents){
        final videosList = _parseCarouselItems(content);
        if(videosList != null){
          videos.addAll(videosList);
        }
      }
    }
  }
  if(videos.isNotEmpty){
    return videos;
  }
  return null;
}
List<String> parseSearchSuggestions(dynamic result){
  final List<String> suggestions = [];
  final List<dynamic>?contents = result?["contents"];
  for(final content in contents ?? []){
    final searchSuggestionsSectionRenderer = content?["searchSuggestionsSectionRenderer"];
    final List<dynamic>? contents_ = searchSuggestionsSectionRenderer?["contents"];
    for(final content_ in contents_ ?? []){
      final searchSuggestionRenderer = content_?["searchSuggestionRenderer"];
      final navigationEndpoint = searchSuggestionRenderer?["navigationEndpoint"];
      final searchEndpoint = navigationEndpoint?["searchEndpoint"];
      final query = searchEndpoint?["query"];
      if(query != null){
        suggestions.add(query);
      }
    }
  }
  return suggestions;
}
String? _parseMusicVideoType(dynamic content){
  dynamic musicTwoRowItemRenderer;
  musicTwoRowItemRenderer = content["musicTwoRowItemRenderer"];
  musicTwoRowItemRenderer ??= content["musicTwoColumnItemRenderer"];
  if(musicTwoRowItemRenderer != null){
    final navigationEndpoint = musicTwoRowItemRenderer["navigationEndpoint"];
    if(navigationEndpoint != null){
      final watchEndpoint = navigationEndpoint["watchEndpoint"];
      if(watchEndpoint != null){
        final watchEndpointMusicSupportedConfigs = watchEndpoint["watchEndpointMusicSupportedConfigs"];
        if(watchEndpointMusicSupportedConfigs != null){
          final watchEndpointMusicConfig = watchEndpointMusicSupportedConfigs["watchEndpointMusicConfig"];
          if(watchEndpointMusicConfig != null){
            final musicVideoType = watchEndpointMusicConfig["musicVideoType"];
            return musicVideoType;
          }
        }
      }else{
        final browseEndpoint = navigationEndpoint["browseEndpoint"];
        if(browseEndpoint != null){
          final browseEndpointContextSupportedConfigs = browseEndpoint["browseEndpointContextSupportedConfigs"];
          if(browseEndpointContextSupportedConfigs != null){
            final browseEndpointContextMusicConfig = browseEndpointContextSupportedConfigs["browseEndpointContextMusicConfig"];
            if(browseEndpointContextMusicConfig != null){
              final pageType = browseEndpointContextMusicConfig["pageType"];
              return pageType;
            }
          }
        }
      }
    }
  }
  return null;
}
Map<String, dynamic>? parseSearchMusicCardShelfRenderer(dynamic content){
  final List<MusicVideo> videos = [];
  final musicCardShelfRenderer = content["musicCardShelfRenderer"];
  if(musicCardShelfRenderer != null){
    String? musicVideoType;
    String? thumbnailUrl;
    String? titleText;
    String? subtitleText;
    final thumbnail = musicCardShelfRenderer["thumbnail"];
    if(thumbnail != null){
       thumbnailUrl = _parseThumbnailRenderer(thumbnail);
    }
    final title = musicCardShelfRenderer["title"];
    if(title != null){
       titleText = _parseText(title["runs"]);
    }
    final subtitle = musicCardShelfRenderer["subtitle"];
    if(subtitle != null){
       subtitleText = _parseText(subtitle["runs"]);
    }
    List<dynamic>? contents = musicCardShelfRenderer["contents"];
    MusicVideo? mv;
    for(final content in contents ?? []){
      mv = _parseMusicTwoRowItemRenderer(content);
      mv ??= _parseMusicTwoColumnItemRenderer(content);
      if(mv != null){
        videos.add(mv);
        musicVideoType ??= _parseMusicVideoType(content);
      }
    }

    return {
      "musicVideoType":musicVideoType,
      "title":titleText,
      "subtitle":subtitleText,
      "thumbnail":thumbnailUrl,
      "videos":videos
    };
  }
  return null;
}
PlaylistSection? parseSearchMusicShelfRenderer(dynamic content){
  final List<MusicVideo> videos = [];
  final musicShelfRenderer = content["musicShelfRenderer"];
  if(musicShelfRenderer != null){
    String? titleText;

    final title = musicShelfRenderer["title"];
    if(title != null){
      titleText = _parseText(title["runs"]);
    }
    final moreContentButton = musicShelfRenderer['moreContentButton'];
    final buttonRenderer = moreContentButton?['buttonRenderer'];
    final text = buttonRenderer?['text'];
    final textTitle = parseText(text?['runs']);
    final navigationEndpoint = buttonRenderer?['navigationEndpoint'];
    final searchEndpoint = navigationEndpoint?['searchEndpoint'];
    final params = searchEndpoint?['params'];
    final query = searchEndpoint?['query'];

    List<dynamic>? contents = musicShelfRenderer["contents"];
    for(final content in contents ?? []){
      final mv = _parseMusicTwoColumnItemRenderer(content);
      if(mv != null){
        videos.add(mv);
      }
    }
    if(videos.isNotEmpty){
      final section = PlaylistSection(title: titleText ?? '', items: videos);
      section.browseId = params;
      section.params = query;
      section.buttonText = textTitle;
      return section;
    }
  }
  return null;
}
PlaylistSection? parseWebSearchMusicShelfRenderer(dynamic content){
  final List<MusicVideo> videos = [];
  final musicShelfRenderer = content["musicShelfRenderer"];
  if(musicShelfRenderer != null){
    String? titleText;

    final title = musicShelfRenderer["title"];
    if(title != null){
      titleText = _parseText(title["runs"]);
    }
    final bottomEndpoint = musicShelfRenderer?['bottomEndpoint'];
    final searchEndpoint = bottomEndpoint?['searchEndpoint'];
    final params = searchEndpoint?['params'];
    final query = searchEndpoint?['query'];

    final bottomText = musicShelfRenderer?['bottomText'];
    final bottom = parseText(bottomText?['runs']);

    List<dynamic>? contents = musicShelfRenderer["contents"];
    for(final content in contents ?? []){
      final mv = _parseMusicResponsiveListItemRenderer(content);
      if(mv != null){
        videos.add(mv);
      }
    }
    if(videos.isNotEmpty){
      final section = PlaylistSection(title: titleText ?? '', items: videos);
      section.browseId = params;
      section.params = query;
      section.buttonText = bottom;
      return section;
    }
  }
  return null;
}
List<MusicVideo>? parseSearchMusicVideos(dynamic content){
  final List<MusicVideo> videos = [];
  final musicShelfRenderer = content["musicShelfRenderer"];
  if(musicShelfRenderer != null){
    final List<dynamic>?contents = musicShelfRenderer["contents"];
    if(contents != null){
      for(final content in contents){
        final mv = _parseMusicTwoColumnItemRenderer(content);
        if(mv != null){
          videos.add(mv);
        }
      }
      return videos;
    }
  }
  return null;
}
List<MusicVideo>? parseNewMusicVideos(dynamic content){
  final List<MusicVideo> videos = [];
  final gridRenderer = content["gridRenderer"];
  if(gridRenderer != null){
    final List<dynamic>?items = gridRenderer["items"];
    if(items != null){
      for(final item in items){
        dynamic mv = _parseMusicTwoRowItemRenderer(item);
        mv ??= _parseMusicTwoColumnItemRenderer(item);
        if(mv != null){
          videos.add(mv);
        }
      }
      return videos;
    }
  }
  return null;
}
MoodsAndGenres? _parseMusicNavigationButtonRenderer(dynamic item){
  final musicNavigationButtonRenderer = item?["musicNavigationButtonRenderer"];
  final buttonText = musicNavigationButtonRenderer?["buttonText"];
  String text = _parseText(buttonText?["runs"]) ?? '';
  final solid = musicNavigationButtonRenderer?["solid"];
  final leftStripeColor = solid?["leftStripeColor"];
  final clickCommand = musicNavigationButtonRenderer?["clickCommand"];
  final browseEndpoint = clickCommand?["browseEndpoint"];
  final browseId = browseEndpoint?["browseId"];
  final params = browseEndpoint?["params"];

  if(browseId != null){
    final mood = MoodsAndGenres(
        buttonText: text,
        leftStripeColor: leftStripeColor ?? 0,
        browseId: browseId,
        params: params);
    return mood;
  }
  return null;
}
MoodsAndGenresSection? parseMoodsAndGenresSection(dynamic content){
  final List<MoodsAndGenres> moods = [];
  final gridRenderer = content["gridRenderer"];
  if(gridRenderer != null){
    final List<dynamic>?items = gridRenderer["items"];
    for(final item in items ?? []){
      dynamic mood = _parseMusicNavigationButtonRenderer(item);
      if(mood != null){
        moods.add(mood);
      }
    }
    final header = gridRenderer["header"];
    if(header != null){
      final gridHeaderRenderer = header["gridHeaderRenderer"];
      if(gridHeaderRenderer != null){
        final title = gridHeaderRenderer["title"];
        if(title != null){
          final text = _parseText(title["runs"]);
          if(text != null){
            final section = MoodsAndGenresSection(title: text, items: moods);
            return section;
          }
        }
      }
    }
  }
  return null;
}
Map<String, dynamic>? parseMoodsAndGenresMusicVideos(dynamic content){
  final List<MusicVideo> videos = [];
  String? titleText;
  String? moreText;
  String? browseId;
  String? params;
  String? musicVideoType;
  final musicCarouselShelfRenderer = content['musicCarouselShelfRenderer'];
  if(musicCarouselShelfRenderer != null){
    final header = musicCarouselShelfRenderer["header"];
    if(header != null){
      final musicCarouselShelfBasicHeaderRenderer = header["musicCarouselShelfBasicHeaderRenderer"];
      if(musicCarouselShelfBasicHeaderRenderer != null){
        final title = musicCarouselShelfBasicHeaderRenderer["title"];
        if(title != null){
          titleText = _parseText(title["runs"]);
        }
        final navigationEndpoint = musicCarouselShelfBasicHeaderRenderer["navigationEndpoint"];
        if(navigationEndpoint != null){
          final moreContentButton = musicCarouselShelfBasicHeaderRenderer["moreContentButton"];
          if(moreContentButton != null){
            final buttonRenderer = moreContentButton["buttonRenderer"];
            if(buttonRenderer != null){
              final text = buttonRenderer["text"];
              if(text != null){
                moreText = _parseText(text["runs"]);
              }
            }
          }

          final browseEndpoint = navigationEndpoint["browseEndpoint"];
          if(browseEndpoint != null){
             browseId = browseEndpoint["browseId"];
             params = browseEndpoint["params"];
          }

        }
      }
      final List<dynamic>? contents = musicCarouselShelfRenderer["contents"];
      if(contents != null){
        for (final content in contents){
          final mv = _parseMusicTwoRowItemRenderer(content);
          if(mv != null){
            videos.add(mv);
            musicVideoType ??= _parseMusicVideoType(content);
          }
        }
      }
      videos.shuffle();
      return {"title":titleText,
        "moreText":moreText,
        "videos":videos,
        "browseId":browseId,
        "params":params,
        "musicVideoType":musicVideoType};
    }
  }else{
    final gridRenderer = content["gridRenderer"];
    if(gridRenderer != null){
      final List<dynamic>? items = gridRenderer["items"];
      if(items != null){
        for(final item in items){
          final mv = _parseMusicTwoRowItemRenderer(item);
          if(mv != null){
            videos.add(mv);
            musicVideoType ??= _parseMusicVideoType(item);
          }
        }
      }
      if(videos.isNotEmpty){
        final header = gridRenderer["header"];
        if(header != null){
          final gridHeaderRenderer = header["gridHeaderRenderer"];
          if(gridHeaderRenderer != null){
            final title = gridHeaderRenderer["title"];
            if(title != null){
             final otherTitleText = _parseText(title["runs"]);
             videos.shuffle();
              return {
                "title":otherTitleText,
                "moreText": null,
                "videos":videos,
                "browseId":null,
                "params":null,
                "musicVideoType":musicVideoType
              };
            }
          }
        }
      }
    }
  }
  return null;
}
String? parsePlaylistContinuations(dynamic content){
  final playlistVideoListRenderer = content["playlistVideoListRenderer"];
  if(playlistVideoListRenderer != null){
    final continuation = parseNextContinuation(playlistVideoListRenderer["continuations"]);
    return continuation;
  }
  return null;
}
MusicVideo? _parseMusicListItemCarouselModelItem(dynamic item){
  final thumbnail = _parseThumbnail(item);

  final title = item['title'];
  final subtitle = item['subtitle'];

  final nowPlayingItem = item['nowPlayingItem'];
  final videoId = nowPlayingItem?['videoId'];

  final style = item['style'];

  if(videoId != null){
    final mv = MusicVideo(
        videoId: videoId,
        title: title ?? "",
        subtitle: subtitle ?? "",
        thumbnail: thumbnail ?? "",
        style: style
    );
    return mv;
  }

  return null;
}
PlaylistSection? parseMusicListItemCarouselModel(dynamic model){
  final musicListItemCarouselModel = model?["musicListItemCarouselModel"];
  final List<MusicVideo> videos = [];
  final List<dynamic>? items = musicListItemCarouselModel?["items"];
  for(final item in items ?? []){
    dynamic mv = _parseMusicListItemCarouselModelItem(item);
    if(mv != null){
      videos.add(mv);
    }
  }
  if(videos.isEmpty){
    return null;
  }
  final header = musicListItemCarouselModel?["header"];
  String? title;
  if(header != null){
    title = header?["title"];
  }else{
    final shelfHeader = musicListItemCarouselModel?['shelfHeader'];
    final toggleableHeader = shelfHeader?['toggleableHeader'];
    final defaultHeader = toggleableHeader?['defaultHeader'];
    title = defaultHeader?["title"];
  }
  return PlaylistSection(title: title ?? '', items: videos..shuffle());
}
PlaylistSection? parseMusicContainerCardShelfModel(dynamic model){
  final musicContainerCardShelfModel = model?["musicContainerCardShelfModel"];
  final data = musicContainerCardShelfModel?['data'];
  final List<dynamic>? shelfItems = data?['shelfItems'];
  final shelfItem = shelfItems?.firstOrNull;
  final List<dynamic>? items = shelfItem?['items'];
  final List<MusicVideo> videos = [];
  for(final item in items ?? []){
    dynamic mv = _parseMusicListItemCarouselModelItem(item);
    if(mv != null){
      videos.add(mv);
    }
  }
  if(videos.isEmpty){
    return null;
  }
    final title = shelfItem?["title"];
    // final subtitle = shelfItem?['subtitle'];
    final headerOnTap = shelfItem?['headerOnTap'];
    final innertubeCommand = headerOnTap?['innertubeCommand'];
    final browseEndpoint = innertubeCommand?['browseEndpoint'];
    final browseId = browseEndpoint?['browseId'];
    final section = PlaylistSection(title: title ?? '', items: videos..shuffle());
    section.browseId = browseId;
    return section;
}
MusicVideo? _parseMusicGridItemCarouselModelItem(dynamic item){
  final thumbnail = _parseThumbnail(item);

  final title = item['title'];
  final subtitle = item['subtitle'];

  final onTap = item?['onTap'];
  final innertubeCommand = onTap?['innertubeCommand'];
  final browseEndpoint = innertubeCommand?['browseEndpoint'];
  final browseId = browseEndpoint?['browseId'];

  final watchEndpoint = innertubeCommand?['watchEndpoint'];
  final videoId = watchEndpoint?['videoId'];

  final mv = MusicVideo(videoId: videoId ?? '',
      title: title,
      subtitle: subtitle,
      thumbnail: thumbnail ?? "",
      browseId: browseId);
  return mv;
}
PlaylistSection? parseMusicGridItemCarouselModel(dynamic model){
  final musicGridItemCarouselModel = model["musicGridItemCarouselModel"];
  final shelf = musicGridItemCarouselModel?["shelf"];

  if(shelf != null){
    final List<MusicVideo> videos = [];
    final List<dynamic>? items = shelf["items"];
    if(items != null){
      for(final item in items){
        dynamic mv = _parseMusicGridItemCarouselModelItem(item);
        if(mv != null){
          videos.add(mv);
        }
      }
      final header = shelf["header"];
      String? title;
      if(header != null){
        title = header["title"];
      }
      return PlaylistSection(title: title ?? '', items: videos..shuffle());
    }
  }
  return null;
}
String? parseThumbnail(dynamic videoData){
  final thumbnail = videoData?['thumbnail'];
  List<dynamic>? sources;
  if(thumbnail != null){
    final image = thumbnail?['image'];
    if(image != null){
      sources = image?['sources'];
    }else{
      sources = thumbnail?["sources"];
      sources ??= thumbnail?["thumbnails"];
    }
    if(sources != null){
      final source = sources.lastOrNull;
      final url = source?['url'];
      if (url != null){
        return url;
      }
    }
  }
  return null;
}
final navigatorKey = GlobalKey<NavigatorState>();
final musicNavigatorKey = GlobalKey<NavigatorState>();
final releaseNavigatorKey = GlobalKey<NavigatorState>();
final chartsNavigatorKey = GlobalKey<NavigatorState>();
final genresNavigatorKey = GlobalKey<NavigatorState>();


