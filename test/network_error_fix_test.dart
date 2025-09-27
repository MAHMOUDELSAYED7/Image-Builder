import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:image_builder/image_builder.dart';

void main() {
  group('ImageBuilder Network Error Handling', () {
    testWidgets('should handle "this-does-not-exist.com" error gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageBuilder(
              'https://this-does-not-exist.com/image.jpg',
              width: 150,
              height: 150,
              errorWidget: Container(
                width: 150,
                height: 150,
                color: Colors.orange[100],
                child: const Icon(Icons.broken_image, color: Colors.orange),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(tester.takeException(), isNull);

      expect(find.byType(ImageBuilder), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle multiple simultaneous network errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ImageBuilder(
                  'https://this-does-not-exist.com/image1.jpg',
                  width: 100,
                  height: 100,
                ),
                ImageBuilder(
                  'https://another-invalid-domain.fake/image2.png',
                  width: 100,
                  height: 100,
                ),
                ImageBuilder(
                  'https://nonexistent.invalid/image3.gif',
                  width: 100,
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pump();
      expect(tester.takeException(), isNull);

      expect(find.byType(ImageBuilder), findsNWidgets(3));

      await tester.pump(const Duration(milliseconds: 200));

      expect(tester.takeException(), isNull);
    });
  });
}
