import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/movies_provider.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/loading_grid.dart';

/// Displays a grid of popular movies fetched from the API.
///
/// The `HomePage` widget presents a list of popular movies in a grid format.
/// It manages several UI states:
/// - **Loading**: Shows a loading grid while movies are being fetched.
/// - **Error**: Displays an error message and a retry button if loading fails.
/// - **Empty**: Informs the user when no popular movies are found.
/// - **Content**: Renders a grid of movies using [MovieCard] widgets, with pull-to-refresh support.
///
/// The page interacts with [MoviesProvider] to manage state and fetch data:
/// - `popularMovies`: List of popular movies.
/// - `isLoadingPopular`: Indicates if movies are loading.
/// - `popularError`: Error message if loading fails.
///
/// ### Getters and Setters
/// - No explicit getters/setters in this class; state is accessed via [MoviesProvider].
///
/// ### Methods
/// - [build]: Builds the widget tree for the page, handling all UI states.
/// - Refresh: Uses [RefreshIndicator] to allow users to refresh the movie list.
///
/// ### Usage
/// Place this page in your navigation stack to display and interact with popular movies.
class HomePage extends StatelessWidget {
  /// Creates a `HomePage` instance.
  const HomePage({super.key});

  @override
  /// Builds the widget tree for the home page.
  ///
  /// **Parameters:**
  /// - `context` (BuildContext): The build context.
  ///
  /// **Returns:**
  /// - A `Widget` representing the home page.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas Populares'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<MoviesProvider>(
        builder: (context, moviesProvider, child) {
          // Loading state
          if (moviesProvider.isLoadingPopular) {
            return const LoadingGrid();
          }

          // Error state
          if (moviesProvider.popularError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    moviesProvider.popularError!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      moviesProvider.fetchPopularMovies();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (moviesProvider.popularMovies.isEmpty) {
            return const Center(
              child: Text('No se encontraron películas populares'),
            );
          }

          // Movies grid
          return RefreshIndicator(
            onRefresh: () => moviesProvider.refreshPopularMovies(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: moviesProvider.popularMovies.length,
              itemBuilder: (context, index) {
                final movie = moviesProvider.popularMovies[index];
                return MovieCard(movie: movie);
              },
            ),
          );
        },
      ),
    );
  }
}
