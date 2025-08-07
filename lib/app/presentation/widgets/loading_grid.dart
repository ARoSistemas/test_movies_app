import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

/// Displays a grid of skeleton loaders to indicate loading state for movie cards.
///
/// The `LoadingGrid` widget is used to show a placeholder grid while movie data is being fetched.
/// It renders a configurable number of skeleton cards, matching the layout of the movie grid.
///
/// ### Parameters
/// - [itemCount]: Number of skeleton items to display (default: 6).
/// - [childAspectRatio]: Aspect ratio for each grid item (default: 0.7).
///
/// ### Usage
/// Use this widget in place of a movie grid when data is loading to provide a smooth user experience.
class LoadingGrid extends StatelessWidget {
  final int itemCount;
  final double childAspectRatio;

  const LoadingGrid({
    super.key,
    this.itemCount = 6,
    this.childAspectRatio = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const MovieCardSkeleton();
      },
    );
  }
}

/// Displays a skeleton loader for a single movie card, simulating a loading state in grids.
///
/// The `MovieCardSkeleton` widget is used to show a placeholder for a movie card while data is being fetched.
/// It mimics the layout of a typical movie card, including poster and info placeholders.
///
/// ### Usage
/// Use this widget in grids to provide a smooth loading experience while movie data is loading.
class MovieCardSkeleton extends StatelessWidget {
  const MovieCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SkeletonLoader(
        builder: Container(
          height: 280, // Altura fija para evitar overflow
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster placeholder
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                ),
              ),

              // Info placeholder
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title placeholder
                      Flexible(
                        child: Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Subtitle placeholder
                      Container(
                        height: 10,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        items: 1,
        period: const Duration(seconds: 2),
        highlightColor: Colors.white.withValues(alpha: 0.6),
        direction: SkeletonDirection.ltr,
      ),
    );
  }
}

/// Displays a skeleton loader for a single list item, simulating a loading state for movie rows.
///
/// The `LoadingListItem` widget is used to show a placeholder for a movie list item while data is being fetched.
/// It mimics the layout of a typical movie row, including poster, title, subtitle, and rating placeholders.
///
/// ### Usage
/// Use this widget in place of a movie list item when data is loading to provide a smooth user experience.
class LoadingListItem extends StatelessWidget {
  const LoadingListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: SkeletonLoader(
        builder: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Poster placeholder
              Container(
                width: 60,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 16),

              // Content placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title placeholder
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle placeholder
                    Container(
                      height: 12,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rating placeholder
                    Container(
                      height: 12,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        items: 1,
        period: const Duration(seconds: 2),
        highlightColor: Colors.white.withValues(alpha: 0.6),
        direction: SkeletonDirection.ltr,
      ),
    );
  }
}
