import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/validation/validators/model_validator.dart';

void main() {
  group('ModelValidator', () {
    final validator = ModelValidator();

    test('should accept model 55', () {
      final result = validator.validate('55');

      expect(result, isNull);
    });

    test('should reject invalid length', () {
      final result = validator.validate('5');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_length');
      expect(result.field, 'model');
    });

    test('should reject non numeric value', () {
      final result = validator.validate('AB');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_format');
    });

    test('should reject model different from 55', () {
      final result = validator.validate('65');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_model');
    });
  });
}