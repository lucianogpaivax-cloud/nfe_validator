import '../validation_error.dart';
import 'field_validator.dart';

class CnpjValidator implements FieldValidator {
  static final RegExp _format = RegExp(r'^[A-Z0-9]{12}[0-9]{2}$');

  static const String _zeroCnpj = '00000000000000';

  static const List<int> _firstDigitWeights = [
    5,
    4,
    3,
    2,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
  ];

  static const List<int> _secondDigitWeights = [
    6,
    5,
    4,
    3,
    2,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
  ];

  @override
  ValidationError? validate(String value) {
    if (value.length != 14) {
      return const ValidationError(
        field: 'cnpj',
        code: 'invalid_length',
        message: 'O CNPJ deve possuir exatamente 14 caracteres.',
      );
    }

    if (!_format.hasMatch(value)) {
      return const ValidationError(
        field: 'cnpj',
        code: 'invalid_format',
        message:
            'O CNPJ deve possuir 12 caracteres alfanuméricos maiúsculos '
            'seguidos de 2 dígitos verificadores numéricos.',
      );
    }

    if (value == _zeroCnpj) {
      return const ValidationError(
        field: 'cnpj',
        code: 'invalid_cnpj',
        message: 'O CNPJ informado é inválido.',
      );
    }

    final base = value.substring(0, 12);
    final informedCheckDigits = value.substring(12, 14);

    final calculatedCheckDigits = _calculateCheckDigits(base);

    if (informedCheckDigits != calculatedCheckDigits) {
      return const ValidationError(
        field: 'cnpj',
        code: 'invalid_check_digits',
        message: 'Os dígitos verificadores do CNPJ são inválidos.',
      );
    }

    return null;
  }

  String _calculateCheckDigits(String base) {
    final firstDigit = _calculateDigit(
      base,
      _firstDigitWeights,
    );

    final secondDigit = _calculateDigit(
      '$base$firstDigit',
      _secondDigitWeights,
    );

    return '$firstDigit$secondDigit';
  }

  int _calculateDigit(
    String value,
    List<int> weights,
  ) {
    var sum = 0;

    for (var i = 0; i < value.length; i++) {
      final characterValue = value.codeUnitAt(i) - 48;

      sum += characterValue * weights[i];
    }

    final remainder = sum % 11;

    if (remainder < 2) {
      return 0;
    }

    return 11 - remainder;
  }
}