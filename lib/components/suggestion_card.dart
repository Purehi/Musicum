import 'package:flutter/material.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(height: 40,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.search, color: defaultColorScheme.primary,),
              const SizedBox(width: 40,),
              Text(text, style: textTheme.titleMedium?.copyWith(color: defaultColorScheme.primary),),
            ],
          ),
          Icon(Icons.north_west, color: defaultColorScheme.primary,),
        ],
      ),
    ),);
  }
}
