class NfeAccessKey {
  final String cUf;
  final String aamm;
  final String cnpj;
  final String model;
  final String series;
  final String nNf;
  final String tpEmis;
  final String cNf;
  final String cDv;

  const NfeAccessKey({
    required this.cUf,
    required this.aamm,
    required this.cnpj,
    required this.model,
    required this.series,
    required this.nNf,
    required this.tpEmis,
    required this.cNf,
    required this.cDv,
  });

  String get value =>
      cUf +
      aamm +
      cnpj +
      model +
      series +
      nNf +
      tpEmis +
      cNf +
      cDv;
}