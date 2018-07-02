import 'package:code_buffer/code_buffer.dart';
import 'package:shrub/shrub.dart';
import 'package:symbol_table/symbol_table.dart';

// TODO: Support errors...?
class WasmCompiler {
  final Module module;

  WasmCompiler(this.module);

  CodeBuffer compile() {
    var buf = new CodeBuffer();
    buf
      ..writeln('(module')
      ..indent();

    for (var symbol in module.scope.allVariables) {
      var value = symbol.value;

      if (value is ShrubFunction) {
        var fn = compileFunctionDeclaration(value);
        fn.copyInto(buf);

        if (symbol.visibility == Visibility.public) {
          buf.writeln('(export "${value.name}" (func \$${value.name}))');
        }
      }
    }

    // TODO: Source maps in WASM...?

    return buf
      ..outdent()
      ..writeln(')');
  }

  CodeBuffer compileFunctionDeclaration(ShrubFunction ctx) {
    var buf = new CodeBuffer();
    buf.write('(func \$${ctx.name}');
    buf.lastLine.sourceMappings[ctx.span] = buf.lastLine.span;

    for (var param in ctx.parameters) {
      buf.write(' (param ${param.name})');
      buf.lastLine.sourceMappings[param.span] = buf.lastLine.span;
    }

    var returnType = compileType(ctx.returnType);
    buf
      ..writeln(' (result $returnType)')
      ..indent();

    var returnValue = compileExpression(ctx.declaration.expression);
    if (returnValue.lines.length == 1) {
      buf.write(returnValue.lines[0].text);
    } else {
      returnValue.copyInto(buf);
    }

    return buf..write(')');
  }

  CodeBuffer compileExpression(ExpressionContext ctx) {
    if (ctx is IntegerLiteralContext) {
      return new CodeBuffer()..write('i32.const ${ctx.constantValue}');
    }

    throw new UnimplementedError(
        'Cannot yet compile ${ctx.runtimeType} to WASM!!!');
  }

  String compileType(ShrubType ctx) {
    if (ctx is IntegerType) {
      return 'i32';
    }

    throw new UnimplementedError(
        'Cannot yet compile ${ctx.runtimeType} to WASM!!!');
  }
}
