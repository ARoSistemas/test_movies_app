import 'package:flutter/foundation.dart';

import '../../domain/entities/models/mdl_the_movie.dart';
import '../../data/datasources/local/favorites_service.dart';

/// Manages the state and logic for the user's favorite movies.
///
/// The `FavoritesProvider` is responsible for:
/// - Storing and updating the list of favorite movies.
/// - Adding, removing, toggling, and checking favorite status for movies.
/// - Persisting favorites using [FavoritesService].
/// - Notifying listeners when the state changes, enabling reactive UI updates.
/// - Handling loading, error, and empty states for favorites.
///
/// ### State
/// - `_favoriteMovies`: Internal list of favorite movies.
/// - `_favoriteIds`: Set of favorite movie IDs for quick lookup.
/// - `_isLoading`: Indicates if favorites are being loaded.
/// - `_error`: Stores error messages for UI feedback.
///
/// ### Getters
/// - `favoriteMovies`: List of favorite movies.
/// - `favoriteIds`: Set of favorite movie IDs.
/// - `isLoading`: Loading state.
/// - `error`: Error message, if any.
/// - `favoritesCount`: Number of favorite movies.
/// - `isEmpty` / `isNotEmpty`: Whether the favorites list is empty or not.
///
/// ### Methods
/// - [init]: Loads favorites from persistent storage.
/// - [addToFavorites]: Adds a movie to favorites.
/// - [removeFromFavorites]: Removes a movie from favorites.
/// - [toggleFavorite]: Toggles the favorite status of a movie.
/// - [clearAllFavorites]: Removes all favorites.
/// - [refreshFavorites]: Reloads favorites from storage.
/// - [getFavoriteById]: Retrieves a favorite movie by its ID.
/// - [clearError]: Clears any error message.
///
/// ### Usage
/// Use this provider in your app to manage and reactively update the user's favorite movies.
class FavoritesProvider with ChangeNotifier {
  /// Creates a `FavoritesProvider` instance.
  ///
  /// **Parameters:**
  /// - `_favoritesService` (FavoritesService): The service used to manage favorite movies.
  FavoritesProvider(this._favoritesService);

  /// The service used to manage favorite movies.
  final FavoritesService _favoritesService;

  // Favorites State
  List<TheMovie> _favoriteMovies = [];
  Set<int> _favoriteIds = <int>{};
  bool _isLoading = false;
  String? _error;

  // Getters
  List<TheMovie> get favoriteMovies => _favoriteMovies;
  Set<int> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get favoritesCount => _favoriteMovies.length;

  /// Initializes the provider by loading favorites from storage.
  Future<void> init() async {
    await _loadFavorites();
  }

  /// Load favorites from storage
  Future<void> _loadFavorites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _favoriteMovies = await _favoritesService.getFavoriteMovies();
      _favoriteIds = await _favoritesService.getFavoriteIds();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error al cargar favoritos: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Checks if a movie is marked as a favorite.
  ///
  /// **Parameters:**
  /// - `movieId` (int): The ID of the movie to check.
  ///
  /// **Returns:**
  /// - `true` if the movie is a favorite, `false` otherwise.
  bool isFavorite(int movieId) {
    return _favoriteIds.contains(movieId);
  }

  /// Adds a movie to the list of favorites.
  ///
  /// **Parameters:**
  /// - `movie` (TheMovie): The movie to add to favorites.
  ///
  /// **Returns:**
  /// - A `Future` that resolves to `true` if the movie was added successfully, or `false` otherwise.
  Future<bool> addToFavorites(TheMovie movie) async {
    try {
      final success = await _favoritesService.addToFavorites(movie);
      if (success) {
        _favoriteMovies.add(movie);
        _favoriteIds.add(movie.id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Error al agregar a favoritos: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Remove movie from favorites
  Future<bool> removeFromFavorites(int movieId) async {
    try {
      final success = await _favoritesService.removeFromFavorites(movieId);
      if (success) {
        _favoriteMovies.removeWhere((movie) => movie.id == movieId);
        _favoriteIds.remove(movieId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Error al remover de favoritos: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(TheMovie movie) async {
    if (isFavorite(movie.id)) {
      return await removeFromFavorites(movie.id);
    } else {
      return await addToFavorites(movie);
    }
  }

  /// Clear all favorites
  Future<bool> clearAllFavorites() async {
    try {
      final success = await _favoritesService.clearAllFavorites();
      if (success) {
        _favoriteMovies.clear();
        _favoriteIds.clear();
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Error al limpiar favoritos: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Refresh favorites from storage
  Future<void> refreshFavorites() async {
    await _loadFavorites();
  }

  /// Get favorite movie by ID
  TheMovie? getFavoriteById(int id) {
    try {
      return _favoriteMovies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if favorites list is empty
  bool get isEmpty => _favoriteMovies.isEmpty;
  bool get isNotEmpty => _favoriteMovies.isNotEmpty;

  /// Clear any error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
