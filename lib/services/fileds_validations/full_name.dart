import 'package:formz/formz.dart';

enum NameValidator { invliad }
 final RegExp _nameRegex = RegExp(
    r"^([a-zA-Z])");
class FirstName extends FormzInput<String, NameValidator> {
  const FirstName.pure() : super.pure('');
  const FirstName.dirty([String value = '']) : super.dirty(value);


  @override
  NameValidator? validator(String? value) {
    return _nameRegex.hasMatch(value ?? '')
        ? null
        : NameValidator.invliad;
  }
}
class LastName extends FormzInput<String, NameValidator> {
  const LastName.pure() : super.pure('');
  const LastName.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidator? validator(String? value) {
    return _nameRegex.hasMatch(value ?? '')
        ? null
        : NameValidator.invliad;
  }
}