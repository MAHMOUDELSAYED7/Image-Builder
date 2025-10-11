import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';

import 'logger.dart';

/// A versatile image widget builder that handles various image types including
/// network images, SVGs, local assets, file images, and memory images with caching and error handling.
class ImageBuilder extends StatelessWidget {
  /// The image source - can be a String (path/URL), File, or Uint8List
  final Object source;

  /// The width of the image (ignored if [size] is provided)
  final double? width;

  /// The height of the image (ignored if [size] is provided)
  final double? height;

  /// Sets both width and height to the same value
  final double? size;

  /// A color to apply to the image
  final Color? color;

  /// How to fit the image within its bounds
  final BoxFit fit;

  /// Widget to show while loading network images
  final Widget? placeholder;

  /// Widget to show when image fails to load
  final Widget? errorWidget;

  /// Maximum cache age for network images (currently unused)
  final Duration? maxCacheAge;

  /// Maximum cache size in bytes (currently unused)
  final int? maxCacheSizeBytes;

  /// Whether to use platform-adaptive loading indicators (iOS: CupertinoActivityIndicator, Android: CircularProgressIndicator)
  /// Defaults to true. Only applies when no custom placeholder is provided.
  final bool useAdaptiveLoading;

  /// Color for the adaptive loading indicator
  /// If null, uses the default theme colors
  final Color? loadingColor;

  static final Logger _logger = Logger();

  static final RegExp _extensionRegex = RegExp(
    r'\.([a-zA-Z0-9]+)(?:\?.*)?$',
    caseSensitive: false,
  );

  /// Creates an ImageBuilder widget that automatically detects the image source type.
  ///
  /// The [source] can be:
  /// - A String: Network URL (http:// or https://) or local asset path
  /// - A File: Image file from device storage
  /// - A Uint8List: Image data in memory
  const ImageBuilder(
    this.source, {
    super.key,
    this.width,
    this.height,
    this.size,
    this.color,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
    this.maxCacheAge,
    this.maxCacheSizeBytes,
    this.useAdaptiveLoading = true,
    this.loadingColor,
  });

  /// Creates an ImageBuilder from a File.
  ///
  /// **Deprecated:** Use `ImageBuilder(file)` instead.
  ///
  /// This constructor will be removed in a future version.
  /// Migration: Replace `ImageBuilder.file(myFile)` with `ImageBuilder(myFile)`
  @Deprecated(
      'Use ImageBuilder(file) instead. This constructor will be removed in version 2.0.0')
  const ImageBuilder.file(
    File file, {
    super.key,
    this.width,
    this.height,
    this.size,
    this.color,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
    this.maxCacheAge,
    this.maxCacheSizeBytes,
    this.useAdaptiveLoading = true,
    this.loadingColor,
  }) : source = file;

  /// Creates an ImageBuilder from memory bytes (Uint8List).
  ///
  /// **Deprecated:** Use `ImageBuilder(bytes)` instead.
  ///
  /// This constructor will be removed in a future version.
  /// Migration: Replace `ImageBuilder.memory(myBytes)` with `ImageBuilder(myBytes)`
  @Deprecated(
      'Use ImageBuilder(bytes) instead. This constructor will be removed in version 2.0.0')
  const ImageBuilder.memory(
    Uint8List bytes, {
    super.key,
    this.width,
    this.height,
    this.size,
    this.color,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
    this.maxCacheAge,
    this.maxCacheSizeBytes,
    this.useAdaptiveLoading = true,
    this.loadingColor,
  }) : source = bytes;

  /// Creates a platform-adaptive loading indicator
  /// iOS/macOS: CupertinoActivityIndicator
  /// Android/Web/Others: CircularProgressIndicator
  Widget _buildAdaptiveLoadingIndicator() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoActivityIndicator(
          color: loadingColor,
        );
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return CircularProgressIndicator(
          color: loadingColor,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (size != null && (width != null || height != null)) {
      _logger.warning(
        'Both size and width/height provided. Using size.',
        tag: 'ImageBuilder',
      );
    }
    final effectiveWidth = size ?? width;
    final effectiveHeight = size ?? height;

    // Detect source type and build appropriate image widget
    if (source is File) {
      return _buildFileImage(source as File, effectiveWidth, effectiveHeight);
    } else if (source is Uint8List) {
      return _buildMemoryImage(
          source as Uint8List, effectiveWidth, effectiveHeight);
    } else if (source is String) {
      return _buildPathImage(source as String, effectiveWidth, effectiveHeight);
    } else {
      // Unsupported source type
      _logger.error(
        'Unsupported image source type: ${source.runtimeType}',
        tag: 'ImageBuilder',
        error: UnsupportedError(
            'Source must be String, File, or Uint8List, got ${source.runtimeType}'),
        stackTrace: null,
      );
      return errorWidget ?? const Icon(Icons.error);
    }
  }

  /// Build image from file
  Widget _buildFileImage(File file, double? width, double? height) {
    return Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        try {
          _logger.error(
            'Failed to load file image: ${file.path}',
            tag: 'ImageBuilder',
            error: error,
            stackTrace: null, // Avoid generating stack trace in error handlers
          );
        } catch (loggingError) {
          // If logging fails, continue without logging to prevent cascade errors
        }
        return errorWidget ?? const Icon(Icons.error);
      },
    );
  }

  /// Build image from memory bytes
  Widget _buildMemoryImage(Uint8List bytes, double? width, double? height) {
    return Image.memory(
      bytes,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        try {
          _logger.error(
            'Failed to load memory image',
            tag: 'ImageBuilder',
            error: error,
            stackTrace: null, // Avoid generating stack trace in error handlers
          );
        } catch (loggingError) {
          // If logging fails, continue without logging to prevent cascade errors
        }
        return errorWidget ?? const Icon(Icons.error);
      },
    );
  }

  /// Build image from path (network or asset)
  Widget _buildPathImage(String imagePath, double? width, double? height) {
    // Handle network images
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        placeholder: (context, url) =>
            placeholder ??
            Center(
                child: useAdaptiveLoading
                    ? _buildAdaptiveLoadingIndicator()
                    : CircularProgressIndicator(color: loadingColor)),
        errorWidget: (context, url, error) {
          try {
            _logger.error(
              'Failed to load network image: $url',
              tag: 'ImageBuilder',
              error: error,
              stackTrace:
                  null, // Avoid generating stack trace in error handlers
            );
          } catch (loggingError) {
            // If logging fails, continue without logging to prevent cascade errors
          }
          return errorWidget ?? const Icon(Icons.error);
        },
      );
    }

    // Handle local asset images
    return _buildAssetImage(imagePath, width, height);
  }

  /// Build asset image (SVG or regular assets)
  Widget _buildAssetImage(String imagePath, double? width, double? height) {
    final match = _extensionRegex.firstMatch(imagePath);
    final extension = match?.group(1)?.toLowerCase();

    if (extension == null) {
      try {
        _logger.error(
          'Invalid image path: $imagePath',
          tag: 'ImageBuilder',
          error: Exception('No valid file extension found'),
          stackTrace: null, // Avoid generating stack trace in error handlers
        );
      } catch (loggingError) {
        // If logging fails, continue without logging to prevent cascade errors
      }
      return errorWidget ?? const Icon(Icons.error);
    }

    // Handle SVG files
    if (extension == 'svg') {
      return SvgPicture.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        placeholderBuilder: (context) =>
            placeholder ??
            Center(
                child: useAdaptiveLoading
                    ? _buildAdaptiveLoadingIndicator()
                    : CircularProgressIndicator(color: loadingColor)),
      );
    }

    // Handle raster image files
    if (['png', 'jpg', 'jpeg', 'webp'].contains(extension)) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) {
          try {
            _logger.error(
              'Failed to load asset image: $imagePath',
              tag: 'ImageBuilder',
              error: error,
              stackTrace:
                  null, // Avoid generating stack trace in error handlers
            );
          } catch (loggingError) {
            // If logging fails, continue without logging to prevent cascade errors
          }
          return errorWidget ?? const Icon(Icons.error);
        },
      );
    }

    // Unsupported file format
    try {
      _logger.error(
        'Unsupported image format: $extension for path: $imagePath',
        tag: 'ImageBuilder',
        error: UnsupportedError('Unsupported image format: $extension'),
        stackTrace: null, // Avoid generating stack trace in error handlers
      );
    } catch (loggingError) {
      // If logging fails, continue without logging to prevent cascade errors
    }
    return errorWidget ?? const Icon(Icons.error);
  }
}
