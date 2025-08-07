// coverage:ignore-start

import '../entities/models/mdl_getlist_movies.dart';

/// Abstract class representing the API connection repository.
/// This class defines the methods required for interacting with the API.
///
/// **Purpose:**
/// - To serve as a contract for implementing API connection logic.
/// - Ensures consistency across different API implementations.
///
/// **Example Implementation:**
/// ```dart
/// class ApiConnRepositoryImpl implements ApiConnRepository {
///   @override
///   Future<GetListMovies> getPopularMovies() {
///     // Implementation here
///   }
///
///   @override
///   Future<GetListMovies> getSearchMovies(String query) {
///     // Implementation here
///   }
/// }
/// ```
abstract class ApiConnRepository {
  /// Fetches a list of popular movies from the API.
  ///
  /// **Returns:**
  /// - A `Future` that resolves to a `GetListMovies` object containing the list of popular movies.
  ///
  /// **Throws:**
  /// - `UnimplementedError` if the method is not implemented.
  Future<GetListMovies> getPopularMovies();

  /// Searches for movies based on a query string.
  ///
  /// **Parameters:**
  /// - `query` (String): The search term to query movies.
  ///
  /// **Returns:**
  /// - A `Future` that resolves to a `GetListMovies` object containing the search results.
  ///
  /// **Throws:**
  /// - `UnimplementedError` if the method is not implemented.
  Future<GetListMovies> getSearchMovies(String query);
}

// coverage:ignore-end
