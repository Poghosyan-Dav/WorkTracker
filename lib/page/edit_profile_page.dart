
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktracker/screens/info_screen/info_screen.dart';

// Screens

import '../screens/edit_screen/edit_info_screen.dart';
import '../services/blocs/user/user_bloc.dart';
import '../services/blocs/user/user_event.dart';
import '../services/blocs/user/user_state.dart';
import '../services/models/user.dart';
import '../widget/user_info/info_section.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});




  @override
  MyAccountScreenState createState() => MyAccountScreenState();
}

class MyAccountScreenState extends State<MyAccountScreen> {
  late UsersBloc _myAccountBloc;

  @override
  void initState() {
    super.initState();

    _myAccountBloc = BlocProvider.of<UsersBloc>(context);
    _myAccountBloc.add(FetchMyAccount());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, EditUserState>(
        builder: (BuildContext context, EditUserState state) {
          bool isLoading = true;
          List<User> data=[] ;

          final currentState = state;

          if (currentState is MyAccountLoaded) {
            isLoading = false;
            data = state.user!;


              return _MyAccount(
                data: data,
                isLoading: isLoading,
                updateMyAccountInProgress: true,
              );

          } else if (currentState is MyAccountLoading) {
            isLoading = true;
            data = [];
          }

          return _MyAccount(
            myAccountBloc: _myAccountBloc,
            data: data ,
            isLoading: isLoading,
            updateMyAccountInProgress: false,
          );
        });
  }
}

class _MyAccount extends StatefulWidget {
  final UsersBloc? myAccountBloc;
  final List<User>? data;
  final bool isLoading;
  final bool? updateMyAccountInProgress;

  const _MyAccount({
    Key? key,
     this.myAccountBloc,
    required this.data,
    required this.isLoading,
    this.updateMyAccountInProgress,
  }) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<_MyAccount> {


  void _openEditMyInfoBottomSheetModal(
      BuildContext context, bool updateMyAccountInProgress,int index) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      isDismissible: true,
      barrierColor: const Color(0xFFF5F6F6).withOpacity(0.7),
      elevation: 3,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (newContext) => BlocProvider.value(
        value: BlocProvider.of<UsersBloc>(context),
        child: EditMyInfoBottomSheetModal(
          isInfo: false,
          context: context,
          user:widget.data![index],
        ),
      ),
    );
  }



  void _openInfoWidthMap(
      BuildContext context, bool updateMyAccountInProgress,index) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      isDismissible: true,
      barrierColor: const Color(0xFFF5F6F6).withOpacity(0.7),
      elevation: 3,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (newContext) => BlocProvider.value(
        value: BlocProvider.of<UsersBloc>(context),
        child: InfoScreenSheetModal(
          user: widget.data![index],
          context: context,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: widget.data!.length,
                              itemBuilder: (BuildContext context, int index) {

                                  return InkWell(
                                    onTap: ()=>_openInfoWidthMap(context, widget.updateMyAccountInProgress!,index),
                                    child: InfoSection(
                                      fullName: widget.data == null
                                          ? ''
                                          : '${widget.data![index].firstName} ${widget.data![index].firstName}',
                                      lastName: widget.data == null
                                          ? ''
                                          : "${widget.data![index].lastName}",
                                      userName:widget.data == null
                                          ? ''
                                          : "${widget.data![index].username}",
                                       role: widget.data == null
                                           ? ''
                                           : "${widget.data![index].role}",
                                      isLoading: widget.isLoading,

                                      onEdit: () => _openEditMyInfoBottomSheetModal(
                                          context,
                                          widget.updateMyAccountInProgress!,index),

                                    ),
                                  );
                                }
                            ),
      ),
    );

  }
}