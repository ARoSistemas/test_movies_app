import 'dart:convert';

import 'dts_user_pref.dart';

import '../../../domain/entities/models/mdl_the_movie.dart';

/// Service for managing favorite movies using [SharedPreferences].
///
/// The [FavoritesService] class provides methods to store, retrieve, and manage favorite movies locally.
/// Movies are persisted as JSON strings in [SharedPreferences] via [UserPref].
///
/// ### Usage
/// Create an instance by passing a [UserPref] object, then use the provided methods to manage favorites.
///
/// ### Methods
/// - [getFavoriteMovies]: Returns all favorite movies as a list of [TheMovie].
/// - [addToFavorites]: Adds a movie to favorites.
/// - [removeFromFavorites]: Removes a movie from favorites by ID.
/// - [isFavorite]: Checks if a movie is in favorites.
/// - [toggleFavorite]: Adds or removes a movie depending on its current state.
/// - [getFavoritesCount]: Returns the count of favorite movies.
/// - [clearAllFavorites]: Removes all favorites.
/// - [getFavoriteIds]: Returns a set of favorite movie IDs.
///
/// ### Example
/// ```dart
/// final service = FavoritesService(UserPref());
/// await service.addToFavorites(movie);
/// final favorites = await service.getFavoriteMovies();
/// print(favorites.length);
/// ```
class FavoritesService {
  FavoritesService(this._userPref);

  /// SharedPreferences instance
  final UserPref _userPref;

  /// Key for storing favorite movies in SharedPreferences
  static const String _favoritesKey = 'favorite_movies';

  /// Get all favorite movies.
  ///
  /// **Returns:**
  /// - A `Future` that resolves to a list of `TheMovie` objects.
  Future<List<TheMovie>> getFavoriteMovies() async {
    try {
      final List<String> favoritesJson = _userPref.favorites;

      return favoritesJson
          .map((movieJson) => TheMovie.fromRaw(movieJson))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  /// Add a movie to favorites.
  ///
  /// **Parameters:**
  /// - `movie` (TheMovie): The movie to add to favorites.
  ///
  /// **Returns:**
  /// - A `Future` that resolves to `true` if the movie was added successfully, or `false` if it was already in favorites.
  Future<bool> addToFavorites(TheMovie movie) async {
    try {
      final List<TheMovie> favorites = await getFavoriteMovies();

      /// Check if movie is already in favorites
      if (favorites.any((favMovie) => favMovie.id == movie.id)) {
        return false; // Already in favorites
      }

      /// Add movie to favorites
      favorites.add(movie);
      await _saveFavorites(favorites);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove a movie from favorites.
  ///
  /// **Parameters:**
  /// - `movieId` (int): The ID of the movie to remove.
  ///
  /// **Returns:**
  /// - A `Future` that resolves to `true` if the movie was removed successfully, or `false` otherwise.
  Future<bool> removeFromFavorites(int movieId) async {
    try {
      final List<TheMovie> favorites = await getFavoriteMovies();

      /// Remove movie with matching ID
      favorites.removeWhere((movie) => movie.id == movieId);
      await _saveFavorites(favorites);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if a movie is in favorites.
  ///
  /// **Parameters:**
  /// - `movieId` (int): The ID of the movie to check.
  ///
  /// **Returns:**
  /// - A `Future` that resolves to `true` if the movie is in favorites, or `false` otherwise.
  Future<bool> isFavorite(int movieId) async {
    try {
      final List<TheMovie> favorites = await getFavoriteMovies();
      return favorites.any((movie) => movie.id == movieId);
    } catch (e) {
      return false;
    }
  }

  /// Toggle favorite status of a movie.
  ///
  /// **Parameters:**
  /// - `movie` (TheMovie): The movie to toggle.
  ///
  /// **Returns:**
  /// - A `Future` that resolves to `true` if the movie was added to favorites, or `false` if it was removed.
  Future<bool> toggleFavorite(TheMovie movie) async {
    final bool isCurrentlyFavorite = await isFavorite(movie.id);

    if (isCurrentlyFavorite) {
      return await removeFromFavorites(movie.id);
    } else {
      return await addToFavorites(movie);
    }
  }

  /// Get count of favorite movies.
  ///
  /// **Returns:**
  /// - A `Future` that resolves to the count of favorite movies.
  Future<int> getFavoritesCount() async {
    final List<TheMovie> favorites = await getFavoriteMovies();
    return favorites.length;
  }

  /// Clear all favorites.
  ///
  /// **Returns:**
  /// - A `Future` that resolves to `true` if all favorites were cleared successfully, or `false` otherwise.
  Future<bool> clearAllFavorites() async {
    try {
      _userPref.favorites = [];
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Private method to save favorites list to SharedPreferences.
  ///
  /// **Parameters:**
  /// - `favorites` (List<TheMovie>): The list of favorite movies to save.
  Future<void> _saveFavorites(List<TheMovie> favorites) async {
    final List<String> favoritesJson = favorites
        .map((movie) => json.encode(movie.toMap()))
        .toList();

    _userPref.favorites = favoritesJson;
  }

  /// Get favorite movie IDs only (for quick checks).
  ///
  /// **Returns:**
  /// - A `Future` that resolves to a `Set` of movie IDs.
  Future<Set<int>> getFavoriteIds() async {
    try {
      final List<TheMovie> favorites = await getFavoriteMovies();
      return favorites.map((movie) => movie.id).toSet();
    } catch (e) {
      return <int>{};
    }
  }
}
