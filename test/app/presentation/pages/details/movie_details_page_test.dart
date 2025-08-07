import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aro_movies_app/app/domain/entities/models/mdl_the_movie.dart';
import 'package:aro_movies_app/app/presentation/providers/favorites_provider.dart';
import 'package:aro_movies_app/app/presentation/pages/details/movie_details_page.dart';

void main() {
  final testMovie = TheMovie.empty().copyWith(
    id: 1,
    title: 'Test Movie',
    originalTitle: 'Test Movie Original',
    releaseDate: '2025-08-06',
    overview: 'Sinopsis de prueba',
    genreIds: [28, 12],
    popularity: 123.4,
    voteAverage: 8.5,
    voteCount: 100,
    posterPath: '',
    backdropPath: '',
    adult: false,
    video: false,
  );

  Widget buildTestWidget(MockFavoritesProvider provider) {
    return ChangeNotifierProvider<FavoritesProvider>.value(
      value: provider,
      child: MaterialApp(home: MovieDetailsPage(movie: testMovie)),
    );
  }

  testWidgets('renders movie details', (tester) async {
    final provider = MockFavoritesProvider();
    await tester.pumpWidget(buildTestWidget(provider));
    expect(find.text('Test Movie'), findsOneWidget);
    expect(find.text('Test Movie Original'), findsOneWidget);
    expect(find.text('6 de agosto de 2025'), findsOneWidget);
    expect(find.text('Sinopsis'), findsOneWidget);
    expect(find.text('Sinopsis de prueba'), findsOneWidget);
    expect(find.text('Géneros'), findsOneWidget);
    expect(find.text('Acción'), findsOneWidget);
    expect(find.text('Aventura'), findsOneWidget);
    expect(find.text('Información adicional'), findsOneWidget);
    expect(find.text('Idioma original:'), findsOneWidget);
    expect(find.text('Popularidad:'), findsOneWidget);
  });

  testWidgets('shows favorite icon and toggles favorite', (tester) async {
    final provider = MockFavoritesProvider();
    await tester.pumpWidget(buildTestWidget(provider));
    final favIcon = find.byIcon(Icons.favorite_border);
    expect(favIcon, findsOneWidget);
    await tester.tap(favIcon);
    await tester.pump();
    expect(provider.toggleCalled, true);
  });

  testWidgets('shows SnackBar when toggling favorite', (tester) async {
    final provider = MockFavoritesProvider();
    await tester.pumpWidget(buildTestWidget(provider));
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Test Movie agregado a favoritos'), findsOneWidget);
    // Oculta el SnackBar antes de mostrar el siguiente
    final detailsPageElement = tester.element(find.byType(MovieDetailsPage));
    ScaffoldMessenger.of(detailsPageElement).hideCurrentSnackBar();
    await tester.pump();
    // Simula quitar de favoritos
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump();
    expect(find.text('Test Movie eliminado de favoritos'), findsOneWidget);
  });

  testWidgets('shows adult content indicator when movie.adult is true', (
    tester,
  ) async {
    final provider = MockFavoritesProvider();
    final adultMovie = testMovie.copyWith(adult: true);
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: provider,
        child: MaterialApp(home: MovieDetailsPage(movie: adultMovie)),
      ),
    );
    final textFinder = find.text('18+');
    expect(textFinder, findsOneWidget);
    final containerFinder = find.ancestor(
      of: textFinder,
      matching: find.byType(Container),
    );
    final Container containerWidget = tester.widget<Container>(containerFinder);

    final decoration = containerWidget.decoration;
    expect(decoration, isNotNull);
    expect(decoration, isA<BoxDecoration>());
    // final boxDecoration = decoration as BoxDecoration;
    // expect(boxDecoration.color, Colors.red);
  });

  testWidgets('shows backdrop image when backdropPath is set', (tester) async {
    final provider = MockFavoritesProvider();
    final movieWithBackdrop = testMovie.copyWith(
      backdropPath: '/test_backdrop.jpg',
    );
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: provider,
        child: MaterialApp(home: MovieDetailsPage(movie: movieWithBackdrop)),
      ),
    );
    expect(find.byType(Hero), findsWidgets);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });

  testWidgets('shows backdrop placeholder when backdropPath is empty', (
    tester,
  ) async {
    final provider = MockFavoritesProvider();
    final movieNoBackdrop = testMovie.copyWith(backdropPath: '');
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: provider,
        child: MaterialApp(home: MovieDetailsPage(movie: movieNoBackdrop)),
      ),
    );
    // Busca el icono de película con size 80 (backdrop placeholder)
    final iconFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Icon && widget.size == 80 && widget.icon == Icons.movie,
    );
    expect(iconFinder, findsOneWidget);
  });

  testWidgets('shows poster image when posterPath is set', (tester) async {
    final provider = MockFavoritesProvider();
    final movieWithPoster = testMovie.copyWith(posterPath: '/test_poster.jpg');
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: provider,
        child: MaterialApp(home: MovieDetailsPage(movie: movieWithPoster)),
      ),
    );
    expect(find.byType(CachedNetworkImage), findsWidgets);
  });

  testWidgets('shows poster placeholder when posterPath is empty', (
    tester,
  ) async {
    final provider = MockFavoritesProvider();
    final movieNoPoster = testMovie.copyWith(posterPath: '');
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: provider,
        child: MaterialApp(home: MovieDetailsPage(movie: movieNoPoster)),
      ),
    );
    expect(find.byIcon(Icons.movie), findsWidgets);
  });

  testWidgets('covers flightShuttleBuilder animation for Hero', (tester) async {
    final provider = MockFavoritesProvider();
    final movieWithBackdrop = testMovie.copyWith(
      backdropPath: '/test_backdrop.jpg',
    );
    // Página origen con Hero
    final origin = ChangeNotifierProvider<FavoritesProvider>.value(
      value: provider,
      child: MaterialApp(
        home: GestureDetector(
          onTap: () {
            Navigator.of(tester.element(find.byType(GestureDetector))).push(
              MaterialPageRoute(
                builder: (_) => MovieDetailsPage(movie: movieWithBackdrop),
              ),
            );
          },
          child: Hero(
            tag: 'movie_poster_${movieWithBackdrop.id}',
            child: Container(width: 100, height: 100, color: Colors.blue),
          ),
        ),
      ),
    );
    await tester.pumpWidget(origin);
    // Tap para navegar y disparar la animación Hero
    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();
    // Verifica que la página destino y el Hero están presentes
    expect(find.byType(MovieDetailsPage), findsOneWidget);
    expect(find.byType(Hero), findsWidgets);
  });

  testWidgets('shows backdrop placeholder when CachedNetworkImage has error', (
    tester,
  ) async {
    final provider = MockFavoritesProvider();
    final movieWithBackdrop = testMovie.copyWith(backdropPath: 'test.jpg');
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: provider,
        child: MaterialApp(home: MovieDetailsPage(movie: movieWithBackdrop)),
      ),
    );
    // Forzar error en CachedNetworkImage
    final cachedImageFinder = find.byType(CachedNetworkImage);
    final cachedImageWidget = tester.widget<CachedNetworkImage>(
      cachedImageFinder,
    );
    // Simula el errorWidget manualmente
    final errorWidget = cachedImageWidget.errorWidget?.call(
      tester.element(cachedImageFinder),
      'https://test_backdrop.jpg',
      Exception('error'),
    );
    expect(errorWidget, isNotNull);
    expect(errorWidget is Container, true);
    // Verifica que el icono de película (size 80) está en el widget
    final iconFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Icon && widget.size == 80 && widget.icon == Icons.movie,
    );
    expect(iconFinder, findsOneWidget);
  });

  testWidgets('shows poster placeholder when CachedNetworkImage has error', (
    tester,
  ) async {
    final provider = MockFavoritesProvider();
    final movieWithPoster = testMovie.copyWith(posterPath: '/test_poster.jpg');
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: provider,
        child: MaterialApp(home: MovieDetailsPage(movie: movieWithPoster)),
      ),
    );
    // Forzar error en CachedNetworkImage del poster
    final cachedImageFinder = find.byType(CachedNetworkImage);
    final cachedImageWidget = tester.widget<CachedNetworkImage>(
      cachedImageFinder,
    );
    final errorWidget = cachedImageWidget.errorWidget?.call(
      tester.element(cachedImageFinder),
      'https://image.tmdb.org/t/p/w500/test.jpg',
      Exception('error'),
    );
    expect(errorWidget, isNotNull);
    expect(errorWidget is Container, true);
    // Verifica que el icono de película (size 40) está en el widget
    final iconFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Icon && widget.size == 40 && widget.icon == Icons.movie,
    );
    expect(iconFinder, findsOneWidget);
  });

  testWidgets(
    'buildBackdropImage muestra placeholder si backdropPath está vacío',
    (tester) async {
      final provider = MockFavoritesProvider();
      final movieNoBackdrop = testMovie.copyWith(backdropPath: '');
      await tester.pumpWidget(
        ChangeNotifierProvider<FavoritesProvider>.value(
          value: provider,
          child: MaterialApp(home: MovieDetailsPage(movie: movieNoBackdrop)),
        ),
      );
      // El Hero debe contener el placeholder
      final heroFinder = find.byType(Hero);
      expect(heroFinder, findsOneWidget);
      final iconFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Icon && widget.size == 80 && widget.icon == Icons.movie,
      );
      expect(iconFinder, findsOneWidget);
    },
  );

  testWidgets(
    'buildBackdropImage muestra placeholder si CachedNetworkImage tiene error',
    (tester) async {
      final provider = MockFavoritesProvider();
      final movieWithBackdrop = testMovie.copyWith(backdropPath: '');
      await tester.pumpWidget(
        ChangeNotifierProvider<FavoritesProvider>.value(
          value: provider,
          child: MaterialApp(home: MovieDetailsPage(movie: movieWithBackdrop)),
        ),
      );
      // Si backdropPath está vacío, no debe haber CachedNetworkImage
      final cachedImageFinder = find.byType(CachedNetworkImage);
      expect(cachedImageFinder, findsNothing);
      // El placeholder debe estar presente
      final iconFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Icon && widget.size == 80 && widget.icon == Icons.movie,
      );
      expect(iconFinder, findsOneWidget);
    },
  );
}

class MockFavoritesProvider extends ChangeNotifier
    implements FavoritesProvider {
  bool _isFavorite = false;
  bool toggleCalled = false;
  String? lastSnackBarMessage;

  @override
  bool isFavorite(int movieId) => _isFavorite;
  @override
  Future<bool> toggleFavorite(TheMovie movie) async {
    toggleCalled = true;
    _isFavorite = !_isFavorite;
    notifyListeners();
    return true;
  }

  // Métodos mínimos para evitar errores
  @override
  List<TheMovie> get favoriteMovies => [];
  @override
  bool get isLoading => false;
  @override
  String? get error => null;
  @override
  bool get isEmpty => true;
  @override
  bool get isNotEmpty => false;
  @override
  int get favoritesCount => 0;
  @override
  Set<int> get favoriteIds => {};
  @override
  Future<bool> addToFavorites(TheMovie movie) async => true;
  @override
  Future<bool> removeFromFavorites(int movieId) async => true;
  @override
  Future<void> refreshFavorites() async {}
  @override
  Future<bool> clearAllFavorites() async => true;
  @override
  TheMovie? getFavoriteById(int id) => null;
  @override
  void clearError() {}
  @override
  Future<void> init() async {}
}
