import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:aro_movies_app/app/presentation/widgets/movie_card.dart';
import 'package:aro_movies_app/app/presentation/pages/details/movie_details_page.dart';
import 'package:aro_movies_app/app/domain/entities/models/mdl_the_movie.dart';
import 'package:aro_movies_app/app/presentation/providers/favorites_provider.dart';

void main() {
  final movie = TheMovie.empty().copyWith(
    id: 1,
    title: 'Test Movie',
    posterPath: '',
    releaseDate: '2022-01-01',
    voteAverage: 8.5,
  );

  Widget buildTestWidget({
    VoidCallback? onTap,
    MockFavoritesProvider? favProvider,
  }) {
    return ChangeNotifierProvider<FavoritesProvider>.value(
      value: favProvider ?? MockFavoritesProvider(),
      child: MaterialApp(
        home: Scaffold(
          body: MovieCard(movie: movie, onTap: onTap),
        ),
      ),
    );
  }

  testWidgets('renders title and release date', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.text('Test Movie'), findsOneWidget);
    expect(find.text('2022'), findsOneWidget);
  });

  testWidgets('renders rating badge', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.text('8.5'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('renders favorite button and toggles on tap', (tester) async {
    final favProvider = MockFavoritesProvider();
    await tester.pumpWidget(buildTestWidget(favProvider: favProvider));
    final favButton = find.byIcon(Icons.favorite_border);
    expect(favButton, findsOneWidget);
    await tester.tap(favButton);
    await tester.pumpAndSettle();
    expect(favProvider.toggled, true);
  });

  testWidgets('shows placeholder when no posterPath', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.text('Sin imagen'), findsOneWidget);
    expect(find.byIcon(Icons.movie), findsOneWidget);
  });

  testWidgets('navigates to details on tap', (tester) async {
    bool navigated = false;
    await tester.pumpWidget(
      buildTestWidget(
        onTap: () {
          navigated = true;
        },
      ),
    );
    await tester.tap(
      find.ancestor(
        of: find.text('Test Movie'),
        matching: find.byType(InkWell),
      ),
    );
    expect(navigated, true);
  });

  testWidgets('renders favorite icon when already favorite', (tester) async {
    final favProvider = MockFavoritesProvider();
    favProvider._isFavorite = true;
    await tester.pumpWidget(buildTestWidget(favProvider: favProvider));
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('does not render rating badge if voteAverage is 0', (
    tester,
  ) async {
    final noRatingMovie = movie.copyWith(voteAverage: 0.0);
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: MockFavoritesProvider(),
        child: MaterialApp(
          home: Scaffold(body: MovieCard(movie: noRatingMovie)),
        ),
      ),
    );
    expect(find.byIcon(Icons.star), findsNothing);
    expect(find.text('0.0'), findsNothing);
  });

  testWidgets('does not render release date if empty', (tester) async {
    final noDateMovie = movie.copyWith(releaseDate: '');
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: MockFavoritesProvider(),
        child: MaterialApp(
          home: Scaffold(body: MovieCard(movie: noDateMovie)),
        ),
      ),
    );
    expect(find.text('2022'), findsNothing);
  });

  testWidgets('formatReleaseDate returns original string if invalid', (
    tester,
  ) async {
    final invalidDateMovie = movie.copyWith(releaseDate: 'invalid-date');
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: MockFavoritesProvider(),
        child: MaterialApp(
          home: Scaffold(body: MovieCard(movie: invalidDateMovie)),
        ),
      ),
    );
    expect(find.text('invalid-date'), findsOneWidget);
  });

  testWidgets('renders network image when posterPath is present', (
    tester,
  ) async {
    final withPosterMovie = movie.copyWith(posterPath: '/test.jpg');
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: MockFavoritesProvider(),
        child: MaterialApp(
          home: Scaffold(body: MovieCard(movie: withPosterMovie)),
        ),
      ),
    );
    expect(find.byType(Image), findsWidgets);
  });

  testWidgets('shows correct SnackBar message when toggling favorite', (
    tester,
  ) async {
    final favProvider = MockFavoritesProvider();
    await tester.pumpWidget(buildTestWidget(favProvider: favProvider));
    final favButton = find.byIcon(Icons.favorite_border);
    await tester.tap(favButton);
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('agregado a favoritos'), findsOneWidget);
    // Tap de nuevo para eliminar
    // Cierra el SnackBar anterior
    final scaffoldContext = tester.element(find.byType(MovieCard));
    ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();
    expect(find.textContaining('eliminado de favoritos'), findsOneWidget);
  });

  testWidgets('navega a MovieDetailsPage usando _navigateToDetails', (
    tester,
  ) async {
    final favProvider = MockFavoritesProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>.value(
        value: favProvider,
        child: MaterialApp(
          home: Scaffold(body: MovieCard(movie: movie)),
        ),
      ),
    );
    // Tap en el card para disparar la navegación interna
    await tester.tap(
      find.ancestor(
        of: find.text('Test Movie'),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pumpAndSettle();
    // Verifica que MovieDetailsPage aparece en el árbol
    expect(find.byType(MovieDetailsPage), findsOneWidget);
  });

  testWidgets(
    'muestra placeholder si CachedNetworkImage tiene error en poster',
    (tester) async {
      final withPosterMovie = movie.copyWith(posterPath: '/test.jpg');
      await tester.pumpWidget(
        ChangeNotifierProvider<FavoritesProvider>.value(
          value: MockFavoritesProvider(),
          child: MaterialApp(
            home: Scaffold(body: MovieCard(movie: withPosterMovie)),
          ),
        ),
      );
      // Busca CachedNetworkImage y fuerza el errorWidget
      final cachedImageFinder = find.byType(CachedNetworkImage);
      expect(cachedImageFinder, findsOneWidget);
      final cachedImageWidget = tester.widget<CachedNetworkImage>(
        cachedImageFinder,
      );
      final errorWidget = cachedImageWidget.errorWidget?.call(
        tester.element(cachedImageFinder),
        'https://image.tmdb.org/t/p/w500/test.jpg',
        Exception('error'),
      );
      expect(errorWidget, isNotNull);
      // Renderiza el errorWidget en el árbol para buscar descendientes
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: errorWidget!)));
      expect(find.byIcon(Icons.movie), findsOneWidget);
      expect(find.text('Sin imagen'), findsOneWidget);
    },
  );
}

class MockFavoritesProvider extends ChangeNotifier
    implements FavoritesProvider {
  bool _isFavorite = false;
  bool toggled = false;
  @override
  bool isFavorite(int id) => _isFavorite;
  @override
  Future<bool> toggleFavorite(TheMovie movie) async {
    toggled = true;
    _isFavorite = !_isFavorite;
    notifyListeners();
    return _isFavorite;
  }

  // Métodos no usados
  @override
  List<TheMovie> get favoriteMovies => [];
  @override
  Set<int> get favoriteIds => {};
  @override
  bool get isLoading => false;
  @override
  String? get error => null;
  @override
  int get favoritesCount => 0;
  @override
  Future<void> init() async {}
  @override
  Future<bool> addToFavorites(TheMovie movie) async => true;
  @override
  Future<bool> removeFromFavorites(int movieId) async => true;
  @override
  Future<bool> clearAllFavorites() async => true;
  @override
  Future<void> refreshFavorites() async {}
  @override
  TheMovie? getFavoriteById(int id) => null;
  @override
  bool get isEmpty => true;
  @override
  bool get isNotEmpty => false;
  @override
  void clearError() {}
}
