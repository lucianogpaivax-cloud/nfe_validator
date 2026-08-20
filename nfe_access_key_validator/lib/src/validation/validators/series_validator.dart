import '../validation_error.dart';
import 'field_validator.dart';

class SeriesValidator implements FieldValidator {
  @override
  ValidationError? validate(String value) {
    if (value.length != 3) {
      return const ValidationError(
        field: 'series',
        code: 'invalid_length',
        message: 'A série deve possuir exatamente 3 caracteres.',
      );
    }

    if (!RegExp(r'^\d{3}$').hasMatch(value)) {
      return const ValidationError(
        field: 'series',
        code: 'invalid_format',
        message: 'A série deve conter apenas dígitos.',
      );
    }

    return null;
  }
}