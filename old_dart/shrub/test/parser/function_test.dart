import 'package:shrub/shrub.dart';
import 'package:test/test.dart';
import 'util.dart';

void main() {
  test('expects name after "fn"', () {
    expect(() => parse('fn'), prints(contains('Missing name for function.')));
  });

  test('expects arrow after name', () {
    expect(() => parse('fn foo'),
        prints(contains('Missing "=>" in function definition.')));
  });

  group('expects "]" with "["', () {
    test('throws if not present when there are no parameters', () {
      expect(() => parse('fn foo ['),
          prints(contains('Missing "]" in function definition.')));
    });

    test('throws if not present when there is one parameter', () {
      expect(() => parse('fn foo [a'),
          prints(contains('Missing "]" in function definition.')));
    });

    test('throws if not present when there are multiple parameters', () {
      expect(() => parse('fn foo [a,b,c'),
          prints(contains('Missing "]" in function definition.')));
    });
  });

  test('expects expression after arrow', () {
    expect(() => parse('fn foo =>'),
        prints(contains('Missing body for function.')));
  });

  test('parse successfully without parameters', () {
    var unit = parse('fn foo => 2');
    expect(unit.functions, isNotEmpty);

    var foo = unit.functions[0];
    expect(foo.identifier.name, 'foo');
    expect(foo.expression, const TypeMatcher<IntegerLiteralContext>());
  });

  test('parse successfully with one parameter', () {
    var unit = parse('fn foo [bar] => 2');
    expect(unit.functions, isNotEmpty);

    var foo = unit.functions[0];
    expect(foo.identifier.name, 'foo');
    expect(foo.expression, const TypeMatcher<IntegerLiteralContext>());
    expect(foo.parameters, hasLength(1));
    expect(foo.parameters[0].identifier.name, 'bar');
  });

  test('parse successfully with multiple parameters', () {
    var unit = parse('fn foo [bar, baz, quux] => 2');
    expect(unit.functions, isNotEmpty);

    var foo = unit.functions[0];
    expect(foo.identifier.name, 'foo');
    expect(foo.expression, const TypeMatcher<IntegerLiteralContext>());
    expect(foo.parameters, hasLength(3));
    expect(foo.parameters[0].identifier.name, 'bar');
    expect(foo.parameters[1].identifier.name, 'baz');
    expect(foo.parameters[2].identifier.name, 'quux');
  });
}
