import '../validation_error.dart';
import 'field_validator.dart';

class ModelValidator implements FieldValidator {
  static const String expectedModel = '55';

  @override
  ValidationError? validate(String value) {
    if (value.length != 2) {
      return const ValidationError(
        field: 'model',
        code: 'invalid_length',
        message: 'O modelo deve possuir exatamente 2 caracteres.',
      );
    }

    if (!RegExp(r'^\d{2}$').hasMatch(value)) {
      return const ValidationError(
        field: 'model',
        code: 'invalid_format',
        message: 'O modelo deve conter apenas dígitos.',
      );
    }

    if (value != expectedModel) {
      return const ValidationError(
        field: 'model',
        code: 'invalid_model',
        message: 'O modelo deve ser 55 para NF-e.',
      );
    }

    return null;
  }
}