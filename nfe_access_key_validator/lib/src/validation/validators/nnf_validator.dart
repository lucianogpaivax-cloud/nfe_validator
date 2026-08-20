import '../validation_error.dart';
import 'field_validator.dart';

class NNfValidator implements FieldValidator {
  @override
  ValidationError? validate(String value) {
    if (value.length != 9) {
      return const ValidationError(
        field: 'nNf',
        code: 'invalid_length',
        message: 'O número da NF-e deve possuir exatamente 9 caracteres.',
      );
    }

    if (!RegExp(r'^\d{9}$').hasMatch(value)) {
      return const ValidationError(
        field: 'nNf',
        code: 'invalid_format',
        message: 'O número da NF-e deve conter apenas dígitos.',
      );
    }

    final number = int.parse(value);

    if (number < 1) {
      return const ValidationError(
        field: 'nNf',
        code: 'invalid_number',
        message: 'O número da NF-e deve estar entre 1 e 999999999.',
      );
    }

    return null;
  }
}