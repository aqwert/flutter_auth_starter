import '../../../../validators/validator.dart';
import '../../../../validators/email_validator.dart' as emailValidator;

import '../../../../common/app_exception.dart';

class ViewModel {
  ViewModel({this.email}) {
    _validator = new Validator();
    _validator.validations.add(() => validateEmail(email));
  }

  String email = '';

  Validator _validator;
  String validateEmail(String value) => emailValidator.validate(value);

  void validateAll() {
    var errors = _validator.validate();
    if (errors != null && errors.length > 0) {
      throw new AppException(errors);
    }
  }
}
