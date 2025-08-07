import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/favorites_provider.dart';
import '../../widgets/movie_card.dart';

/// Displays the user's favorite movies in a grid layout.
///
/// The `FavoritesPage` widget presents a list of movies that the user has marked as favorites.
/// It manages several UI states:
/// - **Loading**: Shows a loading indicator while favorites are being fetched.
/// - **Error**: Displays an error message and a retry button if loading fails.
/// - **Empty**: Informs the user when there are no favorites and encourages adding some.
/// - **Content**: Renders a grid of favorite movies using [MovieCard] widgets.
///
/// The page also provides an option to clear all favorites via an AppBar action, which triggers a confirmation dialog.
///
/// ### Getters and Setters
/// - The class itself does not define explicit getters/setters, but relies on [FavoritesProvider] for state management.
/// - UI state and favorite movies are accessed through the provider's properties:
///   - `favoriteMovies`: List of favorite movies.
///   - `isLoading`: Indicates if the favorites are loading.
///   - `error`: Error message if loading fails.
///   - `isEmpty`: True if there are no favorites.
///
/// ### Methods
/// - [_showClearAllDialog]: Shows a confirmation dialog to clear all favorites.
/// - [build]: Builds the widget tree for the page, handling all UI states.
///
/// ### Usage
/// Place this page in your navigation stack to allow users to view and manage their favorite movies.
class FavoritesPage extends StatelessWidget {
  /// Creates a `FavoritesPage` instance.
  const FavoritesPage({super.key});

  @override
  /// Builds the widget tree for the favorites page.
  ///
  /// **Parameters:**
  /// - `context` (BuildContext): The build context.
  ///
  /// **Returns:**
  /// - A `Widget` representing the favorites page.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        automaticallyImplyLeading: false,
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              if (favoritesProvider.favoriteMovies.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () => _showClearAllDialog(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          // Loading state
          if (favoritesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (favoritesProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    favoritesProvider.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      favoritesProvider.refreshFavorites();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (favoritesProvider.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes favoritos aún',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explora películas y agrega las que más te gusten',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          // Favorites grid
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: favoritesProvider.favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoritesProvider.favoriteMovies[index];
              return MovieCard(movie: movie);
            },
          );
        },
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpiar favoritos'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar todos los favoritos?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<FavoritesProvider>().clearAllFavorites();
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
