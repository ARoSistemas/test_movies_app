import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aro_movies_app/app/presentation/widgets/loading_grid.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

void main() {
  group('LoadingGrid', () {
    testWidgets('renders correct number of skeleton items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingGrid(itemCount: 4))),
      );
      expect(find.byType(MovieCardSkeleton), findsNWidgets(4));
    });

    testWidgets('uses default itemCount and aspect ratio', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingGrid())),
      );
      expect(find.byType(MovieCardSkeleton), findsNWidgets(4));
    });
  });

  group('MovieCardSkeleton', () {
    testWidgets('renders skeleton loader', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: MovieCardSkeleton())),
      );
      expect(find.byType(SkeletonLoader), findsOneWidget);
    });
  });

  group('LoadingListItem', () {
    testWidgets('renders skeleton loader', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingListItem())),
      );
      expect(find.byType(SkeletonLoader), findsOneWidget);
    });
  });
}
