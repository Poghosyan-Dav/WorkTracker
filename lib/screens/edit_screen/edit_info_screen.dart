import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Widgets
import '../../services/blocs/user/user_bloc.dart';
import '../../services/blocs/user/user_event.dart';
import '../../services/blocs/user/user_state.dart';
import '../../services/models/user.dart';
import '../../widget/edit_info/app_bar.dart';
import '../../widget/edit_info/sheet_container_body.dart';
import '../users/users.dart';


class EditMyInfoBottomSheetModal extends StatefulWidget {
  final BuildContext context;
  final User? user;
  final bool? isInfo;

   const EditMyInfoBottomSheetModal({
    Key? key,
    this.isInfo,
    required this.context,
    required this.user

  }) : super(key: key);

  @override
  EditMyInfoBottomSheetModalState createState() =>  EditMyInfoBottomSheetModalState();
}

class EditMyInfoBottomSheetModalState extends State<EditMyInfoBottomSheetModal> {
  late UsersBloc _myAccountBloc;

  String? _firstName;
  String? _password;
  String? _role;
  String? _userName;
  //int? _id;
  String? _lastName;
  final updateUser = GlobalKey<ScaffoldState>();


  void _getChangedPassword(psw) {
    setState(() => _password = psw);
  }

  void _getChangedRole(role) {
    setState(() => _role = role);
  }

  void _getChangedFirstname(fName) {
    setState(() => _firstName = fName);
  }

  void _getChangedLastName(lName) {
    setState(() => _lastName = lName);
  }

  void _getChangedUserName(uName) {
    setState(() => _userName = uName);
  }

  void _onSaveButtonPressed() {

    if(_firstName != null || _lastName  != null || _userName != null ||_password != null ||_role != null || widget.user != null){
      var user = widget.user;
      var changeUser = User(firstName: _firstName ?? user?.firstName ,lastName: _lastName ?? user?.lastName,username: _userName ?? user?.username,password:_password,role: _role ?? user?.role,id: widget.user?.id);
      _myAccountBloc.add(EditMyUser(
        context: context,
        user: changeUser ,
      ));

    }else{
      Navigator.pop(context);
    }


  }

  @override
  void initState() {
    super.initState();

    _myAccountBloc = BlocProvider.of<UsersBloc>(widget.context);

  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<UsersBloc, EditUserState>(builder: (BuildContext _, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          leading: IconButton(onPressed: ()=>Navigator.of(context).pop(), icon:const Icon(Icons.arrow_back_ios_new_outlined)),
          title:const Text('Edit User'),
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          height: MediaQuery.of(context).size.height ,
          child: Stack(
            children: <Widget>[
              Container(
                child: state.updateMyAccountInProgress ?? false ? Container(
                  color: Colors.white.withOpacity(0.9),
                  child: const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                ) : SheetContainerBody(
                 user: widget.user,
                  isInfo: widget.isInfo,
                  saveChanges: _onSaveButtonPressed,
                  pushEditedFirstName: _getChangedFirstname,
                  pushEditedLastName: _getChangedLastName,
                  pushEditedJobTitle: _getChangedUserName,
                  pushEditedPassword: _getChangedPassword,
                  pushEditedRole: _getChangedRole,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}