import 'package:flutter_test/flutter_test.dart';

import 'package:aro_movies_app/app/domain/entities/models/mdl_the_movie.dart';
import 'package:aro_movies_app/app/presentation/providers/movies_provider.dart';
import 'package:aro_movies_app/app/domain/repositories/repository_api_conn.dart';
import 'package:aro_movies_app/app/domain/entities/models/mdl_getlist_movies.dart';

class MockApiConnRepository implements ApiConnRepository {
  List<TheMovie> popular = [];
  List<TheMovie> search = [];
  bool throwOnPopular = false;
  bool throwOnSearch = false;

  @override
  Future<GetListMovies> getPopularMovies() async {
    if (throwOnPopular) throw Exception('popular error');
    return GetListMovies(
      results: popular,
      page: 1,
      totalPages: 1,
      totalResults: popular.length,
    );
  }

  @override
  Future<GetListMovies> getSearchMovies(String query) async {
    if (throwOnSearch) throw Exception('search error');
    return GetListMovies(
      results: search,
      page: 1,
      totalPages: 1,
      totalResults: search.length,
    );
  }
}

void main() {
  late MockApiConnRepository mockRepo;
  late MoviesProvider provider;
  late TheMovie movie;

  setUp(() {
    mockRepo = MockApiConnRepository();
    provider = MoviesProvider(mockRepo);
    movie = TheMovie.empty().copyWith(id: 1, title: 'Test Movie');
  });

  test('fetchPopularMovies loads movies', () async {
    mockRepo.popular = [movie];
    await provider.fetchPopularMovies();
    expect(provider.popularMovies, [movie]);
    expect(provider.isLoadingPopular, false);
    expect(provider.popularError, isNull);
  });

  test('fetchPopularMovies sets error on failure', () async {
    mockRepo.throwOnPopular = true;
    await provider.fetchPopularMovies();
    expect(provider.popularError, contains('Error loading popular movies'));
    expect(provider.isLoadingPopular, false);
  });

  test('searchMovies loads search results', () async {
    mockRepo.search = [movie];
    await provider.searchMovies('test');
    expect(provider.searchResults, [movie]);
    expect(provider.isLoadingSearch, false);
    expect(provider.searchError, isNull);
    expect(provider.searchQuery, 'test');
  });

  test('searchMovies sets error on failure', () async {
    mockRepo.throwOnSearch = true;
    await provider.searchMovies('test');
    expect(provider.searchError, contains('Error searching movies'));
    expect(provider.isLoadingSearch, false);
  });

  test('searchMovies with empty query clears results', () async {
    mockRepo.search = [movie];
    await provider.searchMovies('');
    expect(provider.searchResults, isEmpty);
    expect(provider.searchQuery, '');
    expect(provider.searchError, isNull);
  });

  test('clearSearch resets search state', () {
    provider.searchResults.add(movie);
    provider.clearSearch();
    expect(provider.searchResults, isEmpty);
    expect(provider.searchQuery, '');
    expect(provider.searchError, isNull);
  });

  test('refreshPopularMovies calls fetchPopularMovies', () async {
    mockRepo.popular = [movie];
    await provider.refreshPopularMovies();
    expect(provider.popularMovies, [movie]);
  });

  test('getMovieById finds movie in popular', () async {
    provider.popularMovies.add(movie);
    final result = provider.getMovieById(movie.id);
    expect(result, movie);
  });

  test('getMovieById finds movie in search', () async {
    provider.searchResults.add(movie);
    final result = provider.getMovieById(movie.id);
    expect(result, movie);
  });

  test('getMovieById returns null if not found', () {
    final result = provider.getMovieById(999);
    expect(result, isNull);
  });

  test('hasPopularMovies and hasSearchResults work', () {
    expect(provider.hasPopularMovies, false);
    expect(provider.hasSearchResults, false);
    provider.popularMovies.add(movie);
    provider.searchResults.add(movie);
    expect(provider.hasPopularMovies, true);
    expect(provider.hasSearchResults, true);
  });

  test('reset clears all state', () {
    provider.popularMovies.add(movie);
    provider.searchResults.add(movie);
    provider.reset();
    expect(provider.popularMovies, isEmpty);
    expect(provider.searchResults, isEmpty);
    expect(provider.isLoadingPopular, false);
    expect(provider.popularError, isNull);
    expect(provider.isLoadingSearch, false);
    expect(provider.searchError, isNull);
    expect(provider.searchQuery, '');
  });
}
