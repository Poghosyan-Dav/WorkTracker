import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:worktracker/services/blocs/register/register_state.dart';

import '../../data_provider/user_data_provider.dart';
import '../../fileds_validations/email.dart';
import '../../fileds_validations/full_name.dart';
import '../../fileds_validations/password.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._userDataProvider) : super(const RegisterState());

  final UserDataProvider _userDataProvider;

  void fullaNameChanged(String value) {
    final firstName = FirstName.dirty(value);
    final lastName = LastName.dirty(value);
    emit(state.copyWith(
      firstName: firstName,
      status: Formz.validate([
       firstName,
        state.lastName,
        state.userName,
        state.password,
      ]),
    ));
  }
  void lastNameChange(String value) {
    final lastName = LastName.dirty(value);
    emit(state.copyWith(
      lastName: lastName,
      status: Formz.validate([
        lastName,
        state.firstName,
        state.userName,
        state.password,
      ]),
    ));
  }

  void emailChanged(String value) {
    final email = UserName.dirty(value);
    debugPrint("$email");
    emit(state.copyWith(
      userName: email,
      status: Formz.validate([
        state.firstName,
        state.lastName,
        email,
        state.password,
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.userName,
        state.lastName,
        password,
      ]),
    ));
  }
  void roleChanged(String value) {
    emit(state.copyWith(
      role: value,
      status: Formz.validate([
        state.userName,
        state.lastName,
        state.password,
      ]),
    ));
  }


  Future<void> signUpCredentials() async {
    String isSuccess;
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      isSuccess  = await _userDataProvider.createUserWithNAmeEmailAndPassword(
        userName: state.userName.value,
        password: state.password.value,
        role: state.role!,
        firstName: state.firstName.value, lastName:state.lastName.value,
      );

      if (isSuccess.isEmpty) {
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure,errorMessage: isSuccess));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure,errorMessage: 'An error occurred while creating the user.'));
    }
  }
}