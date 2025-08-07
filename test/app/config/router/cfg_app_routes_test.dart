import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:aro_movies_app/app/config/router/cfg_app_routes.dart';
import 'package:aro_movies_app/app/presentation/pages/home/home_page.dart';
import 'package:aro_movies_app/app/presentation/pages/favorites/favorites_page.dart';
import 'package:aro_movies_app/app/presentation/pages/details/movie_details_page.dart';
import 'package:aro_movies_app/app/domain/entities/models/mdl_the_movie.dart';
import 'package:flutter/material.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('cfg_app_routes Tests', () {
    final mockContext = MockBuildContext();

    test('Routes constants should have correct values', () {
      expect(Routes.home, '/home');
      expect(Routes.details, '/details');
      expect(Routes.favorites, '/favorites');
    });

    test('appRoutes should return correct widget builders', () {
      final routes = appRoutes;

      expect(routes[Routes.home], isNotNull);
      expect(routes[Routes.home]!(mockContext), isA<HomePage>());

      expect(routes[Routes.details], isNotNull);
      expect(
        routes[Routes.details]!(mockContext),
        isA<MovieDetailsPage>().having(
          (p) => p.movie.runtimeType,
          'movie type',
          TheMovie.empty().runtimeType,
        ),
      );

      expect(routes[Routes.favorites], isNotNull);
      expect(routes[Routes.favorites]!(mockContext), isA<FavoritesPage>());
    });
  });
}
