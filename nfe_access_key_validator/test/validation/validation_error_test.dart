import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/validation/validation_error.dart';

void main() {
  group('ValidationError', () {
    test('should store field, code and message', () {
      const error = ValidationError(
        field: 'cUf',
        code: 'invalid_cuf',
        message: 'Código da UF inválido.',
      );

      expect(error.field, 'cUf');
      expect(error.code, 'invalid_cuf');
      expect(error.message, 'Código da UF inválido.');
    });
  });
}