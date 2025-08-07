import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:aro_movies_app/app/domain/entities/models/mdl_getlist_movies.dart';
import 'package:aro_movies_app/app/domain/entities/models/mdl_the_movie.dart';

void main() {
  group('GetListMovies', () {
    final movie = TheMovie.empty().copyWith(id: 1, title: 'Test Movie');
    final moviesList = [movie];
    final instance = GetListMovies(
      page: 2,
      results: moviesList,
      totalPages: 5,
      totalResults: 10,
    );

    test('copyWith returns updated instance', () {
      final copy = instance.copyWith(page: 3);
      expect(copy.page, 3);
      expect(copy.results, moviesList);
      expect(copy.totalPages, 5);
      expect(copy.totalResults, 10);
    });

    test('copyWith returns updated instance with totalPages', () {
      final copy = instance.copyWith(totalPages: 1);
      expect(copy.page, 2);
      expect(copy.results, moviesList);
      expect(copy.totalPages, 1);
      expect(copy.totalResults, 10);
    });

    test('fromRaw and fromMap parse JSON correctly', () {
      final jsonStr = json.encode({
        "page": 1,
        "results": [movie.toMap()],
        "total_pages": 2,
        "total_results": 3,
      });
      final fromRaw = GetListMovies.fromRaw(jsonStr);
      expect(fromRaw.page, 1);
      expect(fromRaw.results.first.id, 1);
      expect(fromRaw.totalPages, 2);
      expect(fromRaw.totalResults, 3);

      final fromMap = GetListMovies.fromMap(json.decode(jsonStr));
      expect(fromMap.page, 1);
      expect(fromMap.results.first.id, 1);
      expect(fromMap.totalPages, 2);
      expect(fromMap.totalResults, 3);
    });

    test('empty returns default values', () {
      final empty = GetListMovies.empty();
      expect(empty.page, 0);
      expect(empty.results, isEmpty);
      expect(empty.totalPages, 0);
      expect(empty.totalResults, 0);
    });

    test('toMap returns correct map', () {
      final map = instance.toMap();
      expect(map['page'], 2);
      expect(map['results'], isA<List<Map<String, dynamic>>>());
      expect(map['total_pages'], 5);
      expect(map['total_results'], 10);
    });
  });
}
