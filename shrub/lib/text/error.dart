import 'package:source_span/source_span.dart';

class ShrubException implements Exception {
  final ShrubExceptionSeverity severity;
  final FileSpan span;
  final String message;

  static String severityToString(ShrubExceptionSeverity severity) {
    switch (severity) {
      case ShrubExceptionSeverity.hint:
        return 'hint';
      case ShrubExceptionSeverity.info:
        return 'info';
      case ShrubExceptionSeverity.warning:
        return 'warning';
      case ShrubExceptionSeverity.error:
        return 'error';
      default:
        throw new ArgumentError();
    }
  }

  ShrubException(this.severity, this.span, this.message);

  String get toolString {
    return severityToString(severity) + ': ${span.start.toolString}';
  }

  @override
  String toString() {
    return '$toolString: $message';
  }
}

enum ShrubExceptionSeverity { hint, info, warning, error }
