import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:image_builder/image_builder.dart';

/// Test suite for ImageBuilder error handling functionality.
///
/// This suite tests the widget's resilience to various error conditions
/// including network failures, invalid URLs, malformed paths, and null values.
///
/// Tests verify:
/// - Graceful handling of network errors without crashes
/// - Proper handling of invalid file paths
/// - Error widget display when specified
/// - Null safety and edge cases
void main() {
  group('ImageBuilder Error Handling Tests', () {
    /// Test that the widget handles network errors gracefully without crashing.
    ///
    /// This test uses a non-existent URL to simulate network failures and
    /// verifies that the widget tree constructs properly with a custom error widget.
    testWidgets('should build widget tree without crashing on network errors',
        (WidgetTester tester) async {
      // Create ImageBuilder with non-existent URL to trigger network error
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageBuilder(
              'https://this-does-not-exist.com/image.jpg', // Invalid URL
              width: 100,
              height: 100,
              errorWidget: const Icon(Icons.error,
                  color: Colors.red), // Custom error widget
            ),
          ),
        ),
      );

      // Trigger widget build
      await tester.pump();
      // Verify no exceptions were thrown during error handling
      expect(tester.takeException(), isNull);

      // Verify ImageBuilder widget was created successfully despite error
      expect(find.byType(ImageBuilder), findsOneWidget);
    });

    /// Test that invalid file paths are handled gracefully without exceptions.
    ///
    /// This test uses a malformed path to verify that the ImageBuilder
    /// can handle various types of invalid input without throwing exceptions.
    testWidgets('should handle invalid paths without throwing exceptions',
        (WidgetTester tester) async {
      // Create ImageBuilder with invalid/malformed path
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
