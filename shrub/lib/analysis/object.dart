import 'package:source_span/source_span.dart';
import 'type.dart';

class ShrubObject {
  final ShrubType type;
  final FileSpan span;

  ShrubObject(this.type, this.span);
}
