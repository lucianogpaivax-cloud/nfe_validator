import '../parsers/access_key_parser.dart';
import 'validation_error.dart';
import 'validation_result.dart';
import 'validators/aamm_validator.dart';
import 'validators/check_digit_validator.dart';
import 'validators/cnf_validator.dart';
import 'validators/cnpj_validator.dart';
import 'validators/cuf_validator.dart';
import 'validators/model_validator.dart';
import 'validators/nnf_validator.dart';
import 'validators/series_validator.dart';
import 'validators/tp_emis_validator.dart';

class NfeAccessKeyValidator {
  static final CUfValidator _cUfValidator = CUfValidator();
  static final AammValidator _aammValidator = AammValidator();
  static final CnpjValidator _cnpjValidator = CnpjValidator();
  static final ModelValidator _modelValidator = ModelValidator();
  static final SeriesValidator _seriesValidator = SeriesValidator();
  static final NNfValidator _nNfValidator = NNfValidator();
  static final TpEmisValidator _tpEmisValidator = TpEmisValidator();
  static final CNfValidator _cNfValidator = CNfValidator();
  static final CheckDigitValidator _checkDigitValidator =
      CheckDigitValidator();

  const NfeAccessKeyValidator();

  ValidationResult validate(String value) {
    if (value.length != AccessKeyParser.expectedLength) {
      return const ValidationResult(
        errors: [
          ValidationError(
            field: 'accessKey',
            code: 'invalid_length',
            message:
                'A chave de acesso da NF-e deve possuir exatamente 44 caracteres.',
          ),
        ],
      );
    }

    final accessKey = AccessKeyParser.parse(value);

    final errors = <ValidationError>[];

    void addError(ValidationError? error) {
      if (error != null) {
        errors.add(error);
      }
    }

    addError(_cUfValidator.validate(accessKey.cUf));
    addError(_aammValidator.validate(accessKey.aamm));
    addError(_cnpjValidator.validate(accessKey.cnpj));
    addError(_modelValidator.validate(accessKey.model));
    addError(_seriesValidator.validate(accessKey.series));
    addError(_nNfValidator.validate(accessKey.nNf));
    addError(_tpEmisValidator.validate(accessKey.tpEmis));
    addError(_cNfValidator.validate(accessKey.cNf));

    final hasBaseFormatError = errors.any(
      (error) => error.code == 'invalid_format',
    );

    if (!hasBaseFormatError ||
        !RegExp(r'^\d$').hasMatch(accessKey.cDv)) {
      addError(
        _checkDigitValidator.validate(accessKey),
      );
    }

    return ValidationResult(
      errors: errors,
    );
  }
}