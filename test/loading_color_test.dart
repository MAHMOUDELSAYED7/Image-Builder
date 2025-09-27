import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_builder/image_builder.dart';

void main() {
  group('ImageBuilder Loading Color Tests', () {
    testWidgets('should apply loading color to CircularProgressIndicator on non-iOS platforms', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImageBuilder(
            'https://httpstat.us/200?sleep=5000', // Slow loading URL
            width: 100,
            height: 100,
            useAdaptiveLoading: true,
            loadingColor: Colors.blue,
          ),
        ),
      ));

      await tester.pump(); // Trigger initial build

      // Find the CircularProgressIndicator and check its color
      final progressIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(progressIndicatorFinder, findsOneWidget);
      
      final CircularProgressIndicator progressIndicator = 
          tester.widget<CircularProgressIndicator>(progressIndicatorFinder);
      expect(progressIndicator.color, Colors.blue);
      
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('should apply loading color to CupertinoActivityIndicator on iOS platforms', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      
      await tester.pumpWidget(CupertinoApp(
        home: CupertinoPageScaffold(
          child: ImageBuilder(
            'https://httpstat.us/200?sleep=5000', // Slow loading URL
            width: 100,
            height: 100,
            useAdaptiveLoading: true,
            loadingColor: Colors.red,
          ),
        ),
      ));

      await tester.pump(); // Trigger initial build

      // Find the CupertinoActivityIndicator and check its color
      final activityIndicatorFinder = find.byType(CupertinoActivityIndicator);
      expect(activityIndicatorFinder, findsOneWidget);
      
      final CupertinoActivityIndicator activityIndicator = 
          tester.widget<CupertinoActivityIndicator>(activityIndicatorFinder);
      expect(activityIndicator.color, Colors.red);
      
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('should use default colors when loadingColor is null', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImageBuilder(
            'https://httpstat.us/200?sleep=5000', // Slow loading URL
            width: 100,
            height: 100,
            useAdaptiveLoading: true,
            // loadingColor is null - should use default
          ),
        ),
      ));

      await tester.pump(); // Trigger initial build

      // Find the CircularProgressIndicator and check it exists
      final progressIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(progressIndicatorFinder, findsOneWidget);
      
      final CircularProgressIndicator progressIndicator = 
          tester.widget<CircularProgressIndicator>(progressIndicatorFinder);
      // Should use default behavior when no color specified
      expect(progressIndicator.color, isNull);
      
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('should not apply loading color when custom placeholder is provided', (tester) async {
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
            'https://httpstat.us/200?sleep=5000', // Slow loading URL
            width: 100,
            height: 100,
            placeholder: customPlaceholder,
            loadingColor: Colors.blue, // Should be ignored
          ),
        ),
      ));

      await tester.pump(); // Trigger initial build

      // Should find the custom placeholder instead of loading indicator
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
            'https://httpstat.us/200?sleep=5000', // Slow loading URL
            width: 100,
            height: 100,
            useAdaptiveLoading: true,
            loadingColor: customColor,
          ),
        ),
      ));

      await tester.pump(); // Trigger initial build

      final progressIndicatorFinder = find.byType(CircularProgressIndicator);
      expect(progressIndicatorFinder, findsOneWidget);
      
      final CircularProgressIndicator progressIndicator = 
          tester.widget<CircularProgressIndicator>(progressIndicatorFinder);
      expect(progressIndicator.color, customColor);
      
      debugDefaultTargetPlatformOverride = null;
    });
  });
}