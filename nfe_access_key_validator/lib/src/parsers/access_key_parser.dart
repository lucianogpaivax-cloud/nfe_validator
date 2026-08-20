import '../models/nfe_access_key.dart';

abstract final class AccessKeyParser {
  static const int expectedLength = 44;

  static NfeAccessKey parse(String accessKey) {
    if (accessKey.length != expectedLength) {
      throw FormatException(
        'NF-e access key must contain exactly $expectedLength characters.',
      );
    }

    return NfeAccessKey(
      cUf: accessKey.substring(0, 2),
      aamm: accessKey.substring(2, 6),
      cnpj: accessKey.substring(6, 20),
      model: accessKey.substring(20, 22),
      series: accessKey.substring(22, 25),
      nNf: accessKey.substring(25, 34),
      tpEmis: accessKey.substring(34, 35),
      cNf: accessKey.substring(35, 43),
      cDv: accessKey.substring(43, 44),
    );
  }
}