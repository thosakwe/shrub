import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

abstract class TypeContext {
  FileSpan get span;

  ShrubType resolved;
}

class IdentifierTypeContext extends TypeContext {
  final IdentifierContext identifier;

  IdentifierTypeContext(this.identifier);

  @override
  FileSpan get span => identifier.span;
}

class StructTypeContext extends TypeContext {
  final FileSpan span;
  final List<StructFieldContext> fields;

  StructTypeContext(this.span, this.fields);
}

class StructFieldContext {
  final FileSpan span;
  final IdentifierContext identifier;
  final TypeContext type;

  StructFieldContext(this.span, this.identifier, this.type);
}
