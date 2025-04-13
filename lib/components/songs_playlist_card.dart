import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:you_tube_music/model/data.dart';

class SongsPlaylistCard extends StatelessWidget {
  const SongsPlaylistCard({super.key,
    required this.musicVideo,
    required this.index,
    required this.playing,});
  final MusicVideo musicVideo;
  final int index;
  final bool playing;

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textScheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color:
        defaultColorScheme.surface,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 24,
              child: Text("${index+1}", style: textScheme.titleMedium?.copyWith(
                  color: playing ? Colors.redAccent : defaultColorScheme.primary
              )),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: defaultColorScheme.onPrimaryContainer,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(musicVideo.thumbnail ?? ''),
                    fit: BoxFit.cover
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(musicVideo.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textScheme.titleMedium?.copyWith(
                        color: playing ? Colors.redAccent : defaultColorScheme.primary)),
                Text(musicVideo.subtitle ?? '', style: textScheme.bodyMedium?.copyWith(
                    color: Colors.grey
                ),maxLines: 2,),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

