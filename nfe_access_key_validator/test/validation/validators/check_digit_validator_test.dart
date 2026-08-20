import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/models/nfe_access_key.dart';
import 'package:nfe_access_key_validator/src/parsers/access_key_parser.dart';
import 'package:nfe_access_key_validator/src/validation/validators/check_digit_validator.dart';

void main() {
  group('CheckDigitValidator', () {
    final validator = CheckDigitValidator();

    test('should accept a valid numeric access key check digit', () {
      const rawKey =
          '35260811222333000181550010000012341123456783';

      final accessKey = AccessKeyParser.parse(rawKey);

      final result = validator.validate(accessKey);

      expect(result, isNull);
    });

    test('should reject an invalid numeric access key check digit', () {
      const rawKey =
          '35260811222333000181550010000012341123456784';

      final accessKey = AccessKeyParser.parse(rawKey);

      final result = validator.validate(accessKey);

      expect(result, isNotNull);
      expect(result!.code, 'invalid_check_digit');
      expect(result.field, 'cDv');
    });

    test('should accept a valid alphanumeric CNPJ access key', () {
      const rawKey =
          '35260812ABC34501DE35550010000012341123456784';

      final accessKey = AccessKeyParser.parse(rawKey);

      final result = validator.validate(accessKey);

      expect(result, isNull);
    });

    test('should reject invalid check digit with alphanumeric CNPJ', () {
      const rawKey =
          '35260812ABC34501DE35550010000012341123456785';

      final accessKey = AccessKeyParser.parse(rawKey);

      final result = validator.validate(accessKey);

      expect(result, isNotNull);
      expect(result!.code, 'invalid_check_digit');
    });

    test('should reject non numeric check digit', () {
      const rawKey =
          '3526081122233300018155001000001234112345678A';

      final accessKey = AccessKeyParser.parse(rawKey);

      final result = validator.validate(accessKey);

      expect(result, isNotNull);
      expect(result!.code, 'invalid_format');
    });

    test('should reject check digit with invalid length', () {
      const accessKey = NfeAccessKey(
        cUf: '35',
        aamm: '2608',
        cnpj: '11222333000181',
        model: '55',
        series: '001',
        nNf: '000001234',
        tpEmis: '1',
        cNf: '12345678',
        cDv: '',
      );

      final result = validator.validate(accessKey);

      expect(result, isNotNull);
      expect(result!.code, 'invalid_length');
    });
  });
}