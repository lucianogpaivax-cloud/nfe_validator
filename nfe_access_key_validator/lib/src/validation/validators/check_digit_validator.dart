import '../../models/nfe_access_key.dart';
import '../validation_error.dart';

class CheckDigitValidator {
  ValidationError? validate(NfeAccessKey accessKey) {
    if (accessKey.cDv.length != 1) {
      return const ValidationError(
        field: 'cDv',
        code: 'invalid_length',
        message: 'O dígito verificador deve possuir exatamente 1 caractere.',
      );
    }

    if (!RegExp(r'^\d$').hasMatch(accessKey.cDv)) {
      return const ValidationError(
        field: 'cDv',
        code: 'invalid_format',
        message: 'O dígito verificador deve conter apenas um dígito.',
      );
    }

    final calculatedDigit = _calculate(accessKey);

    if (accessKey.cDv != calculatedDigit.toString()) {
      return const ValidationError(
        field: 'cDv',
        code: 'invalid_check_digit',
        message: 'O dígito verificador da chave de acesso é inválido.',
      );
    }

    return null;
  }

  int _calculate(NfeAccessKey accessKey) {
    final base =
        accessKey.cUf +
        accessKey.aamm +
        accessKey.cnpj +
        accessKey.model +
        accessKey.series +
        accessKey.nNf +
        accessKey.tpEmis +
        accessKey.cNf;

    var sum = 0;
    var weight = 2;

    for (var i = base.length - 1; i >= 0; i--) {
      final characterValue = base.codeUnitAt(i) - 48;

      sum += characterValue * weight;

      weight++;

      if (weight > 9) {
        weight = 2;
      }
    }

    final remainder = sum % 11;

    if (remainder == 0 || remainder == 1) {
      return 0;
    }

    return 11 - remainder;
  }
}