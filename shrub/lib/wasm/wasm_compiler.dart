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

    var exports = <String>[];
    for (var symbol in module.scope.allVariables) {
      var value = symbol.value;

      if (value is ShrubFunction) {
        var fn = compileFunctionDeclaration(value);
        fn.copyInto(buf);

        if (symbol.visibility == Visibility.public) {
          exports.add('(export "${value.name}" (func \$${value.name}))');
        }
      }
    }

    exports.forEach(buf.writeln);

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
      if (param.type is UnknownType) {
        continue;
        // TODO: Log this, say skipping unused param
      }

      var type = compileType(param.type);
      buf.write(' (param \$${param.name} $type)');
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

    if (ctx is SimpleIdentifierContext) {
      return new CodeBuffer()..writeln('get_local \$${ctx.name}');
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
