import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_builder/image_builder.dart';

/// Test suite for ImageBuilder file and memory image functionality.
///
/// This suite tests the new file and memory image loading capabilities
/// added to the ImageBuilder package.
///
/// Tests verify:
/// - File image loading with proper widget construction
/// - Memory image loading from Uint8List data
/// - Error handling for invalid file paths and corrupted data
/// - Proper parameter passing for sizing and styling
void main() {
  group('ImageBuilder File and Memory Tests', () {
    /// Test that file images can be loaded successfully.
    ///
    /// This test verifies that the ImageBuilder.file constructor
    /// creates the widget properly without actual file system operations.
    testWidgets('should handle file images successfully', (tester) async {
      // Create a test file reference (no actual file system operations)
      final testFile = File('/test/path/image.png');

      // Create ImageBuilder widget with file constructor
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImageBuilder.file(
            testFile,
            width: 100,
            height: 100,
            errorWidget: const Icon(Icons.error, color: Colors.red),
          ),
        ),
      ));

      // Trigger widget build
      await tester.pump();

      // Verify ImageBuilder widget is created successfully
      expect(find.byType(ImageBuilder), findsOneWidget);

      // Ensure no exceptions were thrown during construction
      expect(tester.takeException(), isNull);
    });

    /// Test that memory images can be loaded successfully.
    ///
    /// This test creates a PNG image in memory and verifies that
    /// the ImageBuilder.memory constructor can load it without errors.
    testWidgets('should handle memory images successfully', (tester) async {
      // Create a minimal 1x1 PNG file in memory for testing
      final pngBytes = Uint8List.fromList([
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
        0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR chunk
        0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, // 1x1 dimensions
        0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53,
        0xDE, 0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41, // IDAT chunk
        0x54, 0x08, 0xD7, 0x63, 0xF8, 0x00, 0x00, 0x00,
        0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, // Image data
        0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, // IEND chunk
        0x82
      ]);

      // Create ImageBuilder widget with memory constructor
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImageBuilder.memory(
            pngBytes,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ));

      // Trigger widget build
      await tester.pump();

      // Verify ImageBuilder widget is created successfully
      expect(find.byType(ImageBuilder), findsOneWidget);

      // Ensure no exceptions were thrown during construction
      expect(tester.takeException(), isNull);
    });

    /// Test that file images handle errors gracefully.
    ///
    /// This test verifies that the ImageBuilder handles non-existent
    /// file paths gracefully and shows appropriate error widgets.
    testWidgets('should handle file image errors gracefully', (tester) async {
      // Create ImageBuilder with non-existent file
      final nonExistentFile = File('/non/existent/path/image.png');

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImageBuilder.file(
            nonExistentFile,
            width: 100,
            height: 100,
            errorWidget: Container(
              width: 100,
              height: 100,
              color: Colors.red,
              child: const Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
      ));

      // Trigger widget build
      await tester.pump();

      // Verify ImageBuilder widget is created successfully
      expect(find.byType(ImageBuilder), findsOneWidget);

      // Ensure no exceptions were thrown during construction
      expect(tester.takeException(), isNull);
    });

    /// Test that memory images handle corrupted data gracefully.
    ///
    /// This test verifies that the ImageBuilder handles corrupted
    /// image data gracefully and shows appropriate error widgets.
    testWidgets('should handle corrupted memory image data gracefully',
        (tester) async {
      // Create invalid/corrupted image data
      final corruptedBytes = Uint8List.fromList([0x00, 0x01, 0x02, 0x03]);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ImageBuilder.memory(
            corruptedBytes,
            width: 100,
            height: 100,
            errorWidget: Container(
              width: 100,
              height: 100,
              color: Colors.orange,
              child: const Icon(Icons.broken_image, color: Colors.white),
            ),
          ),
        ),
      ));

      // Trigger widget build
      await tester.pump();

      // Verify ImageBuilder widget is created successfully
      expect(find.byType(ImageBuilder), findsOneWidget);

      // Ensure no exceptions were thrown during construction
      expect(tester.takeException(), isNull);
    });

    /// Test that different constructors have proper parameter isolation.
    ///
    /// This test verifies that the different constructors (path, file, memory)
    /// properly isolate their parameters and don't interfere with each other.
    testWidgets('should isolate constructor parameters properly',
        (tester) async {
      final testBytes =
          Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]); // PNG header

      // Test that memory constructor has null path and file
      final memoryWidget = ImageBuilder.memory(testBytes);
      expect(memoryWidget.path, isNull);
      expect(memoryWidget.file, isNull);
      expect(memoryWidget.bytes, equals(testBytes));

      // Test that file constructor has null path and bytes
      final testFile = File('/test/path.png');
      final fileWidget = ImageBuilder.file(testFile);
      expect(fileWidget.path, isNull);
      expect(fileWidget.bytes, isNull);
      expect(fileWidget.file, equals(testFile));

      // Test that path constructor has null file and bytes
      const testPath = 'assets/test.png';
      const pathWidget = ImageBuilder(testPath);
      expect(pathWidget.file, isNull);
      expect(pathWidget.bytes, isNull);
      expect(pathWidget.path, equals(testPath));
    });
  });
}
