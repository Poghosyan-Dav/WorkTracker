// import 'package:equatable/equatable.dart';
// import '../../models/user.dart';
//
//
//
//
// enum UserStatus { initial, loading, success, failure }
//
// extension EditTodoStatusX on UserStatus {
//   bool get isLoadingOrSuccess => [
//     UserStatus.loading,
//     UserStatus.success,
//   ].contains(this);
// }
//
// class EditUserState extends Equatable {
//   const EditUserState({
//     this.status = UserStatus.initial,
//     this.initialTodo,
//     this.fullName,
//     this.email,
//   });
//
//   final UserStatus status;
//   final User? initialTodo;
//   final String? fullName;
//   final String? email;
//   bool get isNewTodo => initialTodo == null;
//
//   EditUserState copyWith({
//     UserStatus? status,
//     User? initialTodo,
//     String? email,
//     String? fullName,
//
//   }) {
//     return EditUserState(
//       status: status ?? this.status,
//       initialTodo: initialTodo ?? this.initialTodo,
//       fullName: fullName??this.fullName,
//       email: email ?? this.email,
//     );
//   }
//
//   @override
//   List<Object?> get props => [status, initialTodo,];
// }

import 'package:equatable/equatable.dart';

// Models

import '../../models/user.dart';

abstract class EditUserState extends Equatable {
  final List<User>? user;
  final bool? updateMyAccountInProgress;

  const EditUserState({this.user, this.updateMyAccountInProgress});

  @override
  List<Object> get props => [user!, updateMyAccountInProgress!];
}

class MyAccountInitial extends EditUserState {}

class MyAccountLoading extends EditUserState {}

class MyAccountLoaded extends EditUserState {
  final List<User> listUsers;
  final Map<String, String> errorMessagesMap;
  final String makePrimaryError;

  const MyAccountLoaded({
     this.listUsers =const [],

    this.errorMessagesMap = const {'subjectError': '', 'messageError': ''},
    this.makePrimaryError='',
  }) : super(
    user: listUsers,
  );

  MyAccountLoaded copyWith({
    List<User>? listUsers,
    bool? updateMyAccountInProgress,

    bool? showVerificationAlreadyDoneSnackBar,
    Map<String , String>? errorMessagesMap,
  }) {
    return MyAccountLoaded(
      listUsers: listUsers ?? this.listUsers,
      errorMessagesMap: errorMessagesMap ?? this.errorMessagesMap,
    );
  }
@override
  List<Object> get props =>[

  listUsers,
  errorMessagesMap,
  makePrimaryError,
];

}

class EditMyAccountLoading extends EditUserState {}