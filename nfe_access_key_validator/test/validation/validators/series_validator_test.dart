import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/validation/validators/series_validator.dart';

void main() {
  group('SeriesValidator', () {
    final validator = SeriesValidator();

    test('should accept a valid series', () {
      final result = validator.validate('001');

      expect(result, isNull);
    });

    test('should accept series 000', () {
      final result = validator.validate('000');

      expect(result, isNull);
    });

    test('should accept series 999', () {
      final result = validator.validate('999');

      expect(result, isNull);
    });

    test('should reject invalid length', () {
      final result = validator.validate('01');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_length');
      expect(result.field, 'series');
    });

    test('should reject non numeric value', () {
      final result = validator.validate('A01');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_format');
    });
  });
}