//
// import 'package:equatable/equatable.dart';
//
// abstract class EditUserEvent extends Equatable {
//   const EditUserEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class EditUser extends EditUserEvent {
//   const EditUser(this.fullName,this.email,this.poneNumber);
//
//   final String fullName;
//   final String email;
//   final String poneNumber;
//
//   @override
//   List<Object> get props => [fullName,email,poneNumber];
// }
//
//
//
// class EditUserSubmitted extends EditUserEvent {
//   const EditUserSubmitted();
// }

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

abstract class MyAccountEvent extends Equatable {
  const MyAccountEvent();

  @override
  List<Object> get props => [];
}

class FetchMyAccount extends MyAccountEvent {

}
class RefreshMyAccount extends MyAccountEvent {}

class EditMyUser extends MyAccountEvent {
  final User user;
  final BuildContext? context;
  const EditMyUser({
   required  this.user,

    required this.context
  });

  @override
  List<Object> get props => [ user,];
}

class EditMyAccountInProgress extends MyAccountEvent {}

class EditMyAccountDone extends MyAccountEvent {}

class EditMyAccountFailure extends MyAccountEvent {}







