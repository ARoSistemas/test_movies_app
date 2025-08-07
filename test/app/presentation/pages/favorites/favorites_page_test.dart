import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:aro_movies_app/app/presentation/widgets/movie_card.dart';
import 'package:aro_movies_app/app/domain/entities/models/mdl_the_movie.dart';
import 'package:aro_movies_app/app/presentation/providers/favorites_provider.dart';
import 'package:aro_movies_app/app/presentation/pages/favorites/favorites_page.dart';

void main() {
  Widget buildTestWidget(MockFavoritesProvider provider) {
    return ChangeNotifierProvider<FavoritesProvider>.value(
      value: provider,
      child: const MaterialApp(home: FavoritesPage()),
    );
  }

  testWidgets('renders AppBar title', (tester) async {
    final provider = MockFavoritesProvider();
    await tester.pumpWidget(buildTestWidget(provider));
    expect(find.text('Favoritos'), findsOneWidget);
  });

  testWidgets('shows loading indicator', (tester) async {
    final provider = MockFavoritesProvider();
    provider._isLoading = true;
    await tester.pumpWidget(buildTestWidget(provider));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error and can retry', (tester) async {
    final provider = MockFavoritesProvider();
    provider._error = 'Error de red';
    await tester.pumpWidget(buildTestWidget(provider));
    expect(find.text('Error de red'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.tap(find.byType(ElevatedButton));
    expect(provider.refreshCalled, true);
  });

  testWidgets('shows empty state', (tester) async {
    final provider = MockFavoritesProvider();
    provider._favoriteMovies = [];
    await tester.pumpWidget(buildTestWidget(provider));
    expect(find.text('No tienes favoritos aún'), findsOneWidget);
    expect(
      find.text('Explora películas y agrega las que más te gusten'),
      findsOneWidget,
    );
  });

  testWidgets('shows grid of favorite movies', (tester) async {
    final provider = MockFavoritesProvider();
    provider._favoriteMovies = [
      TheMovie.empty().copyWith(id: 1, title: 'Movie 1'),
      TheMovie.empty().copyWith(id: 2, title: 'Movie 2'),
    ];
    await tester.pumpWidget(buildTestWidget(provider));
    expect(find.byType(MovieCard), findsNWidgets(2));
    expect(find.text('Movie 1'), findsOneWidget);
    expect(find.text('Movie 2'), findsOneWidget);
  });

  testWidgets('shows clear all dialog and clears favorites', (tester) async {
    final provider = MockFavoritesProvider();
    provider._favoriteMovies = [
      TheMovie.empty().copyWith(id: 1, title: 'Movie'),
    ];
    await tester.pumpWidget(buildTestWidget(provider));
    await tester.tap(find.byIcon(Icons.delete_sweep));
    await tester.pumpAndSettle();
    expect(
      find.text('¿Estás seguro de que quieres eliminar todos los favoritos?'),
      findsOneWidget,
    );
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(provider.clearCalled, true);
    expect(provider._favoriteMovies, isEmpty);
  });

  testWidgets('cancel clear all dialog closes the dialog', (tester) async {
    final provider = MockFavoritesProvider();
    provider._favoriteMovies = [
      TheMovie.empty().copyWith(id: 1, title: 'Movie'),
    ];
    await tester.pumpWidget(buildTestWidget(provider));
    await tester.tap(find.byIcon(Icons.delete_sweep));
    await tester.pumpAndSettle();
    expect(
      find.text('¿Estás seguro de que quieres eliminar todos los favoritos?'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(
      find.text('¿Estás seguro de que quieres eliminar todos los favoritos?'),
      findsNothing,
    );
    expect(provider.clearCalled, false);
  });
}

class MockFavoritesProvider extends ChangeNotifier
    implements FavoritesProvider {
  bool _isLoading = false;
  String? _error;
  List<TheMovie> _favoriteMovies = [];
  bool clearCalled = false;
  bool refreshCalled = false;

  @override
  List<TheMovie> get favoriteMovies => _favoriteMovies;
  @override
  bool get isLoading => _isLoading;
  @override
  String? get error => _error;
  @override
  bool get isEmpty => _favoriteMovies.isEmpty;
  @override
  bool get isNotEmpty => _favoriteMovies.isNotEmpty;
  @override
  int get favoritesCount => _favoriteMovies.length;
  @override
  Set<int> get favoriteIds => _favoriteMovies.map((m) => m.id).toSet();
  @override
  bool isFavorite(int movieId) => favoriteIds.contains(movieId);
  @override
  Future<bool> addToFavorites(TheMovie movie) async {
    _favoriteMovies.add(movie);
    notifyListeners();
    return true;
  }

  @override
  Future<bool> removeFromFavorites(int movieId) async {
    _favoriteMovies.removeWhere((m) => m.id == movieId);
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
  Future<void> refreshFavorites() async {
    refreshCalled = true;
  }

  @override
  Future<bool> clearAllFavorites() async {
    clearCalled = true;
    _favoriteMovies.clear();
    notifyListeners();
    return true;
  }

  @override
  TheMovie? getFavoriteById(int id) {
    try {
      return _favoriteMovies.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  Future<void> init() async {}
}
