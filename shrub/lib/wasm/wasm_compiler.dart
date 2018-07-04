import 'package:code_buffer/code_buffer.dart';
import 'package:linear_memory/linear_memory.dart';
import 'package:shrub/shrub.dart';
import 'package:symbol_table/symbol_table.dart';

// TODO: Support errors...?
class WasmCompiler {
  final List<ShrubException> errors = [];
  final LinearMemory<ShrubObject> memory =
      new LinearMemory<ShrubObject>(64 * 1024);
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
        if (fn == null) continue;
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
        errors.add(new ShrubException(
            ShrubExceptionSeverity.warning,
            param.span,
            'Could not infer the type of parameter "${param.name}".'));
        continue;
      }

      var type = compileType(param.type);
      buf.write(' (param \$${param.name} $type)');
      buf.lastLine.sourceMappings[param.span] = buf.lastLine.span;
    }

    if (ctx.returnType is UnknownType) {
      errors.add(new ShrubException(ShrubExceptionSeverity.warning, ctx.span,
          'Could not infer the return type of function "${ctx.name}".'));
      return null;
    }

    var returnType = compileType(ctx.returnType);
    buf
      ..writeln(' (result $returnType)')
      ..indent();

    var returnValue = compileExpression(ctx.declaration.expression);

    if (buf.isNotEmpty) {
      if (returnValue.lines.length == 1) {
        buf.write(returnValue.lines[0].text);
      } else {
        returnValue.copyInto(buf);
      }
    }

    return buf
      ..writeln()
      ..outdent()
      ..write(')');
  }

  CodeBuffer compileExpression(ExpressionContext ctx) {
    if (ctx is IntegerLiteralContext) {
      var constantValue = ctx.getConstantValue(errors.add);
      var size = (ctx.resolved.type as IntegerType).size;
      return constantValue == null ? null : new CodeBuffer()
        ..write('i$size.const $constantValue');
    }

    if (ctx is FloatLiteralContext) {
      var constantValue = ctx.getConstantValue(errors.add);
      return constantValue == null ? null : new CodeBuffer()
        ..write('f64.const $constantValue');
    }

    if (ctx is SimpleIdentifierContext) {
      return new CodeBuffer()..writeln('get_local \$${ctx.name}');
    }

    if (ctx is BinaryContext) {
      // TODO: Handle booleans?
      var targetType = compileType(ctx.resolved.type);
      var op = compileBinaryOperator(ctx.operator);
      var buf = new CodeBuffer();
      compileExpression(ctx.right).copyInto(buf);
      compileExpression(ctx.left).copyInto(buf);
      buf.write('$targetType.$op');
      return buf;
    }

    throw new UnimplementedError(
        'Cannot yet compile ${ctx.runtimeType} to WASM!!!');
  }

  String compileType(ShrubType ctx) {
    if (ctx is IntegerType) {
      return 'i${ctx.size}';
    }

    if (ctx is FloatType) {
      return 'f64';
    }

    throw new UnimplementedError(
        'Cannot yet compile ${ctx.runtimeType} to WASM!!!');
  }

  String compileBinaryOperator(Token token) {
    switch (token.type) {
      case TokenType.times:
        return 'mul';
      case TokenType.divide:
        return 'div';
      case TokenType.plus:
        return 'add';
      case TokenType.minus:
        return 'sub';
      default:
        throw new UnimplementedError(
            'Cannot yet compile operator "${token.span.text}" to WASM!!!');
    }
  }
}
