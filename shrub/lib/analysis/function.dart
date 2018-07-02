import 'package:shrub/shrub.dart';
import 'package:source_span/src/file.dart';

class ShrubFunction extends ShrubObject {
  final List<ShrubFunctionParameter> parameters = [];
  final FunctionContext declaration;
  String name = '(anonymous function)';
  ShrubType returnType;

  ShrubFunction(Module module, this.declaration)
      : super(module, null, declaration.span);

  @override
  FunctionType get type => new FunctionType(module, name)
    ..parameters.addAll(parameters.map((p) => p.type))
    ..returnType = returnType;
}

class ShrubFunctionParameter extends ShrubObject {
  final String name;
  final FileSpan span;

  ShrubType _type;

  ShrubFunctionParameter(Module module, this.name, this._type, this.span)
      : super(module, null, span);

  @override
  ShrubType get type => _type;

  void set type(ShrubType value) {
    if (_type is UnknownType) {
      _type = value;
    } else if (_type is UnionType) {
      (_type as UnionType).alternatives.add(value);
    } else {
      _type = new UnionType(module)..alternatives.addAll([_type, value]);
    }
  }
}
