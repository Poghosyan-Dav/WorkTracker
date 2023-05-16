
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktracker/screens/info_screen/info_screen.dart';
import 'package:worktracker/services/data_provider/user_data_provider.dart';
import 'package:worktracker/widget/user_info/info_section.dart';

import '../screens/edit_screen/edit_info_screen.dart';
import '../services/blocs/user/user_bloc.dart';
import '../services/models/user.dart';
import 'delete_user_dialog.dart';



class DashboardData extends StatefulWidget {


  const DashboardData({Key? key,}) : super(key: key);

  @override
  State<DashboardData> createState() => _DashboardDataState();
}

class _DashboardDataState extends State<DashboardData> {
  final UserDataProvider _userDataProvider = UserDataProvider();
  Future<List<User>>? _users;
@override
  void initState() {

  _users =  _userDataProvider.getUser();
    super.initState();
  }


  void _openInfoWidthMap(
      BuildContext context,User user ,bool isinfo) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      isDismissible: true,
      barrierColor: const Color(0xFFF5F6F6).withOpacity(0.7),
      elevation: 3,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<UsersBloc>(context),
        child: InfoScreenSheetModal(
          id: user.id,
          user: user,
          context: context,
        ),
      ),
    );
  }

void _onDelete({required List<User> users,required int index,required int userId})async{

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteUserDialog(userId: userId,onDeleted: ()async{
          final bool value = await _userDataProvider.deleteUser(userId);
          if (value) {
            users.removeAt(index);
            _pullRefresh();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User Deleted!")),
              );
              Navigator.pop(context);
            }
          }

        },);
      },
    );
}
  void _openEditMyInfoBottomSheetModal(
      BuildContext context,{required User user}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EditMyInfoBottomSheetModal(
      user: user,
      context: context,
    ),));
    FocusScope.of(context).requestFocus(FocusNode());
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        FutureBuilder(
    future: _users,
    builder: (context,snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
              return const Padding(
                padding:  EdgeInsets.only(top: 50),
                child:  Center(child: CircularProgressIndicator(),),
              );
                case ConnectionState.done:
              default:
                if(snapshot.hasError){
                  return Text( "${snapshot.hasError}");
                }else if(snapshot.hasData && snapshot.data != null ){
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            print(index);
                            User user = snapshot.data![index];
                            return Container(
                              padding: const EdgeInsets.all(8.0),
                              child: InfoSection(
                                onDelete:()=> _onDelete( userId: user.id!,users:snapshot.data!,index:index,),
                                fullName: '${user.firstName}',
                                lastName: "${user.lastName}",
                                userName:"${user.username}",
                                role:"${user.role}",
                                isLoading: true,

                                onEdit:()=> _openEditMyInfoBottomSheetModal(context,user: user),

                              ),
                            );

                          }),
                    ),
                  );
                }else{
                  return const Text('No data');
                }
            }
            }
          ),

      ],
    );
  }
  Future<void> _pullRefresh() async {
    List<User> fetchUsers = await _userDataProvider.getUser();
    setState(() {
      _users = Future.value(fetchUsers);
    });
  }
}
