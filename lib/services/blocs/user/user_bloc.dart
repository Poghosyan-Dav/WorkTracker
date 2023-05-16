import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktracker/screens/users/users.dart';
import 'package:worktracker/services/blocs/user/user_event.dart';
import 'package:worktracker/services/blocs/user/user_state.dart';
import '../../data_provider/user_data_provider.dart';
import '../../models/user.dart';


// Modals

class UsersBloc extends Bloc<MyAccountEvent, EditUserState> {
  final UserDataProvider _myAccountRepository = UserDataProvider();

  UsersBloc(EditUserState initialState) : super(initialState);
  @override
  Stream<EditUserState> mapEventToState(MyAccountEvent event) async* {
   if(event is FetchMyAccount){
     _mapFetchMyAccountToState(event);
   }
   else if (event is EditMyUser) {
      yield* _mapEditMyAccountToState(event);
    } else if (event is EditMyAccountFailure) {
      yield* _mapEditMyAccountFailureToState(event);
    }
  }

  Stream<EditUserState> _mapFetchMyAccountToState(FetchMyAccount event) async* {
    yield MyAccountLoading();

    final  myAccountData = await _myAccountRepository.getUser() ;
    final users =myAccountData;
    if (users.isNotEmpty) {
      yield MyAccountLoaded(
      listUsers: users,
      );
    } else {
      yield const MyAccountLoaded();
    }
  }
    Stream<EditUserState> _mapEditMyAccountToState(EditMyUser event) async* {
      if (event.user.username!.isNotEmpty ||event.user.firstName!.isNotEmpty  || event.user.lastName!.isNotEmpty
      || event.user.role!.isNotEmpty || event.user.password!.isNotEmpty  ) {
        final currentState = state;

        if (currentState is MyAccountLoaded) {
          yield currentState.copyWith();
        }

        final Map myAccountData = await _myAccountRepository.updateMyAccountFromApi(
          firstName: event.user.firstName,
          lastName: event.user.lastName,
          userName:event.user.username,
          role:event.user.role ,
          password: event.user.password,
          id:  event.user.id,
        );

        if (myAccountData['errors'] == null) {
          final User myAccountData = await _myAccountRepository.getUserById(event.user.id.toString());

          if (currentState is MyAccountLoaded) {
            yield currentState.copyWith(
                listUsers: [myAccountData],
            );
          }

          try{
            Navigator.of(event.context!).pushAndRemoveUntil(

                MaterialPageRoute(
                    builder: (context) =>
                    const UsersScreen()),
                    (Route<dynamic> route) =>
                false);
          } catch(e) {
            debugPrint('$e');
          }
        } else {
          Navigator.pop(event.context!);
          add(EditMyAccountFailure());
        }
      } else {
        Navigator.pop(event.context!);
      }
    }

    Stream<EditUserState> _mapEditMyAccountFailureToState(
        EditMyAccountFailure event) async* {
      final currentState = state;

      if (currentState is MyAccountLoaded) {
        yield currentState.copyWith(
            updateMyAccountInProgress: false
        );
      }
    }
  }
