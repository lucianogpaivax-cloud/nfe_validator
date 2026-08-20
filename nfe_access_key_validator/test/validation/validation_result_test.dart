import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/validation/validation_error.dart';
import 'package:nfe_access_key_validator/src/validation/validation_result.dart';

void main() {
  group('ValidationResult', () {
    test('should be valid when there are no errors', () {
      const result = ValidationResult();

      expect(result.isValid, isTrue);
      expect(result.isInvalid, isFalse);
      expect(result.errors, isEmpty);
    });

    test('should be invalid when there are errors', () {
      const error = ValidationError(
        field: 'cUf',
        code: 'invalid_cuf',
        message: 'Código da UF inválido.',
      );

      const result = ValidationResult(
        errors: [error],
      );

      expect(result.isValid, isFalse);
      expect(result.isInvalid, isTrue);
      expect(result.errors, hasLength(1));
      expect(result.errors.first.field, 'cUf');
    });
  });
}