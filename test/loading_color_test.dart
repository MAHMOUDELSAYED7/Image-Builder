import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_builder/image_builder.dart';

/// Test suite for ImageBuilder loading color customization functionality.
/// 
/// This suite tests the ability to customize the color of adaptive loading indicators
/// across different platforms (iOS/macOS with Cupertino vs Android/Web with Material).
/// 
/// Tests verify:
/// - Color application on platform-specific loading indicators
/// - Default behavior when no color is specified
/// - Proper handling when custom placeholders are provided
/// - Support for various color values
void main() {
  group('ImageBuilder Loading Color Tests', () {
    /// Test that loading colors are properly applied to CircularProgressIndicator
    /// on Android and other non-iOS platforms.
    /// 
    /// This test simulates Android platform and verifies that the specified
    /// blue color is correctly applied to the Material Design loading indicator.
    testWidgets(
        'should apply loading color to CircularProgressIndicator on non-iOS platforms',
        (tester) async {
      // Override platform to simulate Android environment
      // Override platform to simulate Android environment
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      // Create ImageBuilder widget with blue loading color
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImageBuilder(
            'https://httpstat.us/200?sleep=5000', // Slow loading URL for testing
            width: 100,
            height: 100,
            useAdaptiveLoading: true,
            loadingColor: Colors.blue, // Custom blue loading color
          ),
        ),
      ));

      // Trigger initial build to show loading indicator
      await tester.pump();

      // Verify CircularProgressIndicator is displayed with correct color
      final progressIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(progressIndicatorFinder, findsOneWidget);

      final CircularProgressIndicator progressIndicator =
          tester.widget<CircularProgressIndicator>(progressIndicatorFinder);
      expect(progressIndicator.color, Colors.blue);

      // Clean up platform override
      debugDefaultTargetPlatformOverride = null;
    });

    /// Test that loading colors are properly applied to CupertinoActivityIndicator
    /// on iOS and macOS platforms.
    /// 
    /// This test simulates iOS platform and verifies that the specified
    /// red color is correctly applied to the Cupertino-style loading indicator.
    testWidgets(
        'should apply loading color to CupertinoActivityIndicator on iOS platforms',
        (tester) async {
      // Override platform to simulate iOS environment
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      await tester.pumpWidget(CupertinoApp(
        home: CupertinoPageScaffold(
          child: ImageBuilder(
            'https://httpstat.us/200?sleep=5000',
            width: 100,
            height: 100,
            useAdaptiveLoading: true,
            loadingColor: Colors.red,
          ),
        ),
      ));

      await tester.pump();

      final activityIndicatorFinder = find.byType(CupertinoActivityIndicator);
      expect(activityIndicatorFinder, findsOneWidget);

      final CupertinoActivityIndicator activityIndicator =
          tester.widget<CupertinoActivityIndicator>(activityIndicatorFinder);
      expect(activityIndicator.color, Colors.red);

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('should use default colors when loadingColor is null',
        (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImageBuilder(
            'https://httpstat.us/200?sleep=5000',
            width: 100,
            height: 100,
            useAdaptiveLoading: true,
          ),
        ),
      ));

      await tester.pump();

      final progressIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(progressIndicatorFinder, findsOneWidget);

      final CircularProgressIndicator progressIndicator =
          tester.widget<CircularProgressIndicator>(progressIndicatorFinder);
      expect(progressIndicator.color, isNull);

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets(
        'should not apply loading color when custom placeholder is provided',
        (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      final customPlaceholder = Container(
        width: 100,
        height: 100,
        color: Colors.grey,
        child: const Center(child: Text('Loading...')),
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImageBuilder(
            'https://httpstat.us/200?sleep=5000',
            width: 100,
            height: 100,
            placeholder: customPlaceholder,
            loadingColor: Colors.blue,
          ),
        ),
      ));

      await tester.pump();

      expect(find.byWidget(customPlaceholder), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(CupertinoActivityIndicator), findsNothing);

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('should work with different color values', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;

      const customColor = Color(0xFF123456);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImageBuilder(
            'https://httpstat.us/200?sleep=5000',
            width: 100,
            height: 100,
            useAdaptiveLoading: true,
            loadingColor: customColor,
          ),
        ),
      ));

      await tester.pump();

      final progressIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(progressIndicatorFinder, findsOneWidget);

      final CircularProgressIndicator progressIndicator =
          tester.widget<CircularProgressIndicator>(progressIndicatorFinder);
      expect(progressIndicator.color, customColor);

      debugDefaultTargetPlatformOverride = null;
    });
  });
}
