import 'package:test/test.dart';
import 'package:nfe_access_key_validator/src/models/nfe_access_key.dart';

void main() {
  group('NfeAccessKey', () {
    test('should rebuild the original access key from its fields', () {
      const accessKey = NfeAccessKey(
        cUf: '35',
        aamm: '2608',
        cnpj: '12345678000195',
        model: '55',
        series: '001',
        nNf: '000001234',
        tpEmis: '1',
        cNf: '12345678',
        cDv: '9',
      );

      expect(
        accessKey.value,
        '35260812345678000195550010000012341123456789',
      );
    });
  });
}