import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/validation/nfe_access_key_validator.dart';

void main() {
  group('NfeAccessKeyValidator', () {
    const validator = NfeAccessKeyValidator();

    test('should accept a valid numeric NF-e access key', () {
      const rawKey =
          '35260811222333000181550010000012341123456783';

      final result = validator.validate(rawKey);

      expect(result.isValid, isTrue);
      expect(result.isInvalid, isFalse);
      expect(result.errors, isEmpty);
    });

    test('should accept a valid access key with alphanumeric CNPJ', () {
      const rawKey =
          '35260812ABC34501DE35550010000012341123456784';

      final result = validator.validate(rawKey);

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('should reject access key with invalid length', () {
      const rawKey = '123456';

      final result = validator.validate(rawKey);

      expect(result.isInvalid, isTrue);
      expect(result.errors, hasLength(1));
      expect(result.errors.first.field, 'accessKey');
      expect(result.errors.first.code, 'invalid_length');
    });

    test('should reject an invalid access key check digit', () {
      const rawKey =
          '35260811222333000181550010000012341123456784';

      final result = validator.validate(rawKey);

      expect(result.isInvalid, isTrue);

      expect(
        result.errors.any(
          (error) =>
              error.field == 'cDv' &&
              error.code == 'invalid_check_digit',
        ),
        isTrue,
      );
    });

    test('should collect multiple validation errors', () {
      const rawKey =
          '99261311222333000181650010000012348123456783';

      final result = validator.validate(rawKey);

      expect(result.isInvalid, isTrue);

      expect(
        result.errors.any(
          (error) =>
              error.field == 'cUf' &&
              error.code == 'invalid_cuf',
        ),
        isTrue,
      );

      expect(
        result.errors.any(
          (error) =>
              error.field == 'aamm' &&
              error.code == 'invalid_month',
        ),
        isTrue,
      );

      expect(
        result.errors.any(
          (error) =>
              error.field == 'model' &&
              error.code == 'invalid_model',
        ),
        isTrue,
      );

      expect(
        result.errors.any(
          (error) =>
              error.field == 'tpEmis' &&
              error.code == 'invalid_tp_emis',
        ),
        isTrue,
      );
    });

    test('should avoid cascading check digit error when base format is invalid',
        () {
      const rawKey =
          '35260812abc34501DE35550010000012341123456784';

      final result = validator.validate(rawKey);

      expect(result.isInvalid, isTrue);

      expect(
        result.errors.any(
          (error) =>
              error.field == 'cnpj' &&
              error.code == 'invalid_format',
        ),
        isTrue,
      );

      expect(
        result.errors.any(
          (error) => error.field == 'cDv',
        ),
        isFalse,
      );
    });
  });
}