import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/favorites_provider.dart';
import '../pages/details/movie_details_page.dart';

import '../../domain/entities/models/mdl_the_movie.dart';

/// Displays a card for a single movie, including poster, title, release date, rating, and favorite button.
///
/// The `MovieCard` widget presents movie information in a visually rich card format.
/// It supports navigation to the details page, toggling favorite status, and provides feedback via SnackBar.
///
/// ### Parameters
/// - [movie]: The movie to display (required).
/// - [onTap]: Optional callback for custom tap behavior. Defaults to navigation to details page.
///
/// ### Visual States
/// - Shows poster image or a placeholder if not available.
/// - Displays a favorite button, reflecting current favorite status.
/// - Shows movie rating as a badge if available.
/// - Presents title and release year.
///
/// ### Interactions
/// - Tapping the card navigates to the movie details page (unless [onTap] is provided).
/// - Tapping the favorite button toggles favorite status and shows a SnackBar.
///
/// ### Usage
/// Use this widget in grids or lists to display movie items with interactive features.
class MovieCard extends StatelessWidget {
  final TheMovie movie;
  final VoidCallback? onTap;

  const MovieCard({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap ?? () => _navigateToDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Poster Image
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Hero(
                        tag: 'movie_poster_${movie.id}',
                        child: _buildPosterImage(),
                      ),
                    ),
                  ),

                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<FavoritesProvider>(
                      builder: (context, favoritesProvider, child) {
                        final isFavorite = favoritesProvider.isFavorite(
                          movie.id,
                        );
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                              size: 20,
                            ),
                            onPressed: () => _toggleFavorite(context),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Rating Badge
                  if (movie.voteAverage > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Movie Info
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title - Flexible para adaptarse al espacio
                    Flexible(
                      child: Text(
                        movie.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Spacing between title and date
                    const SizedBox(height: 4),

                    // Release Date - Siempre visible en la parte inferior
                    if (movie.releaseDate.isNotEmpty)
                      Text(
                        _formatReleaseDate(movie.releaseDate),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterImage() {
    if (movie.posterPath.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      color: Colors.grey[300],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie, size: 40, color: Colors.grey),
          SizedBox(height: 4),
          Text(
            'Sin imagen',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _formatReleaseDate(String releaseDate) {
    try {
      final date = DateTime.parse(releaseDate);
      return '${date.year}';
    } catch (e) {
      return releaseDate;
    }
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MovieDetailsPage(movie: movie),
        transitionDuration: const Duration(milliseconds: 800),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Curva elástica para efecto de rebote
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeInOut,
          );

          return FadeTransition(opacity: curvedAnimation, child: child);
        },
      ),
    );
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
      ),
    );
  }
}
