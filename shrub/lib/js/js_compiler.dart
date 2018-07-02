import 'package:code_buffer/code_buffer.dart';
import 'package:shrub/shrub.dart';
import 'package:source_maps/source_maps.dart';

// TODO: Support errors...?
class JSCompiler {
  final SourceMapBuilder sourceMapBuilder = new SourceMapBuilder();
  final Module module;

  JSCompiler(this.module);

  CodeBuffer compile() {
    var buf = new CodeBuffer();

    for (var symbol in module.scope.allVariables) {
      var value = symbol.value;

      if (value is ShrubFunction) {
        var fn = compileFunctionDeclaration(value);
        fn.copyInto(buf);
      }
    }

    for (var line in buf.lines) {
      line.sourceMappings.forEach(sourceMapBuilder.addSpan);
    }

    return buf;
  }

  CodeBuffer compileFunctionDeclaration(ShrubFunction ctx) {
    var buf = new CodeBuffer();
    buf.write('function ${ctx.name}(');
    buf.lastLine.sourceMappings[ctx.span] = buf.lastLine.span;

    int i = 0;
    for (var param in ctx.parameters) {
      if (i++ > 0) buf.write(', ');
      buf.write(param.name);
      buf.lastLine.sourceMappings[param.span] = buf.lastLine.span;
    }

    buf
      ..writeln(') {')
      ..indent();

    var returnValue = compileExpression(ctx.declaration.expression);
    buf.write('return ');
    returnValue.copyInto(buf);

    return buf
      ..outdent()
      ..writeln('}');
  }

  CodeBuffer compileExpression(ExpressionContext ctx) {
    if (ctx is IntegerLiteralContext) {
      return new CodeBuffer()..writeln(ctx.constantValue);
    }

    throw new UnimplementedError(
        'Cannot yet compile ${ctx.runtimeType} to JS!!!');
  }
}
