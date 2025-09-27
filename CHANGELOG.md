# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-09-28

### Added
- 🎯 **Loading color customization**: New `loadingColor` parameter for customizing adaptive loading indicator colors
- 🔄 **Platform-adaptive loading indicators**: 
  - iOS/macOS: `CupertinoActivityIndicator` for native look
  - Android/Web/Others: `CircularProgressIndicator` for Material Design
- 🛡️ **Enhanced error handling**: Bulletproof network error handling prevents cascading crashes
- 🧪 **Comprehensive test suite**: 14+ test cases covering all functionality
- 📱 **Multi-platform support**: Full iOS, macOS, Android, Web compatibility
- 📖 **Extensive documentation**: Detailed README with examples and API reference
- 🔐 **macOS network permissions**: Proper entitlements for network image loading
- 📝 **Comprehensive comments**: All test files include detailed explanatory comments

### Changed
- ♻️ **Simplified API**: Single `ImageBuilder()` constructor replaces multiple factory methods
- 🎨 **Improved example app**: Clean, focused examples showcasing core functionality
- 📚 **Enhanced README**: Complete rewrite with better organization and examples

### Fixed
- 🐛 **Network error crashes**: Fixed cascading StackTrace errors in web environment
- 🔧 **Web compatibility**: Improved error handling for web-specific issues
- 🎯 **Loading indicator reliability**: Consistent behavior across all platforms

## [1.0.0] - 2025-09-27

### Added
- 🎉 **Initial release** of ImageBuilder package
- 🌐 **Network image support** with caching via `cached_network_image`
- 📱 **Local asset support** for PNG, JPG, JPEG, WEBP formats
- 🎨 **SVG support** with color customization via `flutter_svg`
- 🔍 **Automatic format detection** based on file extension
- ⚡ **Built-in error handling** and fallback widgets
- 🔄 **Loading placeholders** for network images
- 📏 **Flexible sizing options** (width/height or unified size parameter)
- 📊 **Comprehensive logging** for debugging
- 🏗️ **Multiple constructors**: `ImageBuilder.image()` and `ImageBuilder.network()`

### Features
- 🖼️ Multiple image format support
- 🌐 Network image caching
- 🎨 SVG color customization
- ⚡ Error handling with fallback widgets
- 🔄 Loading states for network images
- 📏 Flexible sizing options