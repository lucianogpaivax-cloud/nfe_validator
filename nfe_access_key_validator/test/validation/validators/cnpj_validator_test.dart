import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/validation/validators/cnpj_validator.dart';

void main() {
  group('CnpjValidator', () {
    final validator = CnpjValidator();

    test('should accept a valid numeric CNPJ', () {
      final result = validator.validate('11222333000181');

      expect(result, isNull);
    });

    test('should accept a valid alphanumeric CNPJ', () {
      final result = validator.validate('12ABC34501DE35');

      expect(result, isNull);
    });

    test('should reject invalid length', () {
      final result = validator.validate('12ABC34501DE3');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_length');
      expect(result.field, 'cnpj');
    });

    test('should reject lowercase letters', () {
      final result = validator.validate('12abc34501DE35');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_format');
    });

    test('should reject punctuation', () {
      final result = validator.validate('12ABC.4501DE35');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_format');
    });

    test('should reject letters in check digit positions', () {
      final result = validator.validate('12ABC34501DEAB');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_format');
    });

    test('should reject zero CNPJ', () {
      final result = validator.validate('00000000000000');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_cnpj');
    });

    test('should reject invalid check digits in numeric CNPJ', () {
      final result = validator.validate('11222333000182');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_check_digits');
    });

    test('should reject invalid check digits in alphanumeric CNPJ', () {
      final result = validator.validate('12ABC34501DE36');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_check_digits');
    });
  });
}