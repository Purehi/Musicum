import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';

import '../model/data.dart';
import '../pages/genres/moods_and_genres_data_page.dart';

class MoodsAndGenresCard extends StatelessWidget {
  const MoodsAndGenresCard({super.key, required this.moodsAndGenres});
  final MoodsAndGenres moodsAndGenres;

  @override
  Widget build(BuildContext context) {
    final Color color = _intToColor(moodsAndGenres.leftStripeColor);
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => MoodsAndGenresDataPage(browseId: moodsAndGenres.browseId, params: moodsAndGenres.params,)));
        },
        child: Container(
          decoration: BoxDecoration(
            color: defaultColorScheme.onPrimaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                ),
                width: 6,
                alignment: Alignment.center,),
              const SizedBox(width: 8,),
              Expanded(
                child: Text(moodsAndGenres.buttonText,
                  style: textTheme.bodyMedium?.copyWith(color:defaultColorScheme.primary),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Color _intToColor(int value) {
    // 将整数转换为RGB颜色编码
    int r = (value >> 16) & 0xFF;
    int g = (value >> 8) & 0xFF;
    int b = value & 0xFF;
    return Color.fromARGB(255, r, g, b);
  }
}