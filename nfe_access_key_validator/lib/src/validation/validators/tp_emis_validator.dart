import '../validation_error.dart';
import 'field_validator.dart';

class TpEmisValidator implements FieldValidator {
  static const Set<String> validValues = {
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '9',
  };

  @override
  ValidationError? validate(String value) {
    if (value.length != 1) {
      return const ValidationError(
        field: 'tpEmis',
        code: 'invalid_length',
        message: 'tpEmis deve possuir exatamente 1 caractere.',
      );
    }

    if (!RegExp(r'^\d$').hasMatch(value)) {
      return const ValidationError(
        field: 'tpEmis',
        code: 'invalid_format',
        message: 'tpEmis deve conter apenas um dígito.',
      );
    }

    if (!validValues.contains(value)) {
      return const ValidationError(
        field: 'tpEmis',
        code: 'invalid_tp_emis',
        message: 'Tipo de emissão inválido.',
      );
    }

    return null;
  }
}