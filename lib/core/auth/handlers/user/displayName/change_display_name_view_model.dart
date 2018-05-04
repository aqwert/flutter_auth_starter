import '../../../../validators/validator.dart';
import '../../../../validators/display_name_validator.dart'
    as displayNameValidator;

import '../../../../common/app_exception.dart';

class ViewModel {
  ViewModel({this.displayName}) {
    _validator = new Validator();
    _validator.validations.add(() => validateDisplayName(displayName));
  }

  String displayName;

  Validator _validator;

  String validateDisplayName(String value) =>
      displayNameValidator.validate(value);

  void validateAll() {
    var errors = _validator.validate();
    if (errors != null && errors.length > 0) {
      throw new AppException(errors);
    }
  }
}
