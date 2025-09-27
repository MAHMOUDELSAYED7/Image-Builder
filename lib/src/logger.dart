import 'dart:developer' as developer;

/// A simple logger implementation for the ImageBuilder package
class Logger {
  const Logger();

  /// Log a warning message
  void warning(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? 'ImageBuilder',
      level: 900, // Warning level
    );
  }

  /// Log an error message
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? 'ImageBuilder',
      level: 1000, // Error level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log an info message
  void info(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? 'ImageBuilder',
      level: 800, // Info level
    );
  }

  /// Log a debug message
  void debug(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? 'ImageBuilder',
      level: 700, // Debug level
    );
  }
}
