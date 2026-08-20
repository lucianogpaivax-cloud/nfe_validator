import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/validation/validators/aamm_validator.dart';

void main() {
  group('AammValidator', () {
    final validator = AammValidator();

    test('should accept a valid AAMM', () {
      final result = validator.validate('2608');

      expect(result, isNull);
    });

    test('should accept January', () {
      final result = validator.validate('2601');

      expect(result, isNull);
    });

    test('should accept December', () {
      final result = validator.validate('2612');

      expect(result, isNull);
    });

    test('should reject invalid length', () {
      final result = validator.validate('268');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_length');
      expect(result.field, 'aamm');
    });

    test('should reject non numeric value', () {
      final result = validator.validate('26AB');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_format');
    });

    test('should reject month zero', () {
      final result = validator.validate('2600');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_month');
    });

    test('should reject month greater than 12', () {
      final result = validator.validate('2613');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_month');
    });
  });
}