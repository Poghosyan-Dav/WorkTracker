import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worktracker/services/blocs/user/user_bloc.dart';
import 'package:worktracker/services/data_provider/user_data_provider.dart';
import 'package:worktracker/services/models/user.dart';
import 'package:worktracker/services/models/user_info.dart';
import 'package:worktracker/widget/edit_info/info_sheet_container_body.dart';

// Widgets
import '../../services/blocs/user/user_state.dart';


class InfoScreenSheetModal extends StatefulWidget {
  final BuildContext context;
  final int? id;
 final User? user;
  const InfoScreenSheetModal({
    Key? key,
     this.id, this.user,
    required this.context,

  }) : super(key: key);

  @override
  InfoScreenSheetModalState createState() =>  InfoScreenSheetModalState();
}

class InfoScreenSheetModalState extends State<InfoScreenSheetModal> {
  Future<UserInfo>? _users;
  final UserDataProvider _userDataProvider = UserDataProvider();





  @override
  void initState() {
    super.initState();
    _users =  _userDataProvider.getUserInfoById(widget.id);


  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<UsersBloc, EditUserState>(builder: (BuildContext _, state) {
      return SizedBox(
        height: MediaQuery.of(context).size.height ,
        child: Stack(
          children: <Widget>[
            Container(
              child: state.updateMyAccountInProgress??false ? Container(
                color: Colors.white.withOpacity(0.9),
                child: const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              ) : Column(
                children: [
              FutureBuilder
                (
                  future: _users,
                  builder: (context,snapshot){
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
                        }else if(snapshot.hasData){
                       final   UserInfo? usersInfo = snapshot.data;
                          return Expanded(
                            child: InfoSheetBody(
                              firstName: widget.user?.firstName ?? '',
                              userName: widget.user?.username ?? '',
                              lastName: widget.user?.lastName ?? '',
                              date: usersInfo?.date.toString() ?? '',
                              startTime: usersInfo?.startTime.toString() ?? '',
                              startLocation: usersInfo?.startLocation,
                              endLocation:usersInfo?.endLocation,
                              currentLocation: usersInfo?.currentLocation,
                              endTime: usersInfo?.endTime.toString() ?? '',
                            ),
                          );
                        }else{
                          return const Center(child: Text('No data'));
                        }
                    }
                  })


                ],
              ),

            ),
          ],
        ),
      );
    });
  }
}