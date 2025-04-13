import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:you_tube_music/model/data.dart';

class CarsouelCard extends StatelessWidget {
  const CarsouelCard({super.key, required this.musicVideo});
  final MusicVideo musicVideo;


  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
    final screenWidth = platformDispatcher.views.first.physicalSize.width / platformDispatcher.views.first.devicePixelRatio;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if(musicVideo.thumbnail != null)AspectRatio(
              aspectRatio: 16/9,
              child:CachedNetworkImage(
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                imageUrl: musicVideo.thumbnail ?? '',
                width: screenWidth,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: defaultColorScheme.onPrimaryContainer,
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )
            else
              AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: defaultColorScheme.onPrimaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),)
              ),
            Icon(Icons.play_arrow_rounded, size: 60, color: defaultColorScheme.primary.withValues(alpha: 0.8),),
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
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
            Expanded(
              child: Text(musicVideo.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  color: defaultColorScheme.primary,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        if(musicVideo.subtitle != null)Text(musicVideo.subtitle!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium?.copyWith(
            color: defaultColorScheme.onPrimary,
          ),
        ),
        if(musicVideo.subtitle != null)const SizedBox(height: 20,),
      ],
    );
  }
}

