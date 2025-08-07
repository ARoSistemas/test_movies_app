import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../providers/favorites_provider.dart';

import '../../../domain/entities/models/mdl_the_movie.dart';

/// Displays detailed information about a specific movie.
///
/// The [MovieDetailsPage] widget shows the movie's poster, title, release date, genres, rating, and other details.
/// It also allows users to mark the movie as a favorite and view additional information.
///
/// ### Properties
/// - [movie]: The [TheMovie] instance to display details for.
///
/// ### Methods
/// - [build]: Builds the widget tree for the movie details page.
/// - [_buildBackdropImage]: Builds the backdrop image with Hero animation.
/// - [_buildBackdropPlaceholder]: Builds a placeholder for the backdrop image.
/// - [_buildPosterImage]: Builds the poster image.
/// - [_buildPosterPlaceholder]: Builds a placeholder for the poster image.
/// - [_buildInfoRow]: Builds a row for additional info.
/// - [_formatReleaseDate]: Formats the release date string.
/// - [_getGenreName]: Returns the genre name for a given genre ID.
/// - [_toggleFavorite]: Toggles the favorite status and shows a SnackBar.
///
/// ### Example
/// ```dart
/// MovieDetailsPage(movie: myMovie)
/// ```
class MovieDetailsPage extends StatelessWidget {
  /// The movie to display details for.
  final TheMovie movie;

  /// Creates a `MovieDetailsPage` instance.
  ///
  /// **Parameters:**
  /// - `movie` (TheMovie): The movie to display details for.
  const MovieDetailsPage({super.key, required this.movie});

  @override
  /// Builds the widget tree for the movie details page.
  ///
  /// **Parameters:**
  /// - `context` (BuildContext): The build context.
  ///
  /// **Returns:**
  /// - A `Widget` representing the movie details page.
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// App Bar with backdrop image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(background: _buildBackdropImage()),
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Consumer<FavoritesProvider>(
                builder: (context, favoritesProvider, child) {
                  final isFavorite = favoritesProvider.isFavorite(movie.id);
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () => _toggleFavorite(context),
                    ),
                  );
                },
              ),
            ],
          ),

          /// Movie details content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie poster and basic info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      Container(
                        width: 120,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildPosterImage(),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Basic info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              movie.title,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),

                            // Original title (if different)
                            if (movie.originalTitle != movie.title)
                              Text(
                                movie.originalTitle,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            const SizedBox(height: 8),

                            // Release date
                            if (movie.releaseDate.isNotEmpty)
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatReleaseDate(movie.releaseDate),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            const SizedBox(height: 8),

                            // Rating
                            if (movie.voteAverage > 0)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${movie.voteAverage.toStringAsFixed(1)}/10',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${movie.voteCount} votos)',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 8),

                            // Adult content indicator
                            if (movie.adult)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '18+',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Overview section
                  if (movie.overview.isNotEmpty) ...[
                    Text(
                      'Sinopsis',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(height: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Genres section
                  if (movie.genreIds.isNotEmpty) ...[
                    Text(
                      'Géneros',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: movie.genreIds.map((genreId) {
                        return Chip(
                          label: Text(_getGenreName(genreId)),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Additional info section
                  Text(
                    'Información adicional',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Idioma original',
                    movie.originalLanguage.toUpperCase(),
                  ),
                  _buildInfoRow(
                    'Popularidad',
                    movie.popularity.toStringAsFixed(1),
                  ),
                  if (movie.video) _buildInfoRow('Video disponible', 'Sí'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackdropImage() {
    if (movie.backdropPath.isNotEmpty) {
      return Hero(
        tag: 'movie_poster_${movie.id}',
        flightShuttleBuilder:
            (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              // Animación de escala durante el vuelo
              final scaleAnimation =
                  Tween<double>(
                    begin: flightDirection == HeroFlightDirection.push
                        ? 1.0
                        : 1.2,
                    end: flightDirection == HeroFlightDirection.push
                        ? 1.2
                        : 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: flightDirection == HeroFlightDirection.push
                          ? Curves.elasticOut
                          : Curves.easeInOut,
                    ),
                  );

              return AnimatedBuilder(
                animation: scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: scaleAnimation.value,
                    child: Material(
                      color: Colors.transparent,
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w1280${movie.backdropPath}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            _buildBackdropPlaceholder(),
                      ),
                    ),
                  );
                },
              );
            },
        child: CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w1280${movie.backdropPath}',
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildBackdropPlaceholder(),
          errorWidget: (context, url, error) => _buildBackdropPlaceholder(),
        ),
      );
    } else {
      return Hero(
        tag: 'movie_poster_${movie.id}',
        child: Material(
          color: Colors.transparent,
          child: _buildBackdropPlaceholder(),
        ),
      );
    }
  }

  Widget _buildBackdropPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.movie, size: 80, color: Colors.grey),
      ),
    );
  }

  Widget _buildPosterImage() {
    if (movie.posterPath.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPosterPlaceholder(),
        errorWidget: (context, url, error) => _buildPosterPlaceholder(),
      );
    } else {
      return _buildPosterPlaceholder();
    }
  }

  Widget _buildPosterPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.movie, size: 40, color: Colors.grey),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatReleaseDate(String releaseDate) {
    try {
      final date = DateTime.parse(releaseDate);
      final months = [
        'enero',
        'febrero',
        'marzo',
        'abril',
        'mayo',
        'junio',
        'julio',
        'agosto',
        'septiembre',
        'octubre',
        'noviembre',
        'diciembre',
      ];
      return '${date.day} de ${months[date.month - 1]} de ${date.year}';
    } catch (e) {
      return releaseDate;
    }
  }

  String _getGenreName(int genreId) {
    // TMDB genre mapping for movies
    const genreMap = {
      28: 'Acción',
      12: 'Aventura',
      16: 'Animación',
      35: 'Comedia',
      80: 'Crimen',
      99: 'Documental',
      18: 'Drama',
      10751: 'Familiar',
      14: 'Fantasía',
      36: 'Historia',
      27: 'Terror',
      10402: 'Música',
      9648: 'Misterio',
      10749: 'Romance',
      878: 'Ciencia ficción',
      10770: 'TV Movie',
      53: 'Thriller',
      10752: 'Guerra',
      37: 'Western',
    };

    return genreMap[genreId] ?? 'Desconocido';
  }

  void _toggleFavorite(BuildContext context) {
    // Check state BEFORE toggling
    final wasAlreadyFavorite = context.read<FavoritesProvider>().isFavorite(
      movie.id,
    );

    context.read<FavoritesProvider>().toggleFavorite(movie);

    // Show snackbar feedback with correct message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasAlreadyFavorite
              ? '${movie.title} eliminado de favoritos'
              : '${movie.title} agregado a favoritos',
        ),
        duration: const Duration(seconds: 2),
        // action: SnackBarAction(
        //   label: 'Deshacer',
        //   onPressed: () {
        //     context.read<FavoritesProvider>().toggleFavorite(movie);
        //   },
        // ),
      ),
    );
  }
}
