import 'package:flutter/foundation.dart';
import '../../domain/entities/models/mdl_the_movie.dart';
import '../../domain/repositories/repository_api_conn.dart';

/// Manages the state and logic for popular movies and search results.
///
/// The `MoviesProvider` is responsible for:
/// - Fetching and storing popular movies from the API.
/// - Searching movies by query and managing search results.
/// - Handling loading, error, and empty states for both popular and search movies.
/// - Providing methods to refresh, reset, and access movies by ID.
/// - Notifying listeners to enable reactive UI updates.
///
/// ### State
/// - `_popularMovies`: Internal list of popular movies.
/// - `_isLoadingPopular`: Indicates if popular movies are being loaded.
/// - `_popularError`: Stores error messages for popular movies.
/// - `_searchResults`: Internal list of search results.
/// - `_isLoadingSearch`: Indicates if search results are being loaded.
/// - `_searchError`: Stores error messages for search.
/// - `_searchQuery`: Current search query string.
///
/// ### Getters
/// - `popularMovies`: List of popular movies.
/// - `isLoadingPopular`: Loading state for popular movies.
/// - `popularError`: Error message for popular movies.
/// - `searchResults`: List of search results.
/// - `isLoadingSearch`: Loading state for search.
/// - `searchError`: Error message for search.
/// - `searchQuery`: Current search query.
/// - `hasPopularMovies`: Whether there are popular movies loaded.
/// - `hasSearchResults`: Whether there are search results loaded.
///
/// ### Methods
/// - [fetchPopularMovies]: Loads popular movies from the API.
/// - [searchMovies]: Searches movies by query.
/// - [clearSearch]: Clears search results and state.
/// - [refreshPopularMovies]: Reloads popular movies.
/// - [getMovieById]: Retrieves a movie by its ID from either list.
/// - [reset]: Resets all movie-related state.
///
/// ### Usage
/// Use this provider to manage and reactively update movie data in your app, including popular and search results.
class MoviesProvider with ChangeNotifier {
  MoviesProvider(this._apiRepository);

  final ApiConnRepository _apiRepository;

  // Popular Movies State
  List<TheMovie> _popularMovies = [];
  bool _isLoadingPopular = false;
  String? _popularError;

  // Search Movies State
  List<TheMovie> _searchResults = [];
  bool _isLoadingSearch = false;
  String? _searchError;
  String _searchQuery = '';

  // Getters for Popular Movies
  List<TheMovie> get popularMovies => _popularMovies;
  bool get isLoadingPopular => _isLoadingPopular;
  String? get popularError => _popularError;

  // Getters for Search
  List<TheMovie> get searchResults => _searchResults;
  bool get isLoadingSearch => _isLoadingSearch;
  String? get searchError => _searchError;
  String get searchQuery => _searchQuery;

  /// Fetch popular movies
  ///
  /// **Description:**
  /// - Makes a request to the API to fetch popular movies.
  /// - Updates the state with the results or an error in case of failure.
  ///
  /// **Errors:**
  /// - Sets an error message in `_popularError` if a problem occurs.
  Future<void> fetchPopularMovies() async {
    _isLoadingPopular = true;
    _popularError = null;
    notifyListeners();

    try {
      final result = await _apiRepository.getPopularMovies();
      _popularMovies = result.results;
      _isLoadingPopular = false;
      notifyListeners();
    } catch (e) {
      _isLoadingPopular = false;
      _popularError = 'Error loading popular movies: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Search movies by query
  ///
  /// **Parameters:**
  /// - `query` (String): The search term to query movies.
  ///
  /// **Description:**
  /// - Makes a request to the API to search for movies matching the query.
  /// - Updates the state with the results or an error in case of failure.
  ///
  /// **Errors:**
  /// - Sets an error message in `_searchError` if a problem occurs.
  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      _clearSearchResults();
      return;
    }

    _searchQuery = query;
    _isLoadingSearch = true;
    _searchError = null;
    notifyListeners();

    try {
      final result = await _apiRepository.getSearchMovies(query);
      _searchResults = result.results;
      _isLoadingSearch = false;
      notifyListeners();
    } catch (e) {
      _isLoadingSearch = false;
      _searchError = 'Error searching movies: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Clears the search results.
  ///
  /// **Description:**
  /// - Resets the search results and related state.
  void _clearSearchResults() {
    _searchResults = [];
    _searchQuery = '';
    _searchError = null;
    notifyListeners();
  }

  /// Clears the current search.
  ///
  /// **Description:**
  /// - Calls `_clearSearchResults` to reset the search state.
  void clearSearch() {
    _clearSearchResults();
  }

  /// Refreshes the popular movies.
  ///
  /// **Description:**
  /// - Calls `fetchPopularMovies` to update the popular movies.
  Future<void> refreshPopularMovies() async {
    await fetchPopularMovies();
  }

  /// Gets a movie by its ID.
  ///
  /// **Parameters:**
  /// - `id` (int): The ID of the movie to search for.
  ///
  /// **Description:**
  /// - Searches for the movie in the popular list or in the search results.
  /// - Returns `null` if not found.
  TheMovie? getMovieById(int id) {
    // Try to find in popular movies first
    try {
      return _popularMovies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      // If not found in popular, try in search results
      try {
        return _searchResults.firstWhere((movie) => movie.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  /// Checks if there are any loaded movies.
  ///
  /// **Description:**
  /// - Checks if there are any popular movies or search results available.
  bool get hasPopularMovies => _popularMovies.isNotEmpty;
  bool get hasSearchResults => _searchResults.isNotEmpty;

  /// Resets the entire state.
  ///
  /// **Description:**
  /// - Resets all the lists and states related to movies.
  void reset() {
    _popularMovies = [];
    _isLoadingPopular = false;
    _popularError = null;
    _searchResults = [];
    _isLoadingSearch = false;
    _searchError = null;
    _searchQuery = '';
    notifyListeners();
  }
}
