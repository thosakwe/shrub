import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class ShrubObject {
  final List<SymbolUsage> usages = [];
  final Module module;
  final ShrubType type;
  final FileSpan span;

  ShrubObject(this.module, this.type, this.span);
}

class SymbolUsage {
  final SymbolUsageType type;
  final FileSpan span;

  SymbolUsage(this.type, this.span);
}

enum SymbolUsageType {
  read,
  write,
  invocation,
}
