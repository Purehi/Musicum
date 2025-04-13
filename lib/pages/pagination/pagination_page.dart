import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/model/data.dart';
import 'package:you_tube_music/pages/pagination/pagination_sub_page.dart';

import '../playlist/playlist_section_page.dart';

class PaginationPage extends StatefulWidget {
  const PaginationPage({super.key, required this.playListSection});
  final PlaylistSection playListSection;

  @override
  State<PaginationPage> createState() => _PaginationPageState();
}

class _PaginationPageState extends State<PaginationPage> with SingleTickerProviderStateMixin{
  int _pageLength = 0;
  int _currentPage = 0;
  final List<PaginationSubPage> _children = [];
  late final TabController _controller;
  @override
  void initState() {
    super.initState();
    _pageLength = widget.playListSection.items.length ~/ 4 ;
    if(widget.playListSection.items.length % 4 > 0){
      _pageLength += 1;
    }
    _controller = TabController(length: _pageLength, vsync: this);
    _controller.addListener((){
      if(_currentPage != _controller.index){
        setState(() {
          _currentPage = _controller.index;
        });
      }
    });
    final children = _generateWidget(_pageLength);
    _children.addAll(children);
  }
  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return MediaQuery(
        data: MediaQuery.of(context).scale(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(widget.playListSection.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineSmall?.copyWith(
                          color: defaultColorScheme.primary,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  if(widget.playListSection.browseId != null)InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PlaylistSectionPage(playlistSection: widget.playListSection,)));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          color: defaultColorScheme.surface,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          border: Border.all(color: defaultColorScheme.onPrimaryContainer)
                      ),
                      child: Text(widget.playListSection.buttonText ?? 'More', style: textTheme.titleMedium?.copyWith(
                        color: defaultColorScheme.primary
                      ),),
                    ),
                  ),

                  if(_pageLength > 1)InkWell(
                    onTap: (){
                      if(_currentPage - 1 >= 0){
                        _currentPage -= 1;
                        setState(() {
                          _controller.animateTo(_currentPage);
                        });
                      }
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: defaultColorScheme.surface,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          border: Border.all(color: defaultColorScheme.onPrimaryContainer)
                      ),
                      child: Icon(Icons.chevron_left_outlined, color: _currentPage > 0 ? defaultColorScheme.primary : Colors.grey,),
                    ),
                  ),
                  if(_pageLength > 1)InkWell(
                    onTap: (){
                      if(_currentPage + 1 < _pageLength){
                        _currentPage += 1;
                        setState(() {
                          _controller.animateTo(_currentPage);
                        });
                      }else{
                        _currentPage = 0;
                        setState(() {
                          _controller.animateTo(_currentPage);
                        });
                      }
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: defaultColorScheme.surface,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          border: Border.all(color: defaultColorScheme.onPrimaryContainer)
                      ),
                      child: Icon(Icons.chevron_right_outlined),
                    ),
                  ),
                ],),
            ),
            SizedBox(
              height: 280,
              child: DefaultTabController(
                length: _pageLength,
                child: TabBarView(
                  controller: _controller,
                    children: _children
                ),
              ),
            ),
          ],
        ));
  }
 List<PaginationSubPage> _generateWidget(int pageLength){
   final children = <PaginationSubPage>[];
   for (var i = 0; i < pageLength; i++) {
     final start = i * 4;
     int end = (i + 1) * 4;
     if(end > widget.playListSection.items.length){
       end = widget.playListSection.items.length;
     }
     final musicVideos = widget.playListSection.items.sublist(start, end);
     children.add(PaginationSubPage(musicVideos: musicVideos));
   }
   return children;
  }
}
