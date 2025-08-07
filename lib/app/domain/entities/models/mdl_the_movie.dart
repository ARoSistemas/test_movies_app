import 'dart:convert';

/// Represents a movie entity with all its attributes.
///
/// The [TheMovie] class is used to handle movie data, including parsing from JSON, converting to JSON, and creating copies with modified values.
///
/// ### Properties
/// - [adult]: Indicates if the movie is for adults.
/// - [backdropPath]: Path to the movie's backdrop image.
/// - [genreIds]: List of genre IDs associated with the movie.
/// - [id]: Unique identifier for the movie.
/// - [originalLanguage]: Original language of the movie.
/// - [originalTitle]: Original title of the movie.
/// - [overview]: Brief description of the movie.
/// - [popularity]: Popularity score of the movie.
/// - [posterPath]: Path to the movie's poster image.
/// - [releaseDate]: Release date of the movie.
/// - [title]: Title of the movie.
/// - [video]: Indicates if the movie has a video.
/// - [voteAverage]: Average vote score for the movie.
/// - [voteCount]: Total number of votes for the movie.
///
/// ### Methods
/// - [copyWith]: Returns a copy of the instance with modified values.
/// - [fromRaw]: Creates an instance from a raw JSON string.
/// - [fromMap]: Creates an instance from a JSON map.
/// - [empty]: Creates an empty instance with default values.
/// - [toMap]: Converts the instance to a JSON map.
///
/// ### Example
/// ```dart
/// final movie = TheMovie.fromRaw(jsonString);
/// print(movie.title);
/// ```
class TheMovie {
  /// Creates an instance of `TheMovie`.
  ///
  /// **Parameters:**
  /// - `adult` (bool): Indicates if the movie is for adults.
  /// - `backdropPath` (String): The path to the movie's backdrop image.
  /// - `genreIds` (List<int>): A list of genre IDs associated with the movie.
  /// - `id` (int): The unique identifier for the movie.
  /// - `originalLanguage` (String): The original language of the movie.
  /// - `originalTitle` (String): The original title of the movie.
  /// - `overview` (String): A brief description of the movie.
  /// - `popularity` (double): The popularity score of the movie.
  /// - `posterPath` (String): The path to the movie's poster image.
  /// - `releaseDate` (String): The release date of the movie.
  /// - `title` (String): The title of the movie.
  /// - `video` (bool): Indicates if the movie has a video.
  /// - `voteAverage` (double): The average vote score for the movie.
  /// - `voteCount` (int): The total number of votes for the movie.
  TheMovie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage;
  int voteCount;

  /// Creates a copy of the current `TheMovie` instance with optional modifications.
  ///
  /// **Parameters:**
  /// - `adult` (bool?): The new value for `adult`.
  /// - `backdropPath` (String?): The new value for `backdropPath`.
  /// - `genreIds` (List<int>?): The new value for `genreIds`.
  /// - `id` (int?): The new value for `id`.
  /// - `originalLanguage` (String?): The new value for `originalLanguage`.
  /// - `originalTitle` (String?): The new value for `originalTitle`.
  /// - `overview` (String?): The new value for `overview`.
  /// - `popularity` (double?): The new value for `popularity`.
  /// - `posterPath` (String?): The new value for `posterPath`.
  /// - `releaseDate` (String?): The new value for `releaseDate`.
  /// - `title` (String?): The new value for `title`.
  /// - `video` (bool?): The new value for `video`.
  /// - `voteAverage` (double?): The new value for `voteAverage`.
  /// - `voteCount` (int?): The new value for `voteCount`.
  ///
  /// **Returns:**
  /// - A new `TheMovie` instance with the updated values.
  TheMovie copyWith({
    bool? adult,
    String? backdropPath,
    List<int>? genreIds,
    int? id,
    String? originalLanguage,
    String? originalTitle,
    String? overview,
    double? popularity,
    String? posterPath,
    String? releaseDate,
    String? title,
    bool? video,
    double? voteAverage,
    int? voteCount,
  }) => TheMovie(
    adult: adult ?? this.adult,
    backdropPath: backdropPath ?? this.backdropPath,
    genreIds: genreIds ?? this.genreIds,
    id: id ?? this.id,
    originalLanguage: originalLanguage ?? this.originalLanguage,
    originalTitle: originalTitle ?? this.originalTitle,
    overview: overview ?? this.overview,
    popularity: popularity ?? this.popularity,
    posterPath: posterPath ?? this.posterPath,
    releaseDate: releaseDate ?? this.releaseDate,
    title: title ?? this.title,
    video: video ?? this.video,
    voteAverage: voteAverage ?? this.voteAverage,
    voteCount: voteCount ?? this.voteCount,
  );

  /// Creates a `TheMovie` instance from a raw JSON string.
  ///
  /// **Parameters:**
  /// - `str` (String): The raw JSON string.
  ///
  /// **Returns:**
  /// - A `TheMovie` instance parsed from the JSON string.
  factory TheMovie.fromRaw(String str) => TheMovie.fromMap(json.decode(str));

  /// Creates a `TheMovie` instance from a JSON map.
  ///
  /// **Parameters:**
  /// - `json` (Map<String, dynamic>): The JSON map.
  ///
  /// **Returns:**
  /// - A `TheMovie` instance parsed from the JSON map.
  factory TheMovie.fromMap(Map<String, dynamic> json) => TheMovie(
    adult: json["adult"] ?? false,
    backdropPath: json["backdrop_path"] ?? '',
    genreIds: List<int>.from((json["genre_ids"] ?? []).map((x) => x)),
    id: json["id"] ?? 0,
    originalLanguage: json["original_language"] ?? '',
    originalTitle: json["original_title"] ?? '',
    overview: json["overview"] ?? '',
    popularity: json["popularity"]?.toDouble() ?? 0.0,
    posterPath: json["poster_path"] ?? '',
    releaseDate: json["release_date"] ?? '',
    title: json["title"] ?? '',
    video: json["video"] ?? false,
    voteAverage: json["vote_average"]?.toDouble() ?? 0.0,
    voteCount: json["vote_count"] ?? 0,
  );

  /// Creates an empty `TheMovie` instance.
  ///
  /// **Returns:**
  /// - A `TheMovie` instance with default values.
  factory TheMovie.empty() => TheMovie(
    adult: false,
    backdropPath: '',
    genreIds: [],
    id: 0,
    originalLanguage: '',
    originalTitle: '',
    overview: '',
    popularity: 0.0,
    posterPath: '',
    releaseDate: '',
    title: '',
    video: false,
    voteAverage: 0.0,
    voteCount: 0,
  );

  /// Converts the `TheMovie` instance to a JSON map.
  ///
  /// **Returns:**
  /// - A `Map<String, dynamic>` representing the `TheMovie` instance.
  Map<String, dynamic> toMap() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
    "id": id,
    "original_language": originalLanguage,
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "release_date": releaseDate,
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}
