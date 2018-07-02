import 'package:shrub/shrub.dart';

class AnalysisResult {
  final AnalysisContext context;
  final List<ShrubException> errors = [];

  AnalysisResult(this.context, [Iterable<ShrubException> errors = const []]) {
    this.errors.addAll(context.errors);
    this.errors.addAll(errors ?? <ShrubException>[]);
  }

  AnalysisResultType get type => criticalErrors.isEmpty
      ? AnalysisResultType.success
      : AnalysisResultType.failure;

  List<ShrubException> get criticalErrors => foldErrors()
      .where((e) => e.severity == ShrubExceptionSeverity.error)
      .toList();

  List<ShrubException> foldErrors() {
    var out = <ShrubException>[];

    for (var err in errors) {
      if (!out.any((e) => e.span.start == err.span.start)) {
        out.add(err);
      }
    }

    return out;
  }
}

enum AnalysisResultType { success, failure }
