import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/movies_provider.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/loading_grid.dart';

/// A page that allows users to search for movies.
///
/// This page includes a search bar for entering queries and displays search results.
/// It also handles loading, error, and empty states for the search functionality.
class SearchPage extends StatefulWidget {
  /// Creates a `SearchPage` instance.
  const SearchPage({super.key});

  @override
  /// Creates the state for the `SearchPage` widget.
  ///
  /// **Returns:**
  /// - A `_SearchPageState` instance.
  State<SearchPage> createState() => _SearchPageState();
}

/// The state class for the `SearchPage` widget.
///
/// This class manages the search bar input and interactions with the `MoviesProvider`.
class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  /// Disposes of the resources used by the `SearchPage` widget.
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  /// Builds the widget tree for the search page.
  ///
  /// **Parameters:**
  /// - `context` (BuildContext): The build context.
  ///
  /// **Returns:**
  /// - A `Widget` representing the search page.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Películas'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Buscar películas...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<MoviesProvider>().clearSearch();
                          _searchFocusNode.unfocus();
                        },
                      )
                    : null,
              ),
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  context.read<MoviesProvider>().searchMovies(query.trim());
                  _searchFocusNode.unfocus();
                }
              },
              onChanged: (value) {
                setState(() {}); // To show/hide clear button
              },
            ),
          ),

          // Search Results
          Expanded(
            child: Consumer<MoviesProvider>(
              builder: (context, moviesProvider, child) {
                // Loading state
                if (moviesProvider.isLoadingSearch) {
                  return const LoadingGrid();
                }

                // Error state
                if (moviesProvider.searchError != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          moviesProvider.searchError!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_searchController.text.trim().isNotEmpty) {
                              context.read<MoviesProvider>().searchMovies(
                                _searchController.text.trim(),
                              );
                            }
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                // Empty search state
                if (moviesProvider.searchQuery.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Busca tus películas favoritas',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Escribe el nombre de una película y presiona buscar',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                // No results state
                if (moviesProvider.searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontraron películas',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Intenta con otro término de búsqueda',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }

                // Results grid
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: moviesProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = moviesProvider.searchResults[index];
                    return MovieCard(movie: movie);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
