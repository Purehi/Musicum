import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:you_tube_music/pages/artists/artists_page.dart';

class ArtistsCircularCard extends StatelessWidget {
  const ArtistsCircularCard({super.key, required this.musicVideo});
  final MusicVideo musicVideo;

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return InkWell(
        onTap: (){
          if(musicVideo.browseId != null){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ArtistsPage(musicVideo: musicVideo,)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              Container(
                height: size.height * 0.15,
                width: size.height * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.height * 0.1),
                  image: (musicVideo.thumbnail != null) ? DecorationImage(
                      image: CachedNetworkImageProvider(musicVideo.thumbnail!),
                      fit: BoxFit.cover
                  ) : null,
                ),
              ),
              if(musicVideo.title != null)const SizedBox(height: 10,),
              if(musicVideo.title != null)Text(musicVideo.title!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  color: defaultColorScheme.primary,
                ),
              ),
              if(musicVideo.subtitle != null)Text(musicVideo.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: defaultColorScheme.onPrimary,
                ),
              )
            ],
          ),
        )
    );
  }
}


