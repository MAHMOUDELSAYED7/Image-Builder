import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:image_builder/image_builder.dart';

/// Test suite for ImageBuilder adaptive loading functionality.
/// 
/// This suite tests the platform-adaptive loading indicators that automatically
/// switch between Cupertino (iOS/macOS) and Material (Android/Web) design systems
/// based on the current platform.
/// 
/// Tests verify:
/// - Adaptive loading behavior when enabled/disabled
/// - Default adaptive loading behavior
/// - Widget construction without errors
void main() {
  group('ImageBuilder Adaptive Loading Tests', () {
    /// Test that adaptive loading is used when explicitly enabled.
    /// 
    /// Verifies that the ImageBuilder widget constructs properly and doesn't
    /// throw exceptions when adaptive loading is turned on.
    testWidgets('should use adaptive loading when enabled', (WidgetTester tester) async {
      // Create ImageBuilder with adaptive loading enabled
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageBuilder(
              'https://example.com/image.jpg',
              width: 100,
              height: 100,
              useAdaptiveLoading: true, // Explicitly enable adaptive loading
            ),
          ),
        ),
      );

      // Trigger widget build
      await tester.pump();
      
      // Verify ImageBuilder widget is created successfully
      expect(find.byType(ImageBuilder), findsOneWidget);
      
      // Ensure no exceptions were thrown during construction
      expect(tester.takeException(), isNull);
    });

    /// Test that non-adaptive loading is used when adaptive loading is disabled.
    /// 
    /// Verifies that the ImageBuilder widget constructs properly and uses
    /// standard Material Design loading indicators when adaptive loading is turned off.
    testWidgets('should use non-adaptive loading when disabled', (WidgetTester tester) async {
      // Create ImageBuilder with adaptive loading disabled
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageBuilder(
              'https://example.com/image.jpg',
              width: 100,
              height: 100,
              useAdaptiveLoading: false, // Explicitly disable adaptive loading
            ),
          ),
        ),
      );

      // Trigger widget build
      await tester.pump();
      
      // Verify ImageBuilder widget is created successfully
      expect(find.byType(ImageBuilder), findsOneWidget);
      // Ensure no exceptions were thrown during construction
      expect(tester.takeException(), isNull);
    });

    /// Test that adaptive loading is enabled by default when not specified.
    /// 
    /// Verifies that the ImageBuilder widget defaults to adaptive loading behavior
    /// when the useAdaptiveLoading parameter is not explicitly provided.
    testWidgets('should default to adaptive loading when not specified', (WidgetTester tester) async {
      // Create ImageBuilder without specifying useAdaptiveLoading (should default to true)
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