import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:you_tube_music/pages/playlist/playlist_page.dart';

class PlaylistOtherCard extends StatelessWidget {
  const PlaylistOtherCard({super.key, required this.musicVideo});
  final MusicVideo musicVideo;

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
        onTap: (){
          if(musicVideo.browseId != null){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PlaylistPage(musicVideo: musicVideo,)));
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.height * 0.20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(musicVideo.thumbnail ?? ''),
                    fit: BoxFit.cover
                ),
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.20,
              child: Text(musicVideo.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                    color: defaultColorScheme.primary,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.20,
              child: Text(musicVideo.subtitle ?? '',
                style: textTheme.bodyMedium?.copyWith(
                    color: defaultColorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )
    );
  }
}