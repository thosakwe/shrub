import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class ImportDirectiveContext {
  final bool isWith;
  final List<FileSpan> namespaces;
  final FileSpan span;

  ImportDirectiveContext(this.isWith, this.namespaces, this.span);
}
