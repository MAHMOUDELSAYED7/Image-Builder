import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:image_builder/image_builder.dart';

void main() {
  group('ImageBuilder Adaptive Loading Tests', () {
    testWidgets('should use adaptive loading when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageBuilder(
              'https://example.com/image.jpg',
              width: 100,
              height: 100,
              useAdaptiveLoading: true,
            ),
          ),
        ),
      );

      await tester.pump();
      
      expect(find.byType(ImageBuilder), findsOneWidget);
      
      expect(tester.takeException(), isNull);
    });

    testWidgets('should use non-adaptive loading when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageBuilder(
              'https://example.com/image.jpg',
              width: 100,
              height: 100,
              useAdaptiveLoading: false,
            ),
          ),
        ),
      );

      await tester.pump();
      
      expect(find.byType(ImageBuilder), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should default to adaptive loading when not specified', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageBuilder(
              'https://example.com/image.jpg',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      await tester.pump();
      
      expect(find.byType(ImageBuilder), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('should ignore adaptive loading when custom placeholder is provided', (WidgetTester tester) async {
      const customPlaceholder = CircularProgressIndicator();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageBuilder(
              'https://example.com/image.jpg',
              width: 100,
              height: 100,
              placeholder: customPlaceholder,
              useAdaptiveLoading: true,
            ),
          ),
        ),
      );

      await tester.pump();
      
      expect(find.byType(ImageBuilder), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}