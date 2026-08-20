import '../validation_error.dart';
import 'field_validator.dart';

class AammValidator implements FieldValidator {
  @override
  ValidationError? validate(String value) {
    if (value.length != 4) {
      return const ValidationError(
        field: 'aamm',
        code: 'invalid_length',
        message: 'AAMM deve possuir exatamente 4 caracteres.',
      );
    }

    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return const ValidationError(
        field: 'aamm',
        code: 'invalid_format',
        message: 'AAMM deve conter apenas dígitos.',
      );
    }

    final month = int.parse(value.substring(2, 4));

    if (month < 1 || month > 12) {
      return const ValidationError(
        field: 'aamm',
        code: 'invalid_month',
        message: 'O mês informado em AAMM deve estar entre 01 e 12.',
      );
    }

    return null;
  }
}