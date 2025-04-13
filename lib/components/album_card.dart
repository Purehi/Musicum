import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:you_tube_music/pages/album/album_page.dart';

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.musicVideo});
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
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.height * 0.18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: (musicVideo.thumbnail != null) ? DecorationImage(
                      image: CachedNetworkImageProvider(musicVideo.thumbnail!),
                      fit: BoxFit.cover
                  ) : null,
                ),
              ),
              if(musicVideo.title != null)const SizedBox(height: 10,),
              if(musicVideo.title != null)SizedBox(
                width: MediaQuery.of(context).size.height * 0.18,
                child: Text(musicVideo.title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    color: defaultColorScheme.primary,
                  ),
                ),
              ),
              if(musicVideo.subtitle != null)const SizedBox(height: 6,),
              if(musicVideo.subtitle != null)SizedBox(
                width: MediaQuery.of(context).size.height * 0.18,
                child: Text(musicVideo.subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: defaultColorScheme.onPrimary,
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}


