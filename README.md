# ImageBuilder

A versatile Flutter package for handling various image types including network images, SVGs, and local assets with caching and error handling.

## Features

- 🖼️ Support for multiple image formats (PNG, JPG, JPEG, WEBP, SVG)
- 🌐 Network image loading with caching
- 📱 Local asset image support
- 🎨 SVG rendering with color customization
- ⚡ Built-in error handling and fallback widgets
- 🔄 Adaptive loading placeholders (iOS/macOS: Cupertino, Android/Web: Material)
- 📏 Flexible sizing options (width/height or unified size)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  image_builder: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

Import the package:

```dart
import 'package:image_builder/image_builder.dart';
```

### Basic Usage

```dart
// Display any type of image (network, asset, SVG)
ImageBuilder('assets/images/logo.png')

// Display a network image  
ImageBuilder('https://example.com/image.jpg')
```

### With Custom Sizing

```dart
// Using width and height
ImageBuilder(
  'assets/images/logo.svg',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)

// Using size (sets both width and height)
ImageBuilder(
  'assets/images/icon.png',
  size: 50,
)
```

### With Color Customization (SVG)

```dart
ImageBuilder(
  'assets/icons/heart.svg',
  size: 24,
  color: Colors.red,
)
```

### With Custom Placeholders and Error Widgets

```dart
ImageBuilder(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  placeholder: Container(
    color: Colors.grey[200],
    child: const Icon(Icons.image),
  ),
  errorWidget: Container(
    color: Colors.red[100],
    child: const Icon(Icons.error, color: Colors.red),
  ),
)
```

### Adaptive Loading Indicators

The package provides platform-adaptive loading indicators that automatically adjust based on the platform:

- **iOS/macOS**: Uses `CupertinoActivityIndicator` for native look and feel
- **Android/Web/Others**: Uses `CircularProgressIndicator` for Material Design

```dart
// Enable adaptive loading (default behavior)
ImageBuilder(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  useAdaptiveLoading: true, // Default: true
)

// Disable adaptive loading (always uses Material Design)
ImageBuilder(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  useAdaptiveLoading: false, // Always CircularProgressIndicator
)
```

### Custom Loading Colors

You can customize the color of the adaptive loading indicators:

```dart
// Blue loading indicator
ImageBuilder(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  useAdaptiveLoading: true,
  loadingColor: Colors.blue,
)

// Custom color for platform-specific indicators
ImageBuilder(
  'https://example.com/large-image.jpg',
  width: 300,
  height: 200,
  loadingColor: Colors.green, // Works on both Cupertino and Material indicators
)
```

**Note**: Adaptive loading only applies when no custom `placeholder` is provided. If you provide a custom placeholder, it will be used instead of the adaptive loading indicator.

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:image_builder/image_builder.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ImageBuilder Example')),
      body: Column(
        children: [
          // Network image
          ImageBuilder(
            'https://picsum.photos/200/200',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          
          SizedBox(height: 20),
          
          // Local SVG with color
          ImageBuilder(
            'assets/icons/star.svg',
            size: 50,
            color: Colors.amber,
          ),
          
          SizedBox(height: 20),
          
          // Local PNG image
          ImageBuilder(
            'assets/images/photo.png',
            width: 150,
            height: 100,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
```

## API Reference

### ImageBuilder()

Creates an image widget from the given path. Supports both network URLs and local assets.

**Constructor:**
```dart
ImageBuilder(
  String path, {
  Key? key,
  double? width,
  double? height,
  double? size,
  Color? color,
  BoxFit fit = BoxFit.contain,
  Widget? placeholder,
  Widget? errorWidget,
  Duration? maxCacheAge,
  int? maxCacheSizeBytes,
  bool useAdaptiveLoading = true,
  Color? loadingColor,
})
```

**Parameters:**
- `path` (String): The image path or URL
- `width` (double?): The width of the image (ignored if `size` is provided)
- `height` (double?): The height of the image (ignored if `size` is provided)
- `size` (double?): Sets both width and height to the same value
- `color` (Color?): A color to apply to the image (works with SVGs)
- `fit` (BoxFit): How to fit the image within its bounds (default: BoxFit.contain)
- `placeholder` (Widget?): Widget to show while loading network images
- `errorWidget` (Widget?): Widget to show when image fails to load
- `useAdaptiveLoading` (bool): Whether to use platform-adaptive loading indicators (default: true)
- `loadingColor` (Color?): Color for the adaptive loading indicators

## Supported Formats

- **Network Images**: Any format supported by Flutter's network image loading
- **Local Assets**: PNG, JPG, JPEG, WEBP
- **Vector Graphics**: SVG (with color customization support)

## Dependencies

This package depends on:
- [cached_network_image](https://pub.dev/packages/cached_network_image) for network image caching
- [flutter_svg](https://pub.dev/packages/flutter_svg) for SVG rendering

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.