import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:aro_movies_app/app/domain/entities/models/mdl_the_movie.dart';

import 'package:aro_movies_app/app/presentation/widgets/movie_card.dart';
import 'package:aro_movies_app/app/presentation/pages/home/home_page.dart';
import 'package:aro_movies_app/app/presentation/widgets/loading_grid.dart';
import 'package:aro_movies_app/app/presentation/providers/movies_provider.dart';
import 'package:aro_movies_app/app/presentation/providers/favorites_provider.dart';

import 'package:aro_movies_app/app/data/datasources/local/dts_user_pref.dart';
import 'package:aro_movies_app/app/data/datasources/local/favorites_service.dart';

void main() {
  Widget buildTestWidget(MockMoviesProvider provider) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MoviesProvider>.value(value: provider),
        ChangeNotifierProvider<FavoritesProvider>.value(
          value: MockFavoritesProvider(),
        ),
      ],
      child: const MaterialApp(home: HomePage()),
    );
  }

  testWidgets('renders AppBar title', (tester) async {
    final provider = MockMoviesProvider();
    await tester.pumpWidget(buildTestWidget(provider));
    expect(find.text('Películas Populares'), findsOneWidget);
  });

  testWidgets('shows LoadingGrid when loading', (tester) async {
    final provider = MockMoviesProvider();
    provider._isLoadingPopular = true;
    await tester.pumpWidget(buildTestWidget(provider));
    expect(find.byType(LoadingGrid), findsOneWidget);
  });

  testWidgets('shows error state and can retry', (tester) async {
    final provider = MockMoviesProvider();
    provider._popularError = 'Error de red';
    await tester.pumpWidget(buildTestWidget(provider));
    expect(find.text('Error de red'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    expect(provider.fetchCalled, true);
  });

  testWidgets('shows empty state', (tester) async {
    final provider = MockMoviesProvider();
    provider._popularMovies = [];
    await tester.pumpWidget(buildTestWidget(provider));
    expect(find.text('No se encontraron películas populares'), findsOneWidget);
  });

  testWidgets('shows grid of movies', (tester) async {
    final provider = MockMoviesProvider();
    provider._popularMovies = [
      TheMovie.empty().copyWith(id: 1, title: 'Movie 1'),
      TheMovie.empty().copyWith(id: 2, title: 'Movie 2'),
    ];
    await tester.pumpWidget(buildTestWidget(provider));
    expect(find.byType(MovieCard), findsNWidgets(2));
    expect(find.text('Movie 1'), findsOneWidget);
    expect(find.text('Movie 2'), findsOneWidget);
  });

  testWidgets('refreshes movies on pull', (tester) async {
    final provider = MockMoviesProvider();
    provider._popularMovies = [
      TheMovie.empty().copyWith(id: 1, title: 'Movie'),
    ];
    await tester.pumpWidget(buildTestWidget(provider));
    final gridFinder = find.byType(GridView);
    await tester.drag(gridFinder, const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(provider.refreshCalled, true);
  });
}

class MockMoviesProvider extends ChangeNotifier implements MoviesProvider {
  bool _isLoadingPopular = false;
  String? _popularError;
  List<TheMovie> _popularMovies = [];
  bool fetchCalled = false;
  bool refreshCalled = false;

  @override
  bool get isLoadingPopular => _isLoadingPopular;
  @override
  String? get popularError => _popularError;
  @override
  List<TheMovie> get popularMovies => _popularMovies;

  @override
  Future<void> fetchPopularMovies() async {
    fetchCalled = true;
  }

  @override
  Future<void> refreshPopularMovies() async {
    refreshCalled = true;
  }

  // Métodos no usados
  @override
  List<TheMovie> get searchResults => [];
  @override
  bool get isLoadingSearch => false;
  @override
  String? get searchError => null;
  @override
  String get searchQuery => '';
  @override
  Future<void> searchMovies(String query) async {}
  @override
  void clearSearch() {}
  @override
  TheMovie? getMovieById(int id) => null;
  @override
  bool get hasPopularMovies => _popularMovies.isNotEmpty;
  @override
  bool get hasSearchResults => false;
  @override
  void reset() {}
}

class _MockFavoritesService extends FavoritesService {
  _MockFavoritesService() : super(UserPref());
  @override
  Future<List<TheMovie>> getFavoriteMovies() async => [];
  @override
  Future<Set<int>> getFavoriteIds() async => {};
  @override
  Future<bool> addToFavorites(TheMovie movie) async => true;
  @override
  Future<bool> removeFromFavorites(int id) async => true;
  @override
  Future<bool> clearAllFavorites() async => true;
}

// Mock básico de FavoritesProvider
class MockFavoritesProvider extends FavoritesProvider {
  MockFavoritesProvider() : super(_MockFavoritesService());
  final Set<int> _ids = {};
  final List<TheMovie> _movies = [];
  @override
  List<TheMovie> get favoriteMovies => _movies;
  @override
  Set<int> get favoriteIds => _ids;
  @override
  bool isFavorite(int movieId) => _ids.contains(movieId);
  @override
  Future<bool> addToFavorites(TheMovie movie) async {
    _ids.add(movie.id);
    _movies.add(movie);
    notifyListeners();
    return true;
  }

  @override
  Future<bool> removeFromFavorites(int movieId) async {
    _ids.remove(movieId);
    _movies.removeWhere((m) => m.id == movieId);
    notifyListeners();
    return true;
  }

  @override
  Future<bool> toggleFavorite(TheMovie movie) async {
    if (isFavorite(movie.id)) {
      return await removeFromFavorites(movie.id);
    } else {
      return await addToFavorites(movie);
    }
  }

  @override
  Future<void> refreshFavorites() async {}
  @override
  Future<bool> clearAllFavorites() async {
    _ids.clear();
    _movies.clear();
    notifyListeners();
    return true;
  }

  @override
  TheMovie? getFavoriteById(int id) {
    try {
      return _movies.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  bool get isEmpty => _movies.isEmpty;
  @override
  bool get isNotEmpty => _movies.isNotEmpty;
  @override
  String? get error => null;
  @override
  int get favoritesCount => _movies.length;
  @override
  bool get isLoading => false;
  @override
  void clearError() {}
  @override
  Future<void> init() async {}
}
