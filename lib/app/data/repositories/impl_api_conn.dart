import 'dart:convert';

import '../../config/constans/app_env.dart';
import '../../domain/repositories/repository_api_conn.dart';
import '../../domain/entities/models/mdl_getlist_movies.dart';

import '../../../core/network/aro_result.dart';
import '../../../core/network/dts_api_call.dart';
import '../../../core/errors/dts_http_failure.dart';
import '../../../core/network/mdl_api_success.dart';

/// Implementation of [ApiConnRepository] for API communication.
///
/// The [APIConnImpl] class handles API requests to fetch popular movies and search for movies using the provided query string.
/// It uses the [ApiCall] service to make HTTP requests and parse the responses into [GetListMovies] objects.
///
/// ### Usage
/// Create an instance by passing an [ApiCall] object, then use the provided methods to fetch or search movies.
///
/// ### Methods
/// - [getPopularMovies]: Fetches a list of popular movies from the API.
/// - [getSearchMovies]: Searches for movies based on a query string.
///
/// ### Example
/// ```dart
/// final apiConn = APIConnImpl(apiCall);
/// final popular = await apiConn.getPopularMovies();
/// final search = await apiConn.getSearchMovies('batman');
/// ```
class APIConnImpl implements ApiConnRepository {
  APIConnImpl(this._apiCall);

  /// Creates an instance of `APIConnImpl` with the provided `ApiCall` instance.
  ///
  /// **Parameters:**
  /// - `_apiCall` (ApiCall): The service used to make API requests.

  final ApiCall _apiCall;

  @override
  /// Fetches a list of popular movies from the API.
  ///
  /// **Returns:**
  /// - A `Future` that resolves to a `GetListMovies` object containing the list of popular movies.
  /// - Returns an empty list if the request fails or if there are no movies.
  Future<GetListMovies> getPopularMovies() async {
    /// Fetches popular movies from the API.
    /// This method sends a request to the API endpoint for popular movies and returns a list of movies.
    /// Returns an empty list if the request fails or if there are no movies.
    ARoResult<ApiFailure, ApiSuccess> response = await _apiCall.request(
      endpoint: epPopularMovies,
      body: json.encode({"type": ''}),
      epName: 'Response for get Popular Movies,',
    );

    if (response.isFailure) {
      return GetListMovies.empty();
    } else {
      return GetListMovies.fromRaw(response.success!.data);
    }
  }

  @override
  /// Searches for movies based on the provided query string.
  ///
  /// **Parameters:**
  /// - `query` (String): The search term to query movies.
  ///
  /// **Returns:**
  /// - A `Future` that resolves to a `GetListMovies` object containing the search results.
  /// - Returns an empty list if the request fails or if there are no movies.
  Future<GetListMovies> getSearchMovies(String query) async {
    /// Searches for movies based on the provided query.
    /// This method sends a request to the API endpoint for searching movies and returns a list of movies.
    /// Returns an empty list if the request fails or if there are no movies.
    ARoResult<ApiFailure, ApiSuccess> response = await _apiCall.request(
      endpoint: '$epSearchMovies$query',
      body: json.encode({"type": ''}),
      epName: 'Response for get search movie,',
    );

    if (response.isFailure) {
      return GetListMovies.empty();
    } else {
      return GetListMovies.fromRaw(response.success!.data);
    }
  }
}
