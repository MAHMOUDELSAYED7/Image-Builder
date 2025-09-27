import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  });

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
        placeholder: (context, url) =>
            placeholder ?? const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) {
          _logger.error(
            'Failed to load network image: $path',
            tag: 'ImageBuilder',
            error: error,
            stackTrace: StackTrace.current,
          );
          return errorWidget ?? const Icon(Icons.error);
        },
      );
    }

    final match = _extensionRegex.firstMatch(path);
    final extension = match?.group(1)?.toLowerCase();

    if (extension == null) {
      _logger.error(
        'Invalid image path: $path',
        tag: 'ImageBuilder',
        error: Exception('No valid file extension found'),
        stackTrace: StackTrace.current,
      );
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
      } catch (e, stackTrace) {
        _logger.error(
          'Failed to load SVG asset: $path',
          tag: 'ImageBuilder',
          error: e,
          stackTrace: stackTrace,
        );
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
            _logger.error(
              'Failed to load image asset: $path',
              tag: 'ImageBuilder',
              error: error,
              stackTrace: stackTrace,
            );
            return errorWidget ?? const Icon(Icons.error);
          },
        );
      } catch (e, stackTrace) {
        _logger.error(
          'Failed to load image asset: $path',
          tag: 'ImageBuilder',
          error: e,
          stackTrace: stackTrace,
        );
        return errorWidget ?? const Icon(Icons.error);
      }
    }

    _logger.error(
      'Unsupported image format: $extension for path: $path',
      tag: 'ImageBuilder',
      error: UnsupportedError('Unsupported image format: $extension'),
      stackTrace: StackTrace.current,
    );
    return errorWidget ?? const Icon(Icons.error);
  }
}
