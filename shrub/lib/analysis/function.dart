import 'package:shrub/shrub.dart';
import 'package:source_span/src/file.dart';

class ShrubFunction extends ShrubObject {
  final List<ShrubFunctionParameter> parameters = [];
  String name = '(anonymous function)';
  ShrubType returnType;

  ShrubFunction(ShrubPackage package, FileSpan span)
      : super(package, null, span);

  @override
  ShrubFunctionType get type => new ShrubFunctionType(package, name)
    ..parameters.addAll(parameters.map((p) => p.type))
    ..returnType = returnType;
}

class ShrubFunctionParameter {
  final String name;
  final FileSpan span;
  ShrubType type;

  ShrubFunctionParameter(this.name, this.span);
}
