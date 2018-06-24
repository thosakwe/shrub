import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class ShrubObject {
  final ShrubPackage package;
  final ShrubType type;
  final FileSpan span;

  ShrubObject(this.package, this.type, this.span);
}
