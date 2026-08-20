import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/validation/validators/cnf_validator.dart';

void main() {
  group('CNfValidator', () {
    final validator = CNfValidator();

    test('should accept a valid cNF', () {
      final result = validator.validate('12345678');

      expect(result, isNull);
    });

    test('should accept cNF with leading zeros', () {
      final result = validator.validate('00001234');

      expect(result, isNull);
    });

    test('should accept all zeros', () {
      final result = validator.validate('00000000');

      expect(result, isNull);
    });

    test('should reject invalid length', () {
      final result = validator.validate('1234567');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_length');
      expect(result.field, 'cNf');
    });

    test('should reject non numeric value', () {
      final result = validator.validate('1234A678');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_format');
      expect(result.field, 'cNf');
    });
  });
}