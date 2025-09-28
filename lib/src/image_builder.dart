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
  /// The image path or URL (for network and asset images)
  final String? path;

  /// File object for file-based images
  final File? file;

  /// Memory bytes for memory-based images
  final Uint8List? bytes;

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

  /// Creates an ImageBuilder widget from a path (network URL or asset path).
  ///
  /// The [path] can be:
  /// - A network URL (http:// or https://)
  /// - A local asset path (for SVG, PNG, JPG, JPEG, WEBP files)
  const ImageBuilder(
    String this.path, {
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
  })  : file = null,
        bytes = null;

  /// Creates an ImageBuilder widget from a File object.
  ///
  /// The [file] should be a valid image file (PNG, JPG, JPEG, WEBP).
  const ImageBuilder.file(
    this.file, {
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
  })  : path = null,
        bytes = null;

  /// Creates an ImageBuilder widget from memory bytes.
  ///
  /// The [bytes] should contain valid image data (PNG, JPG, JPEG, WEBP).
  const ImageBuilder.memory(
    this.bytes, {
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
  })  : path = null,
        file = null;

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

    // Handle file images
    if (file != null) {
      return _buildFileImage(effectiveWidth, effectiveHeight);
    }

    // Handle memory images
    if (bytes != null) {
      return _buildMemoryImage(effectiveWidth, effectiveHeight);
    }

    // Handle path-based images (network and assets)
    if (path != null) {
      return _buildPathImage(path!, effectiveWidth, effectiveHeight);
    }

    // If none of the image sources are provided, show error
    return errorWidget ?? const Icon(Icons.error);
  }

  /// Build image from file
  Widget _buildFileImage(double? width, double? height) {
    return Image.file(
      file!,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        try {
          _logger.error(
            'Failed to load file image: ${file!.path}',
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
  Widget _buildMemoryImage(double? width, double? height) {
    return Image.memory(
      bytes!,
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
