import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:you_tube_music/model/data.dart';


class PaginationCard extends StatelessWidget {
  const PaginationCard({super.key,
    required this.musicVideo,});

  final MusicVideo musicVideo;
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6),
      decoration: BoxDecoration(color:
      defaultColorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(musicVideo.thumbnail ?? ''),
                  fit: BoxFit.cover
              ),
            ),
          ),
          Text(musicVideo.index ?? "",
            style: textTheme.titleMedium?.copyWith(
              color: defaultColorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
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
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(musicVideo.title ?? '', style: textTheme.titleMedium?.copyWith(
                  color:defaultColorScheme.primary),maxLines: 2,overflow: TextOverflow.ellipsis,),
              Text(musicVideo.subtitle ?? '', style: textTheme.bodyMedium?.copyWith(color:defaultColorScheme.onPrimary.withValues(alpha: 0.6)),maxLines: 1,),
            ],
          )),
        ],
      ),
    );
  }
}


