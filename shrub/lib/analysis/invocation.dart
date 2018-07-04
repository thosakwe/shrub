import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';

class ShrubInvocation extends ShrubObject {
  final ShrubFunction function;
  final Map<String, ShrubObject> arguments;
  final InvocationContext declaration;

  ShrubInvocation(
      Module module, this.function, this.arguments, this.declaration)
      : super(module, function.type.returnType, declaration.span);
}
