import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/validation/validators/nnf_validator.dart';

void main() {
  group('NNfValidator', () {
    final validator = NNfValidator();

    test('should accept a valid NF-e number', () {
      final result = validator.validate('000001234');

      expect(result, isNull);
    });

    test('should accept the minimum NF-e number', () {
      final result = validator.validate('000000001');

      expect(result, isNull);
    });

    test('should accept the maximum NF-e number', () {
      final result = validator.validate('999999999');

      expect(result, isNull);
    });

    test('should reject zero', () {
      final result = validator.validate('000000000');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_number');
      expect(result.field, 'nNf');
    });

    test('should reject invalid length', () {
      final result = validator.validate('12345678');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_length');
    });

    test('should reject non numeric value', () {
      final result = validator.validate('00000A123');

      expect(result, isNotNull);
      expect(result!.code, 'invalid_format');
    });
  });
}