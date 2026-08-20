import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/validation/validators/tp_emis_validator.dart';

void main() {
  group('TpEmisValidator', () {
    final validator = TpEmisValidator();

    test('should accept normal emission', () {
      final result = validator.validate('1');

      expect(result, isNull);
    });

    test('should accept all defined tpEmis values', () {
      const validValues = [
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '9',
      ];

      for (final value in validValues) {
        expect(
          validator.validate(value),
          isNull,
          reason: 'tpEmis $value should be valid',
        );
      }
    });

    test('should reject invalid length', () {
      final result = validator.validate('12');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_length');
      expect(result.field, 'tpEmis');
    });

    test('should reject non numeric value', () {
      final result = validator.validate('A');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_format');
    });

    test('should reject undefined numeric value', () {
      final result = validator.validate('8');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_tp_emis');
    });

    test('should reject zero', () {
      final result = validator.validate('0');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_tp_emis');
    });
  });
}