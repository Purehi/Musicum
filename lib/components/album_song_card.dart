import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/model/data.dart';


class AlbumSongCard extends StatefulWidget {
  const AlbumSongCard({super.key,
    required this.musicVideo,
    required this.index,
  });
  final MusicVideo musicVideo;
  final int index;


  @override
  State<AlbumSongCard> createState() => _AlbumSongCardState();
}

class _AlbumSongCardState extends State<AlbumSongCard> {
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(widget.musicVideo.index != null)SizedBox(
              width: 37,
              child: Text(widget.musicVideo.index ?? "", style: textTheme.titleMedium?.copyWith(
                  color:defaultColorScheme.primary),textAlign: TextAlign.center,),
            ),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.musicVideo.title ?? '', style: textTheme.titleMedium?.copyWith(
                    color:defaultColorScheme.primary),maxLines: 2,overflow: TextOverflow.ellipsis,),
                Text(widget.musicVideo.subtitle ?? '', style: textTheme.bodyMedium?.copyWith(color:defaultColorScheme.onPrimary),maxLines: 2,),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
