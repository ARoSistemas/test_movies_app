import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home/home_page.dart';
import 'search/search_page.dart';
import 'favorites/favorites_page.dart';

import '../providers/movies_provider.dart';
import '../providers/favorites_provider.dart';

/// Main entry point for navigating between core pages of the app.
///
/// The `MainNavigationPage` widget provides a bottom navigation bar to switch between
/// the main sections: Popular Movies, Search, and Favorites. It manages navigation state
/// and initializes essential data providers on startup.
///
/// ### Features
/// - Displays a [BottomNavigationBar] with three tabs: Popular, Search, and Favorites.
/// - Loads initial data for movies and favorites when the widget is first built.
/// - Shows a badge on the Favorites tab with the count of favorite movies.
/// - Handles tab switching and page rendering for each section.
///
/// ### State and Providers
/// - Uses [MoviesProvider] to fetch and display popular movies.
/// - Uses [FavoritesProvider] to manage and display favorite movies.
/// - Maintains the current tab index in local state.
///
/// ### Methods
/// - [_loadInitialData]: Loads movies and initializes favorites on startup.
/// - [_getPage]: Returns the widget for the selected tab.
/// - [_onTabTapped]: Updates the current tab index when a tab is selected.
/// - [build]: Builds the widget tree, including navigation and page content.
///
/// ### Usage
/// Use this widget as the main page of the app to provide seamless navigation between core sections.
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    // Load popular movies
    context.read<MoviesProvider>().fetchPopularMovies();

    // Initialize favorites
    context.read<FavoritesProvider>().init();
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const SearchPage();
      case 2:
        return const FavoritesPage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.movie),
            activeIcon: const Icon(Icons.movie),
            label: 'Popular',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            activeIcon: const Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) {
                return Badge(
                  isLabelVisible: favoritesProvider.favoritesCount > 0,
                  label: Text(favoritesProvider.favoritesCount.toString()),
                  child: const Icon(Icons.favorite),
                );
              },
            ),
            activeIcon: Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) {
                return Badge(
                  isLabelVisible: favoritesProvider.favoritesCount > 0,
                  label: Text(favoritesProvider.favoritesCount.toString()),
                  child: const Icon(Icons.favorite),
                );
              },
            ),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
