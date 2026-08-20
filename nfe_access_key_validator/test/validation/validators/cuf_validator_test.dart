import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/validation/validators/cuf_validator.dart';

void main() {
  group('CUfValidator', () {
    final validator = CUfValidator();

    test('should accept a valid cUF', () {
      final result = validator.validate('35');

      expect(result, isNull);
    });

    test('should accept DF code', () {
      final result = validator.validate('53');

      expect(result, isNull);
    });

    test('should reject invalid length', () {
      final result = validator.validate('3');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_length');
      expect(result.field, 'cUf');
    });

    test('should reject non numeric value', () {
      final result = validator.validate('SP');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_format');
    });

    test('should reject unknown numeric code', () {
      final result = validator.validate('99');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_cuf');
    });
  });
}