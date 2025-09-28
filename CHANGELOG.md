# Chang## [1.1.3] - 2025-09-28

### Fixed
- 🎨 **Code formatting**: Applied `dart format` to all files to meet pub.dev static analysis requirements
- 🔧 **Package description**: Shortened description to meet pub.dev requirements (60-180 characters)
- 🔗 **URL validation**: Removed non-existent repository URLs to improve pub.dev scoring
- 📦 **Pub.dev compliance**: Fixed all issues identified in package analysis for maximum pub points

## [1.1.2] - 2025-09-28

### Fixed
- 🎨 **Code formatting**: Applied `dart format` to all files to meet pub.dev static analysis requirements
- 🔧 **Package description**: Shortened description to meet pub.dev requirements (60-180 characters)
- � **URL validation**: Removed unreachable repository URLs to improve pub.dev scoring
- �📦 **Pub.dev compliance**: Fixed all addressable issues identified in package analysis for better pub points
- ⚠️ **Platform support**: Note - Web platform limitations come from `cached_network_image` dependency, not package code

## [1.1.1] - 2025-09-28log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2025-09-28

### Fixed
- 🔧 **Package description**: Shortened description to meet pub.dev requirements (60-180 characters)
- 🔗 **URL validation**: Removed non-existent repository URLs to improve pub.dev scoring
- 📦 **Pub.dev compliance**: Fixed issues identified in package analysis for better pub points

## [1.1.0] - 2025-09-28

### Added
- 📁 **File image support**: New `ImageBuilder.file()` constructor for loading images from device files
- 💾 **Memory image support**: New `ImageBuilder.memory()` constructor for displaying images from Uint8List data
- 🎯 **Loading color customization**: New `loadingColor` parameter for customizing adaptive loading indicator colors
- 🔄 **Platform-adaptive loading indicators**: 
  - iOS/macOS: `CupertinoActivityIndicator` for native look
  - Android/Web/Others: `CircularProgressIndicator` for Material Design
- 🛡️ **Enhanced error handling**: Bulletproof network error handling prevents cascading crashes
- 🧪 **Comprehensive test suite**: 25+ test cases covering all functionality including file/memory images
- 📱 **Multi-platform support**: Full iOS, macOS, Android, Web compatibility
- 📖 **Enhanced example app**: Interactive file picker with cross-platform image upload functionality
- 🔐 **macOS network permissions**: Proper entitlements for network image loading
- 📝 **Comprehensive comments**: All test files include detailed explanatory comments

### Changed
- ♻️ **Simplified API**: Unified constructor patterns with cleaner parameter structure
- 🎨 **Improved example app**: Real device file picker integration showcasing ImageBuilder.file()
- 📚 **Enhanced README**: Complete rewrite with better organization, more examples, and updated API reference
- 🔧 **Updated dependencies**: flutter_svg updated to ^2.0.9 for better compatibility

### Fixed
- 🐛 **Network error crashes**: Fixed cascading StackTrace errors in web environment
- 🔧 **Web compatibility**: Improved error handling for web-specific issues
- 🎯 **Loading indicator reliability**: Consistent behavior across all platforms
- 📱 **File handling edge cases**: Better error recovery for invalid file paths and corrupted data

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