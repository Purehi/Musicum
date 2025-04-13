import 'dart:math';

import 'package:advanced_in_app_review/advanced_in_app_review.dart';
import 'package:audio_session/audio_session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:you_tube_music/pages/player/song_player_template_page.dart';
import '../../components/audio_progress_bar.dart';
import '../../components/glass_morphism_card.dart';
import '../../model/youtube_music_link_manager.dart';



class SongPopupPlayer extends StatefulWidget {
  const SongPopupPlayer({super.key,
    required this.isShuffle,
    required this.audioPlayer,
    required this.controller,
    required this.originalVideo,
    required this.video,
  });
  final bool isShuffle;
  final AudioPlayer? audioPlayer;
  final ChewieController? controller;
  final MusicVideo originalVideo;
  final MusicVideo video;

  @override
  State<SongPopupPlayer> createState() => _SongPopupPlayerState();
}
class _SongPopupPlayerState extends State<SongPopupPlayer>{

  ChewieController? _controller;
  VideoPlayerController? _playerController;
  late MusicVideo _video ;
  final List<MusicVideo> _musicVideos = [];
  bool _autoRelease = true;
  static const double _playerMinHeight = 68.0;
  AudioPlayer? _audioPlayer;
  int _currentIndex = 0;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer?.positionStream ?? Stream.value(Duration.zero),
          _audioPlayer?.bufferedPositionStream ?? Stream.value(Duration.zero),
          _audioPlayer?.durationStream ?? Stream.value(Duration.zero),
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void initState() {
    _video = widget.video;
    _controller = widget.controller;
    _playerController = widget.controller?.videoPlayerController;
    _playerController = _controller?.videoPlayerController;
    if(widget.originalVideo.sections.isEmpty){
      YoutubeMusicLinkManager.shared.getYouTubeMusicNext(widget.originalVideo);
    }else{
      _musicVideos.addAll(widget.originalVideo.sections.first.items);
      _currentIndex = _musicVideos.indexWhere((item) => item.videoId == _video.videoId);
    }

    _audioPlayer = widget.audioPlayer;
    _getYoutubeLinkFailListener();
    _getYoutubeLinkSuccessListener();
    _getYoutubeNextSuccess();
    if(_audioPlayer != null){
      final duration = _audioPlayer?.duration ?? Duration.zero;
      if(duration.inSeconds > 0){//已经初始化
        _audioPlayer?.play();
        _audioPlayer?.playbackEventStream.listen((event) {
          final currentIndex = _currentIndex;
          final duration = event.duration ?? Duration.zero;
          final position = event.updatePosition;
          final remaining = duration - position;
          if(event.processingState == ProcessingState.completed){
            if(widget.isShuffle){
              final index = Random().nextInt(_musicVideos.length);
              _currentIndex = index;
              final mv = _musicVideos[index];
              YoutubeMusicLinkManager.shared.getYouTubeMusicURL(mv);
            }else{
              if(currentIndex + 1 < _musicVideos.length){
                final mv = _musicVideos[currentIndex + 1];
                if(mv.videoId != _video.videoId){
                  _audioPlayer?.dispose();
                  _audioPlayer = null;
                  _changedVideo(mv, currentIndex + 1);
                }
              }
            }

          }
          else if(remaining.inSeconds < 20 && remaining.inSeconds > 0){
            if(currentIndex + 1 < _musicVideos.length){
              final mv = _musicVideos[currentIndex + 1];
              YoutubeMusicLinkManager.shared.getYouTubeMusicURL(mv);
            }
          }
        }, onError: (Object e, StackTrace stackTrace) {
              debugPrint('A stream error occurred: $e');
            });
      }else{
        _audioPlayer?.load().then((duration) async {
          if(mounted){
            _audioPlayer?.playbackEventStream.listen((event) {
              final currentIndex = _currentIndex;
              final duration = event.duration ?? Duration.zero;
              final position = event.updatePosition;
              final remaining = duration - position;
              if(event.processingState == ProcessingState.completed){
                if(widget.isShuffle){
                  final index = Random().nextInt(_musicVideos.length);
                  _currentIndex = index;
                  final mv = _musicVideos[index];
                  YoutubeMusicLinkManager.shared.getYouTubeMusicURL(mv);
                }else{
                  if(currentIndex + 1 < _musicVideos.length){
                    final mv = _musicVideos[currentIndex + 1];
                    if(mv.videoId != _video.videoId){
                      _audioPlayer?.dispose();
                      _audioPlayer = null;
                      _changedVideo(mv, currentIndex + 1);
                    }
                  }
                }

              }
              else if(remaining.inSeconds < 20 && remaining.inSeconds > 0){
                if(currentIndex + 1 < _musicVideos.length){
                  final mv = _musicVideos[currentIndex + 1];
                  YoutubeMusicLinkManager.shared.getYouTubeMusicURL(mv);
                }
              }
            }, onError: (Object e, StackTrace stackTrace) {
                  debugPrint('A stream error occurred: $e');
                });
            final session = await AudioSession.instance;
            await session.configure(const AudioSessionConfiguration.speech());
            _audioPlayer?.play();
            setState(() {});
          }
        });
      }
    }else if(_video.videoUrl != null){
      _initializeSongPlayer(_video);
    }else{
      YoutubeMusicLinkManager.shared.getYouTubeMusicURL(_video);
    }
    super.initState();
  }
  ///获取视频播放链接失败
  void _getYoutubeLinkFailListener(){
    getYoutubeLinkFail.addListener(() {
      final MusicVideo? value = getYoutubeLinkFail.value;
      if(value?.videoId == _video.videoId){
        debugPrint('getYoutubeLinkFailListener_pop======${value?.videoId}');
      }
    });
  }
  ///获取视频播放列表成功
  void _getYoutubeNextSuccess(){
    getYoutubeNextSuccess.addListener(() {
      final result = getYoutubeNextSuccess.value;
      final videoId = result?['videoId'];
      if(videoId == widget.originalVideo.videoId){
        final List<PlaylistSection>? sections = result?['sections'];
        if(sections != null){
          _musicVideos.addAll(sections.first.items);
          setState(() {
            widget.originalVideo.sections.addAll(sections);
          });
        }
      }
    });
  }
  ///获取视频播放链接
  void _getYoutubeLinkSuccessListener(){
    getYoutubeLinkSuccess.addListener(() {
      final MusicVideo? value = getYoutubeLinkSuccess.value;
      if(value != null && value.videoId == _video.videoId){
        if(_audioPlayer == null){//没有正在播放的视频则初始化
          _initializeSongPlayer(_video);
        }
      }
    });
  }
  Future<void> _initializeSongPlayer(MusicVideo video) async {
    if(video.videoUrl != null){
      _audioPlayer = AudioPlayer();
      final playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
          Uri.parse(video.videoUrl!),
          tag: MediaItem(
            id: video.videoId,
            album: '',
            title: video.title ?? '',
            artUri: Uri.parse(
                video.thumbnail ?? ''),
          ),
        )
      ]);
      //success to init, update ui
      if(mounted){
        _audioPlayer?.setAudioSource(playlist).then((duration) async {
          if(mounted){
            _audioPlayer?.playbackEventStream.listen((event) {
              final currentIndex = _currentIndex;
              final duration = event.duration ?? Duration.zero;
              final position = event.updatePosition;
              final remaining = duration - position;
              if(event.processingState == ProcessingState.completed){
                if(widget.isShuffle){
                  final index = Random().nextInt(_musicVideos.length);
                  _currentIndex = index;
                  final mv = _musicVideos[index];
                  YoutubeMusicLinkManager.shared.getYouTubeMusicURL(mv);
                }else{
                  if(currentIndex + 1 < _musicVideos.length){
                    final mv = _musicVideos[currentIndex + 1];
                    if(mv.videoId != _video.videoId){
                      _audioPlayer?.dispose();
                      _audioPlayer = null;
                      _changedVideo(mv, currentIndex + 1);
                    }
                  }
                }

              }
              else if(remaining.inSeconds < 20 && remaining.inSeconds > 0){
                if(currentIndex + 1 < _musicVideos.length){
                  final mv = _musicVideos[currentIndex + 1];
                  YoutubeMusicLinkManager.shared.getYouTubeMusicURL(mv);
                }
              }
            },
                onError: (Object e, StackTrace stackTrace) {
                  debugPrint('A stream error occurred: $e');
                });
            final session = await AudioSession.instance;
            await session.configure(const AudioSessionConfiguration.speech());
            _audioPlayer?.play();
            setState(() {});
          }
        }, onError: (error){
          video.videoUrl = null;
        });
      }
    }
  }
  void _changedVideo(MusicVideo video, int index) async{

    _playerController?.pause();
    _playerController?.dispose();
    _playerController = null;
    _controller = null;

    _audioPlayer?.pause();
    _audioPlayer?.dispose();
    _audioPlayer = null;

    _video = video;
    if(mounted){
      setState(() {});
    }
    _currentIndex = index;
    YoutubeMusicLinkManager.shared.getYouTubeMusicURL(_video);
  }

  @override
  void deactivate() {
    if(_autoRelease){
      _playerController?.dispose();
      _playerController = null;
      _audioPlayer?.stop();
      _audioPlayer?.dispose();
      _audioPlayer = null;
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if(_autoRelease){
      _playerController?.dispose();
      _playerController = null;
      _audioPlayer?.stop();
      _audioPlayer?.dispose();
      _audioPlayer = null;
      WakelockPlus.disable();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildNarrowLayout();
          } else {
            return _buildNarrowLayout();
          }
        },
      ),
    );
  }

  Widget _buildNarrowLayout(){
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final isPlaying = _audioPlayer?.playing ?? false;
    return GestureDetector(
      onTap: _handlePopup,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.black,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(_video.thumbnail ?? ''),)
            ),
            child: GlassMorphismCard(
              blur: 30,
              color: Colors.black54,
              opacity: 0.6,
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: SizedBox(
                      width:  _playerMinHeight,
                      height: _playerMinHeight,
                      child: CachedNetworkImage(
                        width: _playerMinHeight,
                        height: _playerMinHeight,
                        fit: BoxFit.cover,
                          imageUrl: _video.thumbnail ?? ''),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _video.title ?? '',
                          style: textTheme.titleMedium?.copyWith(
                            color: defaultColorScheme.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 4,),
                        // subtitle
                        Text(
                          _video.subtitle ?? '',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if(_audioPlayer == null ||
                      _audioPlayer?.processingState == ProcessingState.idle ||
                      _audioPlayer?.processingState == ProcessingState.loading ||
                      _audioPlayer?.processingState == ProcessingState.buffering)
                    SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(color: defaultColorScheme.primary,),
                    )
                  else
                    GestureDetector(
                      onTap: (){
                        if(_audioPlayer?.playing == true){
                          _audioPlayer?.pause();
                        }else{
                          _audioPlayer?.play();
                        }
                        setState(() {});
                      },
                      child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 34, color: defaultColorScheme.primary,),
                    ),
                  IconButton(
                    icon: Icon(Icons.close, color: defaultColorScheme.primary,),
                    onPressed: (){
                      _playerController?.pause();
                      _playerController?.dispose();
                      _audioPlayer?.stop();
                      _audioPlayer?.dispose();
                      PictureInPicture.stopPiP();
                      AdvancedInAppReview()
                          .setMinDaysBeforeRemind(5)
                          .setMinDaysAfterInstall(1)
                          .setMinLaunchTimes(2)
                          .setMinSecondsBeforeShowDialog(10)
                          .monitor();
                    },
                  ),
                ],
              )
            ),
          ),
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return AudioProgressBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition:
                positionData?.bufferedPosition ?? Duration.zero,
              );
            },
          ),
        ],
      ),
    );
  }

  void _handlePopup(){
    _autoRelease = false;
    if(currentIndexKey == 0){
      Navigator.of(navigatorKey.currentContext!, rootNavigator: true).push(MaterialPageRoute(
        builder: (_) => SongPlayerTemplatePage(
          isShuffle: widget.isShuffle,
          audioPlayer: _audioPlayer,
          originalVideo: widget.originalVideo,
          musicVideo: _video,
          videoPlayerController:_playerController,
          ),));
    }
    else if(currentIndexKey == 1){
      Navigator.of(releaseNavigatorKey.currentContext!, rootNavigator: true).push(MaterialPageRoute(
        builder: (_) => SongPlayerTemplatePage(
          isShuffle: widget.isShuffle,
          audioPlayer: _audioPlayer,
          originalVideo: widget.originalVideo,
          musicVideo: _video,
          videoPlayerController:_playerController,
          ),));
    } else if(currentIndexKey == 2){
      Navigator.of(chartsNavigatorKey.currentContext!, rootNavigator: true).push(MaterialPageRoute(
        builder: (_) => SongPlayerTemplatePage(
          isShuffle: widget.isShuffle,
          audioPlayer: _audioPlayer,
          originalVideo: widget.originalVideo,
          musicVideo: _video,
          videoPlayerController:_playerController,
          ),));
    }else if(currentIndexKey == 3){
      Navigator.of(musicNavigatorKey.currentContext!, rootNavigator: true).push(MaterialPageRoute(
        builder: (_) => SongPlayerTemplatePage(
          isShuffle: widget.isShuffle,
          audioPlayer: _audioPlayer,
          originalVideo: widget.originalVideo,
          musicVideo: _video,
          videoPlayerController:_playerController,
          ),));
    }else if(currentIndexKey == 4){
      Navigator.of(genresNavigatorKey.currentContext!, rootNavigator: true).push(MaterialPageRoute(
        builder: (_) => SongPlayerTemplatePage(
          isShuffle: widget.isShuffle,
          audioPlayer: _audioPlayer,
          originalVideo: widget.originalVideo,
          musicVideo: _video,
          videoPlayerController:_playerController,
        ),));
    }
    PictureInPicture.stopPiP();

  }
}