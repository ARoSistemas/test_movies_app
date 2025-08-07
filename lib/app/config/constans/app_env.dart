/// The current environment of the application.
///
/// **Possible Values:**
/// - `dev`: Development environment.
/// - `qa`: Quality Assurance environment.
/// - `prod`: Production environment.
const String env = 'dev';

/// The version of the application.
///
/// Combines the version number with the current environment.
const String versionApp = '1.0.0+1 :: $env';

/// The base URL for The Movie Database API.
const String baseUrl = 'https://api.themoviedb.org';

/// The API key for authenticating requests to The Movie Database API.
const String apiKey =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOGEzZjJhMDcxNDYyMDg0Y2I4ODRjYzNiMzdjZWIzOCIsIm5iZiI6MTc1NDMzNjUyOS40NjU5OTk4LCJzdWIiOiI2ODkxMGQxMThmZTIyZmM3ZjgxMWRlYWMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.wvQ5Q-Fizu6rGJ2hczOnSaCjEAKDAFD1sd2TJT1mTXI';

/// The endpoint for fetching popular movies.
const String epPopularMovies = '/3/movie/popular';

/// The endpoint for searching movies by query.
const String epSearchMovies = '/3/search/movie?query=';
