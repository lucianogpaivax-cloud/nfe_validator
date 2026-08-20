import '../validation_error.dart';
import 'field_validator.dart';

class CUfValidator implements FieldValidator {
  static const Set<String> validCodes = {
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '31',
    '32',
    '33',
    '35',
    '41',
    '42',
    '43',
    '50',
    '51',
    '52',
    '53',
  };

  @override
  ValidationError? validate(String value) {
    if (value.length != 2) {
      return const ValidationError(
        field: 'cUf',
        code: 'invalid_length',
        message: 'cUF deve possuir exatamente 2 caracteres.',
      );
    }

    if (!RegExp(r'^\d{2}$').hasMatch(value)) {
      return const ValidationError(
        field: 'cUf',
        code: 'invalid_format',
        message: 'cUF deve conter apenas dígitos.',
      );
    }

    if (!validCodes.contains(value)) {
      return const ValidationError(
        field: 'cUf',
        code: 'invalid_cuf',
        message: 'Código da UF inválido.',
      );
    }

    return null;
  }
}