import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/picture_in_picture.dart';
import 'package:flutter_in_app_pip/pip_params.dart';
import 'package:flutter_in_app_pip/pip_view_corner.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:you_tube_music/components/play_button.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:you_tube_music/pages/player/song_popup_player.dart';
import 'package:you_tube_music/pages/player/songs_playlist_page.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';

import '../../components/audio_seek_bar.dart';
import '../../components/controls_bar.dart';
import '../../components/glass_morphism_card.dart';
import '../../model/youtube_music_link_manager.dart';


class SongPlayerTemplatePage extends StatefulWidget {
  const SongPlayerTemplatePage({
    super.key,
    required this.videoPlayerController,
    required this.audioPlayer,
    required this.originalVideo,
    required this.musicVideo,
    required this.isShuffle,
  });
  final MusicVideo originalVideo;
  final MusicVideo musicVideo;
  final bool isShuffle;
  final VideoPlayerController? videoPlayerController;
  final AudioPlayer? audioPlayer;

  @override
  State<SongPlayerTemplatePage> createState() => _SongPlayerTemplatePageState();
}

class _SongPlayerTemplatePageState extends State<SongPlayerTemplatePage> {
  final ScrollController _scrollController = ScrollController();

  MusicVideo? _musicVideo;
  final List<MusicVideo> _musicVideos = [];
  //video player
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  bool _isShuffle = false;
  bool _isLoop = false;

  bool _songPlayer = true;
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
    WakelockPlus.enable();
    _getYoutubeLinkFailListener();
    _getYoutubeLinkSuccessListener();
    _getYoutubeNextSuccess();
    _isShuffle = widget.isShuffle;
    _audioPlayer = widget.audioPlayer;
    _musicVideo = widget.musicVideo;
    if(widget.originalVideo.sections.isEmpty){
      YoutubeMusicLinkManager.shared.getYouTubeMusicNext(widget.musicVideo);
    }else{
      _musicVideos.addAll(widget.originalVideo.sections.first.items);
      _currentIndex = _musicVideos.indexWhere((item) => item.videoId == _musicVideo?.videoId);
    }
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
                if(mv.videoId != _musicVideo?.videoId){
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
                    if(mv.videoId != _musicVideo?.videoId){
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
    }else if(_musicVideo?.videoUrl != null){
      _initializeSongPlayer(_musicVideo!);
    }else{
      YoutubeMusicLinkManager.shared.getYouTubeMusicURL(widget.musicVideo);
    }
    if(_videoPlayerController != null){
      _createChewieController(_musicVideo!);
    }else if(_musicVideo?.videoUrl != null){
      _initializePlayer(_musicVideo!);
    }else{
      YoutubeMusicLinkManager.shared.getYouTubeMusicURL(widget.musicVideo);
    }

    super.initState();
  }

  ///获取视频播放链接失败
  void _getYoutubeLinkFailListener(){
    getYoutubeLinkFail.addListener(() {
      final MusicVideo? value = getYoutubeLinkFail.value;
      if(value?.videoId == _musicVideo?.videoId){
        debugPrint('getYoutubeLinkFailListener======${value?.videoId}');
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
        if(sections != null && mounted){
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
    getYoutubeLinkSuccess.addListener(() async {
      final MusicVideo? value = getYoutubeLinkSuccess.value;
      if(value != null){
        if(value.videoId == _musicVideo?.videoId){
          if(_audioPlayer == null){
            _initializeSongPlayer(_musicVideo!);
          }
          if(_videoPlayerController == null){
            _initializePlayer(_musicVideo!);
          }
        }
      }
    });
  }
  Future<void> _initializeSongPlayer(MusicVideo video) async {
    if(video.videoUrl != null){
      //success to init, update ui
      if(mounted){
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
        _audioPlayer?.setAudioSource(playlist).then((duration) async {
          if(mounted && _songPlayer){
            _audioPlayer?.playbackEventStream.listen((event) {
              final currentIndex = _currentIndex;
              final duration = event.duration ?? Duration.zero;
              final position = event.updatePosition;
              final remaining = duration - position;
              if(event.processingState == ProcessingState.completed){
                if(_isShuffle){
                  final index = Random().nextInt(_musicVideos.length);
                  _currentIndex = index;
                  final mv = _musicVideos[index];
                  YoutubeMusicLinkManager.shared.getYouTubeMusicURL(mv);
                }else{
                  if(currentIndex + 1 < _musicVideos.length){
                    final mv = _musicVideos[currentIndex + 1];
                    if(mv.videoId != _musicVideo?.videoId){
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
  Future<void> _initializePlayer(MusicVideo video) async {
    if(video.videoUrl != null){
      //success to init, update ui
      if(mounted){
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(video.videoUrl!));
        _videoPlayerController?.initialize().then((_){
          if(mounted){
            _createChewieController(video);
            if(!_songPlayer){
              _videoPlayerController?.play();
              setState(() {});
            }
          }else{
            _videoPlayerController?.pause();
            _videoPlayerController?.dispose();
            _videoPlayerController = null;
          }
        },onError: (error){
          //remove error link
          video.videoUrl = null;
          _videoPlayerController = null;
        });
      }
    }
  }
  void _createChewieController(MusicVideo video) {
    final isLive = (video.timestampStyle=='LIVE') ? true : false;
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        showControls: false,
        hideControlsTimer: const Duration(seconds: 1),
        autoInitialize: true,
        isLive: isLive
    );
  }
  Widget _videoPlayerComponent(ChewieController controller){
    return FittedBox(
      fit: BoxFit.cover, // Set BoxFit to cover the entire container
      child: SizedBox(
        width: _videoPlayerController?.value.size.width,
        height: _videoPlayerController?.value.size.height,
        child: Chewie(
          controller: controller,
        ),
      ),
    );
  }
  void _showPopup({bool close = true}){
    final size = MediaQuery.of(context).size;
    PictureInPicture.stopPiP();
    PictureInPicture.updatePiPParams(
      pipParams: PiPParams(
        pipWindowWidth: size.width,
        pipWindowHeight: 68,
        bottomSpace: kBottomNavigationBarHeight - 1,
        leftSpace: 0.0,
        rightSpace: 0.0,
        topSpace:  0.0,
        movable: false,
        resizable: false,
        initialCorner: PIPViewCorner.bottomLeft,
      ),);
    PictureInPicture.startPiP(pipWidget: SongPopupPlayer(
      isShuffle: _isShuffle,
      audioPlayer: _audioPlayer,
      controller: _chewieController,
      video: _musicVideo!,
      originalVideo: widget.originalVideo, ));
    if(close){
      Navigator.of(context).pop();
    }
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
    final padding = MediaQuery.of(context).padding;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, result){
        // This can be async and you can check your condition
        _showPopup(close: false);
      },
      child: MediaQuery(
        data: MediaQuery.of(context).scale(),
        child: Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(icon: Icon(Icons.keyboard_arrow_down_outlined,
                size: 50,
                color: defaultColorScheme.primary,), onPressed: ()=> _showPopup(),
                visualDensity: VisualDensity(horizontal: -3.0, vertical: -3.0),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                  color: defaultColorScheme.surface,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(_musicVideo?.thumbnail ?? ''),)
              ),
              child: GlassMorphismCard(
                blur: 30,
                color: Colors.black54,
                opacity: 0.6,
                borderRadius: BorderRadius.circular(0),
                child: CustomScrollView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _songPlayer = !_songPlayer;
                              });
                              if(_songPlayer){
                                _videoPlayerController?.pause();
                                _audioPlayer?.play();
                              }else{
                                _audioPlayer?.pause();
                                _videoPlayerController?.play();
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: kToolbarHeight + 24.0),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        color: _songPlayer ? Colors.white : Colors.transparent),
                                    child: Center(
                                        child: Text(
                                          'Song',
                                          style: textTheme.titleMedium?.copyWith(
                                              color: _songPlayer ? Colors.black : Colors.grey,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )),
                                  ),
                                  Container(
                                    width: 70,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        color: _songPlayer ? Colors.transparent : Colors.white),
                                    child: Center(
                                      child: Text(
                                        'Video',
                                        style: textTheme.titleMedium?.copyWith(
                                            color:_songPlayer ? Colors.grey : Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),),
                    if(_songPlayer)SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: kTextTabBarHeight + padding.top,),
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: CachedNetworkImage(
                                fadeInDuration: Duration.zero,
                                fadeOutDuration: Duration.zero,
                                imageUrl: 'https://i.ytimg.com/vi/${_musicVideo?.videoId}/hqdefault.jpg',
                                // width: screenWidth,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_musicVideo?.title ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.titleLarge?.copyWith(
                                            color: defaultColorScheme.primary,
                                            // fontWeight: FontWeight.bold
                                          ),),
                                        Text(_musicVideo?.subtitle ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyMedium?.copyWith( color:Colors.grey,),),
                                      ],
                                    ),
                                  ),
                                ],),
                            ),
                            StreamBuilder<PositionData>(
                              stream: _positionDataStream,
                              builder: (context, snapshot) {
                                final positionData = snapshot.data;
                                return AudioSeekBar(
                                  duration: positionData?.duration ?? Duration.zero,
                                  position: positionData?.position ?? Duration.zero,
                                  bufferedPosition:
                                  positionData?.bufferedPosition ?? Duration.zero,
                                  onChangeEnd: (newPosition) {
                                    _audioPlayer?.seek(newPosition);
                                  },
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                StreamBuilder<LoopMode>(
                                  stream: _audioPlayer?.loopModeStream,
                                  builder: (context, snapshot) {
                                    final loopMode = snapshot.data ?? LoopMode.off;
                                    const icons = [
                                      Icon(Icons.repeat, color: Colors.grey),
                                      Icon(Icons.repeat, color: Colors.orange),
                                      Icon(Icons.repeat_one, color: Colors.orange),
                                    ];
                                    const cycleModes = [
                                      LoopMode.off,
                                      LoopMode.all,
                                      LoopMode.one,
                                    ];
                                    final index = cycleModes.indexOf(loopMode);
                                    return IconButton(
                                      icon: icons[index],
                                      onPressed: () {
                                        _audioPlayer?.setLoopMode(cycleModes[
                                        (cycleModes.indexOf(loopMode) + 1) %
                                            cycleModes.length]);
                                      },
                                    );
                                  },
                                ),
                                ControlButtons(_audioPlayer, onNextChanged: (){
                                  final currentIndex = _currentIndex;
                                  if(currentIndex + 1 < _musicVideos.length){
                                    final mv = _musicVideos[currentIndex + 1];
                                    _changedVideo(mv, currentIndex + 1);
                                  }
                                },onPreviousChanged: (){
                                  final currentIndex = _currentIndex;
                                  if(currentIndex - 1 >= 0){
                                    final mv = _musicVideos[currentIndex - 1];
                                    _changedVideo(mv, currentIndex - 1);
                                  }
                                },),
                                IconButton(
                                  icon: _isShuffle
                                      ? const Icon(Icons.shuffle, color: Colors.orange)
                                      : const Icon(Icons.shuffle, color: Colors.grey),
                                  onPressed: () async {
                                    setState(() {
                                      _isShuffle = !_isShuffle;
                                    });

                                  },
                                )
                              ],
                            ),
                            SizedBox(height: 40,),
                            if(_musicVideos.isNotEmpty)Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap:(){
                                      int index = _musicVideos.indexWhere((item) => item.videoId == _musicVideo?.videoId);
                                      showBarModalBottomSheet(
                                        expand: false,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        barrierColor: Colors.transparent,
                                        builder: (context) => SongsPlaylistPage(musicVideos: _musicVideos, index: index < 0 ? 0:index, onTap: (MusicVideo musicVideo) {
                                          _changedVideo(musicVideo, index);
                                        },),);
                                    },
                                    child: Text(
                                      widget.originalVideo.sections.first.title,
                                      style: textTheme.titleSmall?.copyWith(
                                          color: defaultColorScheme.primary
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: kToolbarHeight,)
                          ],
                        ))
                    else
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: kTextTabBarHeight + padding.top,),
                            if(_chewieController != null)_videoPlayerComponent(_chewieController!)
                            else
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration.zero,
                                  fadeOutDuration: Duration.zero,
                                  imageUrl: 'https://i.ytimg.com/vi/${_musicVideo?.videoId}/hqdefault.jpg',
                                  // width: screenWidth,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_musicVideo?.title ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.titleLarge?.copyWith(
                                            color: defaultColorScheme.primary,
                                            // fontWeight: FontWeight.bold
                                          ),),
                                        Text(_musicVideo?.subtitle ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodyMedium?.copyWith( color:Colors.grey,),),
                                      ],
                                    ),
                                  ),
                                ],),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if(_chewieController != null)ControlsBar(controller: _chewieController!, popup: () {}, video: _musicVideo!, endPlay: (end){
                                  if(end){
                                    if(_isLoop){
                                      _videoPlayerController?.play();
                                    }else{
                                      if(_isShuffle && _musicVideos.isNotEmpty){
                                        final index = Random().nextInt(_musicVideos.length);
                                        final video = _musicVideos[index];
                                        _changedVideo(video, index);
                                      }else{//正常播放下一首歌曲
                                        if(_musicVideos.isNotEmpty){
                                          int index = _currentIndex;
                                          if(index + 1 < _musicVideos.length){
                                            final video = _musicVideos[index + 1];
                                            _changedVideo(video, index + 1);
                                          }
                                        }
                                      }
                                    }
                                  }

                                },remainPlay: (remain){
                                  if(remain < 20){
                                    if(_isShuffle && _musicVideos.isNotEmpty){
                                      final index = Random().nextInt(_musicVideos.length);
                                      final video = _musicVideos[index];
                                      YoutubeMusicLinkManager.shared.getYouTubeMusicURL(video);
                                    }else{//正常播放下一首歌曲
                                      if(_musicVideos.isNotEmpty){
                                        int index = _musicVideos.indexWhere((item) => item.videoId == _musicVideo?.videoId);
                                        if(index != -1 && (index + 1) < _musicVideos.length){
                                          final video = _musicVideos[index + 1];
                                          YoutubeMusicLinkManager.shared.getYouTubeMusicURL(video);
                                        }
                                      }
                                    }
                                  }
                                },),
                                PlayButton(
                                  next: _playNextMusicVideo,
                                  previous: _playPreviousMusicVideo,
                                  controller: _videoPlayerController,
                                  shuffle: (isShuffle) {
                                    _isShuffle = !_isShuffle;
                                    _isLoop = false;
                                  },
                                  loop: (isLoop) {
                                    _isLoop = !_isLoop;
                                    _isShuffle = false;
                                  },),
                                SizedBox(height: 40,),
                                if(_musicVideos.isNotEmpty)Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap:(){
                                          int index = _musicVideos.indexWhere((item) => item.videoId == _musicVideo?.videoId);
                                          showBarModalBottomSheet(
                                            expand: false,
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            barrierColor: Colors.transparent,
                                            builder: (context) => SongsPlaylistPage(musicVideos: _musicVideos, index: index < 0 ? 0:index, onTap: (MusicVideo musicVideo) {
                                              _changedVideo(musicVideo, index);
                                            },),);
                                        },
                                        child: Text(
                                          widget.originalVideo.sections.first.title,
                                          style: textTheme.titleSmall?.copyWith(
                                              color: defaultColorScheme.primary
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: kToolbarHeight,)
                              ],),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
  void _changedVideo(MusicVideo video, int index) async{

    WidgetsBinding.instance.addPostFrameCallback((_){
      if(mounted){
        setState(() {
          _chewieController = null;
          _videoPlayerController?.pause();
          _videoPlayerController?.dispose();
          _videoPlayerController = null;

          _audioPlayer?.pause();
          _audioPlayer?.dispose();
          _audioPlayer = null;
          _musicVideo = video;
          _currentIndex = index;
        });
      }
    });

    YoutubeMusicLinkManager.shared.getYouTubeMusicURL(video);

  }
  void _playNextMusicVideo(){
    if(_musicVideos.isNotEmpty){
      int index = _currentIndex;
      if(index + 1 < _musicVideos.length){
        final video = _musicVideos[index + 1];
        _changedVideo(video, index + 1);
      }
    }

  }
  void _playPreviousMusicVideo(){
    if(_musicVideos.isNotEmpty){
      int index = _currentIndex;
      if(index - 1 >= 0){
        final video = _musicVideos[index - 1];
        _changedVideo(video, index - 1);
      }
    }
  }
}

