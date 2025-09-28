# ImageBuilder

A compreh```yaml
dependencies:
  image_builder: ^1.1.3
```ve Flutter package for handling various image types including network images, SVGs, local assets, file images, and memory images with advanced caching, platform-adaptive loading indicators, and robust error handling.

## ✨ Features

- 🖼️ **Multi-format support**: PNG, JPG, JPEG, WEBP, SVG
- 🌐 **Network image loading**: Built-in caching with CachedNetworkImage
- 📱 **Local asset support**: Seamless integration with Flutter assets
- 📁 **File image support**: Load images directly from device files
- 💾 **Memory image support**: Display images from Uint8List byte data
- 🎨 **SVG customization**: Color tinting and scaling for vector graphics
- ⚡ **Robust error handling**: Graceful fallbacks and custom error widgets
- 🔄 **Platform-adaptive loading**: 
  - iOS/macOS: Native `CupertinoActivityIndicator`
  - Android/Web: Material Design `CircularProgressIndicator`
- 🎯 **Loading color customization**: Custom colors for loading indicators
- 📏 **Flexible sizing**: Individual width/height or unified size parameter
- 🛡️ **Production-ready**: Comprehensive error handling prevents crashes
- 🧪 **Well-tested**: Extensive test suite with 25+ test cases covering all functionality

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  image_builder: ^1.1.1
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

Import the package:

```dart
import 'package:image_builder/image_builder.dart';
```

### Basic Usage

```dart
// Display any type of image (network, asset, SVG)
ImageBuilder('assets/images/logo.png')

// Display a network image with adaptive loading
ImageBuilder('https://example.com/image.jpg')
```

### 📐 Custom Sizing

```dart
// Using individual width and height
ImageBuilder(
  'assets/images/logo.svg',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)

// Using unified size (sets both width and height)
ImageBuilder(
  'assets/images/icon.png',
  size: 50,
)
```

### 🎨 SVG Color Customization

```dart
// Tint SVG with custom colors
ImageBuilder(
  'assets/icons/heart.svg',
  size: 24,
  color: Colors.red, // Apply red tint to SVG
)
```

### 📁 File Images

```dart
import 'dart:io';

// Display image from device file
final File imageFile = File('/path/to/image.jpg');
ImageBuilder.file(
  imageFile,
  width: 200,
  height: 150,
  fit: BoxFit.cover,
)
```

### 💾 Memory Images

```dart
import 'dart:typed_data';

// Display image from memory bytes
final Uint8List imageBytes = await getImageBytes();
ImageBuilder.memory(
  imageBytes,
  width: 200,
  height: 150,
  fit: BoxFit.cover,
)
```

### 🔄 Platform-Adaptive Loading

The package automatically uses platform-appropriate loading indicators:

```dart
// Automatic platform detection
ImageBuilder(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  useAdaptiveLoading: true, // Default: true
)

// Force Material Design loading (all platforms)
ImageBuilder(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  useAdaptiveLoading: false,
)
```

**Platform Behavior:**
- **iOS/macOS**: Uses `CupertinoActivityIndicator` for native look
- **Android/Web/Others**: Uses `CircularProgressIndicator` for Material Design

### 🎯 Custom Loading Colors

Personalize your loading indicators with custom colors:

```dart
// Blue loading indicator
ImageBuilder(
  'https://example.com/large-image.jpg',
  width: 200,
  height: 200,
  useAdaptiveLoading: true,
  loadingColor: Colors.blue, // Works on both Cupertino and Material indicators
)

// Custom color with hex value
ImageBuilder(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  loadingColor: Color(0xFF6B46C1), // Custom purple
)
```

### 🛡️ Advanced Error Handling

```dart
ImageBuilder(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  placeholder: Container(
    color: Colors.grey[200],
    child: const CircularProgressIndicator(),
  ),
  errorWidget: Container(
    color: Colors.red[100],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, color: Colors.red),
        Text('Failed to load image'),
      ],
    ),
  ),
)
```

## 📚 Complete Example

Here's a comprehensive example showcasing all major features:

```dart
import 'package:flutter/material.dart';
import 'package:image_builder/image_builder.dart';

class ImageGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ImageBuilder Examples')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Network image with adaptive loading
            ImageBuilder(
              'https://picsum.photos/300/200',
              width: 300,
              height: 200,
              fit: BoxFit.cover,
              loadingColor: Colors.blue,
            ),
            
            SizedBox(height: 20),
            
            // SVG with custom color
            ImageBuilder(
              'assets/icons/star.svg',
              size: 60,
              color: Colors.amber,
            ),
            
            SizedBox(height: 20),
            
            // Local image with error handling
            ImageBuilder(
              'assets/images/photo.png',
              width: 200,
              height: 150,
              fit: BoxFit.cover,
              errorWidget: Container(
                width: 200,
                height: 150,
                color: Colors.grey[200],
                child: Icon(Icons.broken_image, size: 50),
              ),
            ),

            SizedBox(height: 20),
            
            // File image
            ImageBuilder.file(
              File('/path/to/device/image.jpg'),
              width: 200,
              height: 150,
              fit: BoxFit.cover,
            ),

            SizedBox(height: 20),
            
            // Memory image
            ImageBuilder.memory(
              imageBytes, // Uint8List
              width: 200,
              height: 150,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🎮 Interactive Example App

The package includes a comprehensive example app that demonstrates all features including **device image upload functionality**:

- **Gallery Selection**: Pick images from your device's photo library
- **Camera Capture**: Take new photos directly from the camera
- **Cross-Platform**: Works on iOS, Android, macOS, and other Flutter-supported platforms
- **Real-time Preview**: See ImageBuilder.file() in action with your own images

To run the example app:

```bash
cd example
flutter run
```

The example app showcases:
- Network image loading with adaptive indicators
- SVG rendering with color customization  
- Memory image display from asset bytes (using `photo.jpg`)
- **Cross-platform file picker** using ImageBuilder.file() (works on Mobile, Desktop & Web)
- **Device image upload** using ImageBuilder.file() (gallery/camera selection for mobile)
- Error handling and fallback widgets
- All supported image formats

**Platform Support**:
- **Mobile (iOS/Android)**: Gallery selection using ImageBuilder.file()
- **Desktop (macOS/Windows/Linux)**: Native file picker using ImageBuilder.file()
- **Web**: File selection with automatic fallback to ImageBuilder.memory()

**Smart Platform Detection**: The example app automatically shows the appropriate UI based on your platform - file picker on desktop/web or gallery selection on mobile.

Perfect for testing the package capabilities and understanding implementation patterns!

## 📖 API Reference

### ImageBuilder Constructors

The ImageBuilder widget provides multiple constructors for different image sources.

#### Default Constructor (Path-based)
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

#### File Constructor
```dart
ImageBuilder.file(
  File file, {
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

#### Memory Constructor
```dart
ImageBuilder.memory(
  Uint8List bytes, {
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

### Parameters

| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `path` | `String` | **Required for default constructor.** Image path or URL (network, asset, or local) | - |
| `file` | `File` | **Required for file constructor.** File object to load image from | - |
| `bytes` | `Uint8List` | **Required for memory constructor.** Image data as bytes | - |
| `width` | `double?` | Image width in logical pixels (ignored if `size` provided) | `null` |
| `height` | `double?` | Image height in logical pixels (ignored if `size` provided) | `null` |
| `size` | `double?` | Sets both width and height to same value | `null` |
| `color` | `Color?` | Tint color for SVG images | `null` |
| `fit` | `BoxFit` | How image should be inscribed into layout space | `BoxFit.contain` |
| `placeholder` | `Widget?` | Custom widget shown while loading (overrides adaptive loading) | `null` |
| `errorWidget` | `Widget?` | Custom widget shown when loading fails | `null` |
| `maxCacheAge` | `Duration?` | Maximum cache duration for network images | `null` |
| `maxCacheSizeBytes` | `int?` | Maximum cache size in bytes | `null` |
| `useAdaptiveLoading` | `bool` | Enable platform-adaptive loading indicators | `true` |
| `loadingColor` | `Color?` | Custom color for adaptive loading indicators | `null` |

## 🎯 Supported Image Formats

### Network Images
- **All formats** supported by Flutter's network image loading
- **HTTPS/HTTP** protocols supported
- **Automatic caching** with `CachedNetworkImage`
- **Custom cache duration** and size limits

### Local Assets  
- **PNG, JPG, JPEG**: Standard raster formats
- **WEBP**: Modern efficient format
- **Assets folder** integration with `pubspec.yaml`

### Vector Graphics
- **SVG**: Scalable vector graphics with color customization
- **Color tinting**: Apply any color to SVG elements
- **Perfect scaling**: No quality loss at any size

## 🔧 Platform Support

| Platform | Adaptive Loading | Network Images | Local Assets | SVG Support |
|----------|------------------|----------------|--------------|-------------|
| **iOS** | ✅ Cupertino | ✅ | ✅ | ✅ |
| **macOS** | ✅ Cupertino | ✅ | ✅ | ✅ |
| **Android** | ✅ Material | ✅ | ✅ | ✅ |
| **Web** | ✅ Material | ✅ | ✅ | ✅ |
| **Windows** | ✅ Material | ✅ | ✅ | ✅ |
| **Linux** | ✅ Material | ✅ | ✅ | ✅ |

*_macOS requires network entitlements for network images_

## 🔗 Dependencies

This package uses these well-maintained dependencies:

- **[cached_network_image](https://pub.dev/packages/cached_network_image)** `^3.3.0` - Network image caching and loading
- **[flutter_svg](https://pub.dev/packages/flutter_svg)** `^2.0.9` - SVG rendering and color customization

## 🧪 Testing

The package includes comprehensive tests covering:

- ✅ **Platform-adaptive loading** behavior across all platforms
- ✅ **Loading color customization** functionality
- ✅ **Network error handling** and recovery
- ✅ **File image loading** with proper error handling
- ✅ **Memory image display** from Uint8List data
- ✅ **Graceful error states** without crashes
- ✅ **Cross-platform compatibility** testing
- ✅ **SVG color tinting** and rendering
- ✅ **Robust widget construction** for all image types

Run tests with:
```bash
flutter test
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 

For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

MIT License - see the [LICENSE](LICENSE) file for details.