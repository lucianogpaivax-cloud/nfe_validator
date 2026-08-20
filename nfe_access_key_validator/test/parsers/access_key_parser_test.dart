import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/parsers/access_key_parser.dart';

void main() {
  group('AccessKeyParser', () {
    test('should parse all fields from a 44-character access key', () {
      const rawKey =
          '35260812345678000195550010000012341123456789';

      final result = AccessKeyParser.parse(rawKey);

      expect(result.cUf, '35');
      expect(result.aamm, '2608');
      expect(result.cnpj, '12345678000195');
      expect(result.model, '55');
      expect(result.series, '001');
      expect(result.nNf, '000001234');
      expect(result.tpEmis, '1');
      expect(result.cNf, '12345678');
      expect(result.cDv, '9');
    });

    test('should preserve leading zeros', () {
      const rawKey =
          '35260812345678000195550010000012341123456789';

      final result = AccessKeyParser.parse(rawKey);

      expect(result.series, '001');
      expect(result.nNf, '000001234');
    });

    test('should throw FormatException when length is not 44', () {
      const rawKey = '123456';

      expect(
        () => AccessKeyParser.parse(rawKey),
        throwsFormatException,
      );
    });
  });
}