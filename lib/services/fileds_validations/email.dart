import 'package:formz/formz.dart';

enum UserNameValidator { invliad }

class UserName extends FormzInput<String, UserNameValidator> {
  const UserName.pure() : super.pure('');
  const UserName.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z]',
  );
  @override
  UserNameValidator? validator(String? value) {
    return _emailRegExp.hasMatch(value ?? '') ? null : UserNameValidator.invliad;
  }
}