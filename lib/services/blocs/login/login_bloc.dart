import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:worktracker/screens/Login/login_form.dart';
import 'package:worktracker/services/data_provider/session_data_providers.dart';

import '../../data_provider/user_data_provider.dart';
import '../../fileds_validations/email.dart';
import '../../fileds_validations/password.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._userDataProvider) : super(const LoginState());

  final UserDataProvider _userDataProvider;
 final _sessionDatProvider  = SessionDataProvider();
  void emailChanged(String value) {
    final email = UserName.dirty(value);
    debugPrint("$email");
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.userName, password]),
    ));
  }
  void logOut(){
    emit(state.copyWith(email: const UserName.pure(),password:  const Password.pure(),status: FormzStatus.pure),);
  }

  Future<void> loginWithCredentials() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      Map<String,dynamic>? isSuccess = await _userDataProvider.signInWithEmailAndPassword(
        userName: state.userName.value,
        password: state.password.value,
      );
      if (isSuccess?['is_user'] != null) {
        emit(state.copyWith(status: FormzStatus.submissionSuccess,isUser:isSuccess?['is_user']));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}