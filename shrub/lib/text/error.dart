import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class ShrubException implements Exception {
  final ShrubExceptionSeverity severity;
  final FileSpan span;
  final String _message;
  final String additionalDetails;

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

  ShrubException(this.severity, this.span, this._message,
      [this.additionalDetails]);

  String get message => additionalDetails == null
      ? _message
      : (_message + '\n$additionalDetails');

  String get toolString {
    return severityToString(severity) +
        ': ${span.start.toolString}' +
        additionalDetails;
  }

  @override
  String toString() {
    return '$toolString: $message';
  }
}

enum ShrubExceptionSeverity { hint, info, warning, error }
