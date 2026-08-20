import 'validation_error.dart';

class ValidationResult {
  final List<ValidationError> errors;

  const ValidationResult({
    this.errors = const [],
  });

  bool get isValid => errors.isEmpty;

  bool get isInvalid => !isValid;
}