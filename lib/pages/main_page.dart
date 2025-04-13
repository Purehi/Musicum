import 'package:flutter/material.dart';
import 'package:scaled_app/scaled_app.dart';
import 'package:you_tube_music/model/country.dart';
import 'package:you_tube_music/pages/charts/charts_page.dart';
import 'package:you_tube_music/pages/home_page.dart';
import 'package:you_tube_music/pages/music/music_section_page.dart';
import 'package:you_tube_music/pages/release/new_release_page.dart';
import 'package:you_tube_music/model/data.dart';

import 'genres/moods_and_genres_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final myLocale = Localizations.localeOf(context);
    if(countryCode == 'US' && myLocale.countryCode != 'US'){//非默认值
      final isRemove = removeSomeCountry(myLocale.countryCode);
      if(isRemove){
        countryCode = 'US';
        languageCode = 'en';
      }else{
        countryCode = myLocale.countryCode ?? 'US';
        languageCode = myLocale.languageCode;
      }
    }
    return MediaQuery(
      data: MediaQuery.of(context).scale(),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
            currentIndexKey = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: defaultColorScheme.surface,
          unselectedItemColor: defaultColorScheme.primary,
          selectedItemColor: defaultColorScheme.onError,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.album_outlined),
                activeIcon: Icon(Icons.album_rounded),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.show_chart_outlined),
                activeIcon: Icon(Icons.show_chart_rounded),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.music_note_outlined),
                activeIcon: Icon(Icons.music_note_rounded),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category_rounded),
                label: ''),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            PopScope(
              canPop: false,
              onPopInvokedWithResult: (bool didPop, result){
                // This can be async and you can check your condition
                final navigator = navigatorKey.currentState;
                final currentContext = navigatorKey.currentContext;
                if (navigator != null && navigator.canPop() && currentContext != null && _currentIndex == 0){
                  if (mounted) Navigator.of(currentContext).pop();
                }
              },
              child: Navigator(
                key: navigatorKey,
                onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                    settings: settings,
                    builder: (BuildContext context) => const HomePage()
                  //MainPage
                ),
              ),
            ),
            PopScope(
              canPop: false,
              onPopInvokedWithResult: (bool didPop, result){
                // This can be async and you can check your condition
                final navigator = releaseNavigatorKey.currentState;
                final currentContext = releaseNavigatorKey.currentContext;
                if (navigator != null && navigator.canPop() && currentContext != null && _currentIndex == 1){
                  if (mounted) Navigator.of(currentContext).pop();
                }
              },
              child: Navigator(
                key: releaseNavigatorKey,
                onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                    settings: settings,
                    builder: (BuildContext context) => const NewReleasePage()
                  //MainPage
                ),
              ),
            ),
            PopScope(
                canPop: false,
                onPopInvokedWithResult: (bool didPop, result){
                  // This can be async and you can check your condition
                  final navigator = chartsNavigatorKey.currentState;
                  final currentContext = chartsNavigatorKey.currentContext;
                  if (navigator != null && navigator.canPop() && currentContext != null && _currentIndex == 2){
                    if (mounted) Navigator.of(currentContext).pop();
                  }
                },
                child: Navigator(
                  key: chartsNavigatorKey,
                  onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                      settings: settings,
                      builder: (BuildContext context) => const ChartsPage()
                    //MainPage
                  ),
                )
            ),
            PopScope(
              canPop: false,
              onPopInvokedWithResult: (bool didPop, result){
                // This can be async and you can check your condition
                final navigator = musicNavigatorKey.currentState;
                final currentContext = musicNavigatorKey.currentContext;
                if (navigator != null && navigator.canPop() && currentContext != null && _currentIndex == 1){
                  if (mounted) Navigator.of(currentContext).pop();
                }
              },
              child: Navigator(
                key: musicNavigatorKey,
                onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                    settings: settings,
                    builder: (BuildContext context) => const MusicSectionPage()
                  //MainPage
                ),
              ),
            ),
            PopScope(
              canPop: false,
              onPopInvokedWithResult: (bool didPop, result){
                // This can be async and you can check your condition
                final navigator = genresNavigatorKey.currentState;
                final currentContext = genresNavigatorKey.currentContext;
                if (navigator != null && navigator.canPop() && currentContext != null && _currentIndex == 1){
                  if (mounted) Navigator.of(currentContext).pop();
                }
              },
              child: Navigator(
                key: genresNavigatorKey,
                onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
                    settings: settings,
                    builder: (BuildContext context) => const MoodsAndGenresPage()
                  //MainPage
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
