import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:worktracker/services/blocs/user/user_bloc.dart';
import 'package:worktracker/services/models/info.dart';
import 'package:worktracker/services/models/user_info.dart';

// Widgets
import '../../services/blocs/user/user_state.dart';
import '../../widget/history_info/history_bar.dart';
import '../../widget/history_info/history_body.dart';


class HistoryInfoScreenSheetModal extends StatefulWidget {
 final Datum userInfo;
  final bool updateMyAccountInProgress;

  const HistoryInfoScreenSheetModal({
    Key? key,
    required this.userInfo,
    required this.updateMyAccountInProgress,
  }) : super(key: key);

  @override
  HistoryInfoScreenSheetModalState createState() =>  HistoryInfoScreenSheetModalState();
}

class HistoryInfoScreenSheetModalState extends State<HistoryInfoScreenSheetModal> {
  //
  List<LatLng> positions = [];

  // String? _firstName;
  // String? _userName;
  // int? _id;
  // String? _password;
  void getLatLng() {
    var current = widget.userInfo.currentLocation;
    var start = widget.userInfo.startLocation;
    var end = widget.userInfo.endLocation;



    positions = [
      LatLng(parseLatLng(current?.lat ?? "0.0"), parseLatLng(current?.lng ?? "0.0")),
      LatLng(parseLatLng(start?.lat ?? "0.0"), parseLatLng(start?.lng ?? "0.0")),
      LatLng(parseLatLng(end?.lat ?? "0.0"), parseLatLng(end?.lng ?? "0.0")),
    ];
  }

  double parseLatLng(String loc){
  return double.parse(loc);
}
@override
  void initState() {
  getLatLng();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<UsersBloc, EditUserState>(builder: (BuildContext _, state) {
      return Scaffold(

        appBar: AppBar(
          title: Text('User Info'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Stack(
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
                  Expanded(
                    child: HistorySheetContainerBody(
                     userInfo: widget.userInfo,
                      positions: positions,
                    ),
                  ),


                ],
              ),

            ),

          ],
        ),
      );
    });
  }
}