# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-09-27

### Added
- Initial release of ImageBuilder package
- Support for network images with caching via `cached_network_image`
- Support for local asset images (PNG, JPG, JPEG, WEBP)
- Support for SVG images with color customization via `flutter_svg`
- Automatic format detection based on file extension
- Built-in error handling and fallback widgets
- Loading placeholders for network images
- Flexible sizing options (width/height or unified size parameter)
- Comprehensive logging for debugging
- Two main methods: `ImageBuilder.image()` and `ImageBuilder.network()`

### Features
- 🖼️ Multiple image format support
- 🌐 Network image caching
- 🎨 SVG color customization
- ⚡ Error handling with fallback widgets
- 🔄 Loading states for network images
- 📏 Flexible sizing options