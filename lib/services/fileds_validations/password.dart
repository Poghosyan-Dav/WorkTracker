import 'package:formz/formz.dart';

enum PassowrdValidatorError { invalid }

class Password extends FormzInput<String, PassowrdValidatorError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  // static final _passwordRegExp =
  // RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  @override
  PassowrdValidatorError? validator(String? value) {
    return value!.length>=4
        ? null
        : PassowrdValidatorError.invalid;
  }
}