import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../fileds_validations/email.dart';
import '../../fileds_validations/full_name.dart';
import '../../fileds_validations/password.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.firstName = const FirstName.pure(),
    this.lastName = const LastName.pure(),
    this.userName = const UserName.pure(),
    this.password = const Password.pure(),
    this.role,
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final UserName userName;
  final String? errorMessage;
  final FirstName firstName;
  final LastName lastName;
  final Password password;
  final FormzStatus status;
  final String? role;

  @override
  List<Object?> get props => [lastName, firstName,userName, password, status, errorMessage];

  RegisterState copyWith({
    FirstName? firstName,
    LastName? lastName,
    UserName? userName,
    Password? password,
    String? role,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return RegisterState(
      firstName: firstName ?? this.firstName,
      lastName: lastName??this.lastName,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      role: role??this.role,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}