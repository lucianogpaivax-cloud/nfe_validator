import '../validation_error.dart';

abstract interface class FieldValidator {
  ValidationError? validate(String value);
}