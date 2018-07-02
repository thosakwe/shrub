import 'package:shrub/shrub.dart';

class AnalysisResult {
  final AnalysisContext context;
  final AnalysisResultType type;
  final List<ShrubException> errors;

  AnalysisResult(this.context, this.type, this.errors);

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
