import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:you_tube_music/pages/album/album_page.dart';

class ReleaseCard extends StatelessWidget {
  const ReleaseCard({super.key, required this.musicVideo});
  final MusicVideo musicVideo;

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
        onTap: (){
          if(musicVideo.browseId != null){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AlbumPage(musicVideo: musicVideo,)));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(musicVideo.thumbnail != null)AspectRatio(
              aspectRatio: 1,
              child:CachedNetworkImage(
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                imageUrl: musicVideo.thumbnail!,
                imageBuilder: (context, imageProvider) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: defaultColorScheme.onPrimaryContainer,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            if(musicVideo.title != null)const SizedBox(height: 10,),
            if(musicVideo.title != null)Text(musicVideo.title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium?.copyWith(
                color: defaultColorScheme.primary
              ),
            ),
            if(musicVideo.subtitle != null)const SizedBox(height: 6,),
            if(musicVideo.subtitle != null)Text(musicVideo.subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                  color: defaultColorScheme.secondary
              ),
            )
          ],
        )
    );
  }
}


