import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';

import 'logger.dart';

/// A versatile image widget builder that handles various image types including
/// network images, SVGs, and local assets with caching and error handling.
class ImageBuilder extends StatelessWidget {
  /// The image path or URL
  final String path;

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

  /// Creates an ImageBuilder widget.
  ///
  /// The [path] can be:
  /// - A network URL (http:// or https://)
  /// - A local asset path (for SVG, PNG, JPG, JPEG, WEBP files)
  const ImageBuilder(
    this.path, {
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

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: path,
        width: effectiveWidth,
        height: effectiveHeight,
        fit: fit,
        color: color,
        placeholder: (context, url) => placeholder ?? 
            Center(child: useAdaptiveLoading 
                ? _buildAdaptiveLoadingIndicator() 
                : CircularProgressIndicator(color: loadingColor)),
        errorWidget: (context, url, error) {
          try {
            _logger.error(
              'Failed to load network image: $url',
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

    final match = _extensionRegex.firstMatch(path);
    final extension = match?.group(1)?.toLowerCase();

    if (extension == null) {
      try {
        _logger.error(
          'Invalid image path: $path',
          tag: 'ImageBuilder',
          error: Exception('No valid file extension found'),
          stackTrace: null, // Avoid generating stack trace in error handlers
        );
      } catch (loggingError) {
        // If logging fails, continue without logging to prevent cascade errors
      }
      return errorWidget ?? const Icon(Icons.error);
    }

    if (extension == 'svg') {
      try {
        return SvgPicture.asset(
          path,
          width: effectiveWidth,
          height: effectiveHeight,
          fit: fit,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        );
      } catch (e) {
        try {
          _logger.error(
            'Failed to load SVG asset: $path',
            tag: 'ImageBuilder',
            error: e,
            stackTrace: null, // Avoid passing stack traces in web environment
          );
        } catch (loggingError) {
          // If logging fails, continue without logging to prevent cascade errors
        }
        return errorWidget ?? const Icon(Icons.error);
      }
    }

    if (['png', 'jpg', 'jpeg', 'webp'].contains(extension)) {
      try {
        return Image.asset(
          path,
          width: effectiveWidth,
          height: effectiveHeight,
          fit: fit,
          color: color,
          filterQuality: FilterQuality.medium,
          errorBuilder: (context, error, stackTrace) {
            try {
              _logger.error(
                'Failed to load image asset: $path',
                tag: 'ImageBuilder',
                error: error,
                stackTrace: null, // Avoid passing stack traces in web environment
              );
            } catch (loggingError) {
              // If logging fails, continue without logging to prevent cascade errors
            }
            return errorWidget ?? const Icon(Icons.error);
          },
        );
      } catch (e) {
        try {
          _logger.error(
            'Failed to load image asset: $path',
            tag: 'ImageBuilder',
            error: e,
            stackTrace: null, // Avoid passing stack traces in web environment
          );
        } catch (loggingError) {
          // If logging fails, continue without logging to prevent cascade errors
        }
        return errorWidget ?? const Icon(Icons.error);
      }
    }

    try {
      _logger.error(
        'Unsupported image format: $extension for path: $path',
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
