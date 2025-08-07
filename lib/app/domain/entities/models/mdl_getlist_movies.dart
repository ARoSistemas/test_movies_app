import 'dart:convert';

import 'mdl_the_movie.dart';

/// Represents a paginated list of movies fetched from the API.
///
/// The [GetListMovies] class contains pagination information and a list of [TheMovie] objects.
/// It is used to handle the response from the API when fetching popular or searched movies.
///
/// ### Properties
/// - [page]: The current page number.
/// - [results]: The list of movies ([TheMovie]) for the current page.
/// - [totalPages]: The total number of pages available.
/// - [totalResults]: The total number of results available.
///
/// ### Methods
/// - [copyWith]: Returns a copy of the instance with modified values.
/// - [fromRaw]: Creates an instance from a raw JSON string.
/// - [fromMap]: Creates an instance from a JSON map.
/// - [empty]: Creates an empty instance.
/// - [toMap]: Converts the instance to a JSON map.
///
/// ### Example
/// ```dart
/// final movies = GetListMovies.fromRaw(jsonString);
/// print(movies.results.length);
/// ```
class GetListMovies {
  /// Creates an instance of `GetListMovies`.
  ///
  /// **Parameters:**
  /// - `page` (int): The current page number.
  /// - `results` (List<TheMovie>): The list of movies.
  /// - `totalPages` (int): The total number of pages available.
  /// - `totalResults` (int): The total number of results available.
  GetListMovies({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<TheMovie> results;
  int totalPages;
  int totalResults;

  /// Creates a copy of the current `GetListMovies` instance with optional modifications.
  ///
  /// **Parameters:**
  /// - `page` (int?): The new page number.
  /// - `results` (List<TheMovie>?): The new list of movies.
  /// - `totalPages` (int?): The new total number of pages.
  /// - `totalResults` (int?): The new total number of results.
  ///
  /// **Returns:**
  /// - A new `GetListMovies` instance with the updated values.
  GetListMovies copyWith({
    int? page,
    List<TheMovie>? results,
    int? totalPages,
    int? totalResults,
  }) => GetListMovies(
    page: page ?? this.page,
    results: results ?? this.results,
    totalPages: totalPages ?? this.totalPages,
    totalResults: totalResults ?? this.totalResults,
  );

  /// Creates a `GetListMovies` instance from a raw JSON string.
  ///
  /// **Parameters:**
  /// - `str` (String): The raw JSON string.
  ///
  /// **Returns:**
  /// - A `GetListMovies` instance parsed from the JSON string.
  factory GetListMovies.fromRaw(String str) =>
      GetListMovies.fromMap(json.decode(str));

  /// Creates a `GetListMovies` instance from a JSON map.
  ///
  /// **Parameters:**
  /// - `json` (Map<String, dynamic>): The JSON map.
  ///
  /// **Returns:**
  /// - A `GetListMovies` instance parsed from the JSON map.
  factory GetListMovies.fromMap(Map<String, dynamic> json) => GetListMovies(
    page: json["page"] ?? 0,
    results: List<TheMovie>.from(
      (json["results"] ?? []).map((x) => TheMovie.fromMap(x)),
    ),
    totalPages: json["total_pages"] ?? 0,
    totalResults: json["total_results"] ?? 0,
  );

  /// Creates an empty `GetListMovies` instance.
  ///
  /// **Returns:**
  /// - A `GetListMovies` instance with default values.
  factory GetListMovies.empty() =>
      GetListMovies(page: 0, results: [], totalPages: 0, totalResults: 0);

  /// Converts the `GetListMovies` instance to a JSON map.
  ///
  /// **Returns:**
  /// - A `Map<String, dynamic>` representing the `GetListMovies` instance.
  Map<String, dynamic> toMap() => {
    "page": page,
    "results": results.map((x) => x.toMap()).toList(),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}
