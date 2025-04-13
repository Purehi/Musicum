import 'package:flutter/material.dart';
import 'package:you_tube_music/model/data.dart';


class CountryPage extends StatefulWidget {
  const CountryPage({
    super.key,
    required this.filters,
    required this.title,
    required this.selectedFilter,
    required this.onTap, });
  final List<MusicSortFilter> filters;
  final String title;
  final MusicSortFilter? selectedFilter;
  final Function(MusicSortFilter) onTap;

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  @override
  void initState() {

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: defaultColorScheme.surface,
      appBar: AppBar(
        backgroundColor: defaultColorScheme.surface,
        elevation: 0,
        leading: BackButton(
          color: defaultColorScheme.primary,
        ),
        title: Text(widget.title, style: textTheme.headlineSmall?.copyWith(
            color: defaultColorScheme.primary
        ),),
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            itemCount: widget.filters.length,
            itemBuilder: (context, index){
              final filter = widget.filters[index];
              bool isCheck = filter.id == widget.selectedFilter?.id;
              return InkWell(
                onTap: () async {
                  widget.onTap(filter);
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  title: Text(filter.title, style: textTheme.titleMedium?.copyWith(
                      color: isCheck ?  Color(0xff009a3d) : defaultColorScheme.primary
                  ),),
                  trailing: isCheck ? const Icon(Icons.check, color: Color(0xff009a3d),) : null,
                ),
              );
            }),
      ),
    );
  }

}

