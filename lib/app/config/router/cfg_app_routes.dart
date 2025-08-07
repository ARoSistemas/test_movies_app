import 'package:flutter/material.dart' show Widget, BuildContext;

import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/favorites/favorites_page.dart';
import '../../presentation/pages/details/movie_details_page.dart';

import '../../domain/entities/models/mdl_the_movie.dart';

/// Centralizes route names for application navigation.
///
/// The [Routes] class defines static constants for each route used in the app, ensuring consistency and type safety when navigating between pages.
///
/// ### Usage
/// Use these constants as route names in navigation methods, route maps, and anywhere you need to reference a route string.
///
/// ### Routes
/// - [home]: Route name for the home page (`/home`).
/// - [details]: Route name for the details page (`/details`).
/// - [favorites]: Route name for the favorites page (`/favorites`).
///
/// ### Example
/// ```dart
/// Navigator.pushNamed(context, Routes.details);
/// ```
class Routes {
  /// Route name for the home page (`/home`).
  static const home = '/home';

  /// Route name for the details page (`/details`).
  static const details = '/details';

  /// Route name for the favorites page (`/favorites`).
  static const favorites = '/favorites';

  /// Private constructor to prevent instantiation.
  Routes._(); // coverage:ignore-line
}

/// Provides a map of application routes to their corresponding widget builders.
///
/// This method returns a map where each entry represents a route and its associated widget builder function.
///
/// **Returns:**
/// - A [Map<String, Widget Function(BuildContext)>] where the keys are route names and the values are functions that build widgets.
///
/// **Route Entries:**
/// - `'Routes.home'` (String): Route name for the home page, associated with [HomePage].
/// - `'Routes.details'` (String): Route name for the details page, associated with [MovieDetailsPage].
/// - `'Routes.favorites'` (String): Route name for the favorites page, associated with [FavoritesPage].
Map<String, Widget Function(BuildContext)> get appRoutes {
  return {
    Routes.home: (_) => const HomePage(),
    Routes.details: (_) => MovieDetailsPage(movie: TheMovie.empty()),
    Routes.favorites: (_) => const FavoritesPage(),
  };
}
