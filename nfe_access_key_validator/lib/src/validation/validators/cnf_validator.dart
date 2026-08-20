import '../validation_error.dart';
import 'field_validator.dart';

class CNfValidator implements FieldValidator {
  @override
  ValidationError? validate(String value) {
    if (value.length != 8) {
      return const ValidationError(
        field: 'cNf',
        code: 'invalid_length',
        message: 'cNF deve possuir exatamente 8 caracteres.',
      );
    }

    if (!RegExp(r'^\d{8}$').hasMatch(value)) {
      return const ValidationError(
        field: 'cNf',
        code: 'invalid_format',
        message: 'cNF deve conter apenas dígitos.',
      );
    }

    return null;
  }
}