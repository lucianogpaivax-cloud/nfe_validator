class ValidationError {
  final String field;
  final String code;
  final String message;

  const ValidationError({
    required this.field,
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    return 'ValidationError(field: $field, code: $code, message: $message)';
  }
}