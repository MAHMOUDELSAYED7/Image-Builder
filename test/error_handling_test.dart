import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:image_builder/image_builder.dart';

void main() {
  group('ImageBuilder Error Handling Tests', () {
    testWidgets('should build widget tree without crashing on network errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageBuilder(
              'https://this-does-not-exist.com/image.jpg',
              width: 100,
              height: 100,
              errorWidget: const Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(tester.takeException(), isNull);

      expect(find.byType(ImageBuilder), findsOneWidget);
    });

    testWidgets('should handle invalid paths without throwing exceptions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageBuilder(
              'invalid-path.xyz',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('should handle empty or null-like paths gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageBuilder(
              'some-file-without-extension',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      expect(find.byIcon(Icons.error), findsOneWidget);
    });
  });
}
