import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aro_movies_app/app/data/datasources/local/dts_user_pref.dart';
import 'package:aro_movies_app/app/domain/entities/models/mdl_the_movie.dart';
import 'package:aro_movies_app/app/data/datasources/local/favorites_service.dart';
import 'package:aro_movies_app/app/presentation/providers/favorites_provider.dart';

class MockFavoritesService implements FavoritesService {
  List<TheMovie> movies = [];
  Set<int> ids = {};
  bool throwOnLoad = false;
  bool throwOnRemove = false;
  bool throwOnClear = false;
  bool shouldThrow = false;

  @override
  Future<List<TheMovie>> getFavoriteMovies() async {
    if (throwOnLoad) throw Exception('load error');
    return movies;
  }

  @override
  Future<Set<int>> getFavoriteIds() async {
    if (throwOnLoad) throw Exception('load error');
    return ids;
  }

  @override
  Future<bool> addToFavorites(TheMovie movie) async {
    if (shouldThrow) throw Exception('add error');
    if (ids.contains(movie.id)) return false;
    movies.add(movie);
    ids.add(movie.id);
    return true;
  }

  @override
  Future<bool> removeFromFavorites(int movieId) async {
    if (throwOnRemove) throw Exception('remove error');
    movies.removeWhere((m) => m.id == movieId);
    ids.remove(movieId);
    return true;
  }

  @override
  Future<bool> clearAllFavorites() async {
    if (throwOnClear) throw Exception('clear error');
    movies.clear();
    ids.clear();
    return true;
  }

  // Métodos no usados en los tests
  @override
  Future<bool> isFavorite(int movieId) async => ids.contains(movieId);
  @override
  Future<bool> toggleFavorite(TheMovie movie) async => true;
  @override
  Future<int> getFavoritesCount() async => movies.length;
}

void main() {
  late UserPref userPref;
  late MockFavoritesService mockService;
  late FavoritesProvider provider;
  late TheMovie movie;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    userPref = UserPref();
    await userPref.initPrefs();

    mockService = MockFavoritesService();

    provider = FavoritesProvider(mockService);
    movie = TheMovie.empty().copyWith(id: 1, title: 'Test Movie');
  });

  test('init loads favorites', () async {
    mockService.movies = [movie];
    mockService.ids = {movie.id};
    await provider.init();
    expect(provider.favoriteMovies, [movie]);
    expect(provider.favoriteIds, contains(movie.id));
    expect(provider.isLoading, false);
    expect(provider.error, isNull);
  });

  test('addToFavorites adds a movie', () async {
    final result = await provider.addToFavorites(movie);
    expect(result, true);
    expect(provider.favoriteMovies, contains(movie));
    expect(provider.favoriteIds, contains(movie.id));
  });

  test('removeFromFavorites removes a movie', () async {
    provider.favoriteMovies.add(movie);
    provider.favoriteIds.add(movie.id);
    final result = await provider.removeFromFavorites(movie.id);
    expect(result, true);
    expect(provider.favoriteMovies, isNot(contains(movie)));
    expect(provider.favoriteIds, isNot(contains(movie.id)));
  });

  test('toggleFavorite toggles favorite status', () async {
    final addResult = await provider.toggleFavorite(movie);
    expect(addResult, true);
    expect(provider.isFavorite(movie.id), true);
    final removeResult = await provider.toggleFavorite(movie);
    expect(removeResult, true);
    expect(provider.isFavorite(movie.id), false);
  });

  test('clearAllFavorites clears all', () async {
    provider.favoriteMovies.add(movie);
    provider.favoriteIds.add(movie.id);
    final result = await provider.clearAllFavorites();
    expect(result, true);
    expect(provider.favoriteMovies, isEmpty);
    expect(provider.favoriteIds, isEmpty);
  });

  test('getFavoriteById returns correct movie', () {
    provider.favoriteMovies.add(movie);
    final result = provider.getFavoriteById(movie.id);
    expect(result, movie);
  });

  test('isEmpty and isNotEmpty work as expected', () {
    expect(provider.isEmpty, true);
    provider.favoriteMovies.add(movie);
    expect(provider.isNotEmpty, true);
  });

  test('clearError sets error to null', () async {
    mockService.shouldThrow = true;
    await provider.addToFavorites(movie);
    expect(provider.error, isNotNull);
    provider.clearError();
    expect(provider.error, isNull);
  });

  test('favoritesCount returns correct value', () {
    expect(provider.favoritesCount, 0);
    provider.favoriteMovies.add(movie);
    expect(provider.favoritesCount, 1);
  });

  test('error al cargar favoritos se asigna correctamente', () async {
    mockService.throwOnLoad = true;
    await provider.init();
    expect(provider.error, contains('Error al cargar favoritos'));
    expect(provider.isLoading, false);
  });

  test('error al remover de favoritos se asigna correctamente', () async {
    mockService.throwOnRemove = true;
    final result = await provider.removeFromFavorites(movie.id);
    expect(result, false);
    expect(provider.error, contains('Error al remover de favoritos'));
  });

  test('error al limpiar favoritos se asigna correctamente', () async {
    mockService.throwOnClear = true;
    final result = await provider.clearAllFavorites();
    expect(result, false);
    expect(provider.error, contains('Error al limpiar favoritos'));
  });

  test('refreshFavorites llama a _loadFavorites', () async {
    mockService.movies = [movie];
    mockService.ids = {movie.id};
    await provider.refreshFavorites();
    expect(provider.favoriteMovies, [movie]);
    expect(provider.favoriteIds, contains(movie.id));
  });
}
