# ImageBuilder Example App

A comprehensive Flutter example demonstrating all features of the ImageBuilder package.

## ✨ Features Demonstrated

- 🌐 **Network images** with platform-adaptive loading indicators
- 🎨 **SVG images** with custom color tinting
- 💾 **Memory images** loaded from asset bytes
- 📁 **File images** with cross-platform file picker integration
- 🎯 **Loading color customization** across different platforms
- 🛡️ **Error handling** with graceful fallbacks
- 📱 **Cross-platform compatibility** (iOS, Android, macOS, Web)

## 🚀 Running the Example

```bash
cd example
flutter run
```

## 📱 Platform Features

### Mobile (iOS/Android)
- Gallery selection using `image_picker`
- Camera capture functionality
- Native platform UI components

### Desktop (macOS/Windows/Linux)
- Native file picker integration
- Drag-and-drop support (where available)
- Desktop-optimized UI layouts

### Web
- File selection dialog
- Automatic fallback to memory images
- Responsive design

## 🎮 Interactive Elements

The example app includes:
- **Image upload button**: Pick images from gallery/camera (mobile) or file system (desktop)
- **Real-time preview**: See ImageBuilder.file() in action with your selected images
- **Platform detection**: UI automatically adapts to show appropriate controls
- **Error simulation**: Examples of error handling with invalid image paths

## 📚 Code Structure

The example demonstrates:
- Proper use of all ImageBuilder constructors
- Platform-specific conditional UI
- Error handling patterns
- Memory management for image bytes
- File picker integration across platforms

Perfect for learning how to integrate ImageBuilder into your own applications!
