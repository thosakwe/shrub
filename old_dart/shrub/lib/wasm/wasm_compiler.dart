import 'package:code_buffer/code_buffer.dart';
import 'package:linear_memory/linear_memory.dart';
import 'package:shrub/shrub.dart';
import 'package:source_span/source_span.dart';
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

    if (ctx.declaration.isExternal) {
      // TODO: Better way of ensuring imports
      buf.write(' (import "imports" "${ctx.name}")');
    }

    for (var param in ctx.parameters) {
      if (param.type is UnknownType) {
        errors.add(new ShrubException(
            ShrubExceptionSeverity.warning,
            param.span,
            'Could not infer the type of parameter "${param.name}".'));
        continue;
      }

      var type = compileType(param.type, param.span);
      buf.write(' (param \$${param.name} $type)');
      buf.lastLine.sourceMappings[param.span] = buf.lastLine.span;
    }

    if (ctx.returnType is UnknownType) {
      errors.add(new ShrubException(
          ShrubExceptionSeverity.error,
          ctx.declaration.identifier.span,
          'Could not infer the return type of function "${ctx.name}".'));
      return null;
    }

    var returnType =
        compileType(ctx.returnType, ctx.declaration.identifier.span);
    buf..write(' (result $returnType)');

    if (ctx.declaration.isExternal) {
      return buf..write(')');
    } else {
      buf..writeln()..indent();
      var returnValue = compileExpression(ctx.declaration.expression);

      if (returnValue.isNotEmpty) {
        if (returnValue.lines.length == 1) {
          buf.write(returnValue.lines[0].text);
        } else {
          returnValue.copyInto(buf);
        }
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
      var targetType = compileType(ctx.resolved.type, ctx.span);

      if (targetType == null) {
        return null;
      } else {
        var op = compileBinaryOperator(ctx.operator);
        var buf = new CodeBuffer();
        compileExpression(ctx.right).copyInto(buf);
        compileExpression(ctx.left).copyInto(buf);
        buf.write('$targetType.$op');
        return buf;
      }
    }

    if (ctx is InvocationContext) {
      var invocation = ctx.resolved as ShrubInvocation;
      var fn = invocation.function;
      // TODO: WTF is the order of arguments to be passed?
      var buf = new CodeBuffer();

      for (var p in fn.parameters) {
        var arg = invocation.arguments[p.name];
        var b = compileExpression(arg);

        if (b == null) {
          errors.add(new ShrubException(ShrubExceptionSeverity.error, arg.span,
              'Encountered an error while compiling this argument.'));
          return null;
        } else {
          b.copyInto(buf);
        }
      }

      buf.writeln('call \$${fn.name}');
      return buf;
    }

    throw new UnimplementedError(
        'Cannot yet compile ${ctx.runtimeType} to WASM!!!');
  }

  String compileType(ShrubType ctx, FileSpan span) {
    if (ctx is IntegerType) {
      return 'i${ctx.size}';
    }

    if (ctx is FloatType) {
      return 'f64';
    }

    if (ctx is UnionType) {
      errors.add(new ShrubException(
          ShrubExceptionSeverity.error,
          span,
          '`${ctx.qualifiedName}` is a Shrub union type, ' +
              'and therefore cannot be compiled directly to WASM. ' +
              'To read a value labeled as a union type, you *must* ' +
              'use a `match` expression.',
          'Example: match (x) { case Foo => ... case Bar => ... }'));
      return null;
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
