import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:you_tube_music/model/data.dart';


class PlaylistSectionSongCard extends StatelessWidget {
  const PlaylistSectionSongCard({super.key,
    required this.musicVideo,});
  final MusicVideo musicVideo;

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
      child: Row(
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
          const SizedBox(width: 10,),
          Expanded(
            child: Row(
              spacing: 10,
              children: [
                if(musicVideo.iconType != null && musicVideo.iconType!.toLowerCase().contains('neutral'))
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                    ),
                  )
                else if(musicVideo.iconType != null && musicVideo.iconType!.toLowerCase().contains('drop_down'))
                  const Icon(Icons.arrow_drop_down, color: Colors.redAccent,)
                else if(musicVideo.iconType != null)
                    const Icon(Icons.arrow_drop_up, color: Colors.green,),
                Text(musicVideo.index ?? "",
                  style: textTheme.titleMedium?.copyWith(
                    color: defaultColorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(musicVideo.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          color: defaultColorScheme.primary,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(musicVideo.subtitle ?? '', style: textTheme.bodyMedium?.copyWith(color:defaultColorScheme.onPrimary.withValues(alpha: 0.6)),maxLines: 1,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


