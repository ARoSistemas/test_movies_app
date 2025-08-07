import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:aro_movies_app/app/data/datasources/local/dts_user_pref.dart';
import 'package:aro_movies_app/app/domain/entities/models/mdl_the_movie.dart';
import 'package:aro_movies_app/app/data/datasources/local/favorites_service.dart';

void main() {
  late UserPref userPref;

  late FavoritesService service;
  TheMovie movie = TheMovie.empty();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    userPref = UserPref();
    await userPref.initPrefs();

    service = FavoritesService(userPref);
    movie = movie.copyWith(id: 1, title: 'Test Movie');
  });

  test('getFavoriteMovies returns list of movies', () async {
    final movieJson = json.encode(movie.toMap());
    userPref.favorites = [movieJson];

    final result = await service.getFavoriteMovies();
    expect(result.length, 1);
    expect(result.first.id, movie.id);
  });

  test('addToFavorites adds a movie', () async {
    userPref.favorites = [];
    final resultTrue = await service.addToFavorites(
      movie.copyWith(adult: false, overview: 'Test Overview'),
    );
    expect(resultTrue, true);
  });

  test('addToFavorites does not add duplicate', () async {
    final List<String> favoritesJson = [
      movie,
    ].map((movie) => json.encode(movie.toMap())).toList();

    userPref.favorites = favoritesJson;
    final resultFalse = await service.addToFavorites(movie);

    expect(resultFalse, false);
  });

  test('removeFromFavorites removes a movie', () async {
    final String movieJson = json.encode(movie.toMap());
    userPref.favorites = [movieJson];

    final result = await service.removeFromFavorites(movie.id);
    expect(result, true);
  });

  test('isFavorite returns true if movie is favorite', () async {
    final movieJson = json.encode(movie.toMap());
    userPref.favorites = [movieJson];
    final result = await service.isFavorite(movie.id);
    expect(result, true);
  });

  test('toggleFavorite adds and removes movie', () async {
    userPref.favorites = [];
    final addResult = await service.toggleFavorite(movie);
    expect(addResult, true);
    userPref.favorites = [json.encode(movie.toMap())];
    final removeResult = await service.toggleFavorite(movie);
    expect(removeResult, true);
  });

  test('getFavoritesCount returns correct count', () async {
    final movieJson = json.encode(movie.toMap());
    userPref.favorites = [movieJson];
    final count = await service.getFavoritesCount();
    expect(count, 1);
  });

  test('clearAllFavorites removes all', () async {
    userPref.favorites = [];
    final result = await service.clearAllFavorites();
    expect(result, true);
    expect(userPref.favorites, []);
  });

  test('getFavoriteIds returns set of ids', () async {
    final movieJson = json.encode(movie.toMap());
    userPref.favorites = [movieJson];
    final ids = await service.getFavoriteIds();
    expect(ids, contains(movie.id));
  });

  test('getFavorite with a catch error', () async {
    userPref.favorites = ["-"];
    final ids = await service.getFavoriteMovies();
    expect(ids, isEmpty);
  });
}
