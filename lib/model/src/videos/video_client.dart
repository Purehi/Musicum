
import 'package:you_tube_music/model/src/videos/video_link.dart';

import '../reverse_engineering/pages/watch_page.dart';
import '../reverse_engineering/youtube_http_client.dart';
import 'videos.dart';

/// Queries related to YouTube videos.
class VideoClient {
  final YoutubeHttpClient _httpClient;

  /// Queries related to media streams of YouTube videos.
  final StreamClient streamsClient;

  /// Queries related to media streams of YouTube videos.
  /// Alias of [streamsClient].
  StreamClient get streams => streamsClient;

  /// Queries related to closed captions of YouTube videos.
  final ClosedCaptionClient closedCaptions;


  /// Initializes an instance of [VideoClient].
  VideoClient(this._httpClient)
      : streamsClient = StreamClient(_httpClient),
        closedCaptions = ClosedCaptionClient(_httpClient);

  /// Gets the metadata associated with the specified video.
  Future<VideoLink> _getVideoFromWatchPage(VideoId videoId) async {
    final watchPage = await WatchPage.get(_httpClient, videoId.value);
    final playerResponse = watchPage.playerResponse!;

    return VideoLink(
      videoId,
      playerResponse.isLive,
      watchPage,
    );
  }

  /// Get a [Video] instance from a [videoId]
  Future<VideoLink> get(dynamic videoId) async =>
      _getVideoFromWatchPage(VideoId.fromString(videoId));
}
