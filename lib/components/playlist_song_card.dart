import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/model/data.dart';



class PlaylistSongCard extends StatelessWidget {
  const PlaylistSongCard({super.key,
    required this.musicVideo,
  });
  final MusicVideo musicVideo;

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(musicVideo.thumbnail != null)Container(
              height: 40,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(musicVideo.thumbnail!),
                    fit: BoxFit.cover
                ),
              ),
            ),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(musicVideo.title ?? '', style: textTheme.titleMedium?.copyWith(
                    color:defaultColorScheme.primary),maxLines: 1,overflow: TextOverflow.ellipsis,),
                Text(musicVideo.subtitle ?? '', style: textTheme.bodyMedium?.copyWith(color:defaultColorScheme.onPrimary),maxLines: 2,),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

