import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:worktracker/screens/history/history_info_screen.dart';
import 'package:worktracker/services/data_provider/user_data_provider.dart';

import '../../date_range/date_range_bottom_sheet_modal.dart';
import '../../services/blocs/user/user_bloc.dart';
import '../../services/models/info.dart';
import '../../services/models/user_info.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final UserDataProvider _userDataProvider = UserDataProvider();

  Future<List<UserInfo>?>? _futureUsers;

   final DateTime now = DateTime. now();
   final DateFormat formatter = DateFormat("yyyy-MM-ddT00:00:00");
   late final String date;

  bool _hasDate = false;
  Map<String,String> _date={};
  final String _currentAddress ='';

  @override
  void initState() {
   date = formatter.format(now);
    _futureUsers = _userDataProvider.getUserInfo(firstCall: 'http://165.227.204.177/api/info?date');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child:  Scaffold(
      appBar: AppBar(title: const Text('History'),
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: GestureDetector(
                  onTap: _onDateRangeAdd,
                  child: const Text('Get Info'))),
            ],
          ),
        ],
      ),
      body:   Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: FutureBuilder<List<UserInfo>?>(
            future: _hasDate ? _futureUsers= _userDataProvider.getUserInfo(date: _date['startDate']!) : _futureUsers,
            builder: (context, snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                //     });
                  return const Padding(
                    padding:  EdgeInsets.only(top: 50),
                    child:  Center(child: CircularProgressIndicator(),),
                  );
                case ConnectionState.done:
                default:
                if(snapshot.hasError){
                    return Center(child: Text( "${snapshot.error}"));
                  }else if(snapshot.hasData){
                    return RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child:ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            UserInfo? user = snapshot.data![index];
                            return GestureDetector(
                              onTap: ()=>_openInfoWidthMap(context,Datum(),true),
                              child: IntrinsicHeight(
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      10, 10, 10, 0),

                                  child: Card(
                                    elevation: 0.0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              width: 2.0, color: Colors.black),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                Expanded(child:user.user!=null? Text('Username : ${user.user?.username ?? '' } \n\nFull Name: ${user.user?.firstName ?? ''} ${user.user?.lastName ?? ''}'): const Text('')),
                                              ],
                                            ),
                                           const SizedBox(height: 10),
                                            Row(
                                              children: <Widget>[
                                                Expanded(child: Text('Status : ${user.status ?? ''}')),
                                                const SizedBox(width: 10),
                                                Expanded(child:Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Date : ${DateFormat('yyyy-MM-dd').format(user.date!)}'),
                                                    Text('Start Location : $_currentAddress'),
                                                  ],
                                                ),),

                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: <Widget>[
                                                Expanded(child: Text('Start Time : ${user.startTime?.hour ?? ''}:${user.startTime?.minute ?? ''}  '
                                                    '\n\nEnd Time : ${user.endTime?.hour ?? ''} ${user.endTime?.minute ?? ''}')),
                                              ],
                                            )
                                          ],


                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),);
                  }else{
                    return const Text('No data');
                  }
              }
            }
          ),
        ),
      ],
    ),));
  }

 void handleClick(int item) {
    switch (item){
      case 0:
        _onDateRangeAdd();
        break;
    }
 }
  Future<void> _pullRefresh() async {
     //final DateTime now = DateTime. now();
     //final DateFormat formatter = DateFormat('yyyy-MM-dd');
    //final String newDate = formatter. format(now);
    List<UserInfo> freshNumbers = await _userDataProvider.getUserInfo(firstCall: 'https://phplaravel-885408-3069483.cloudwaysapps.com/api/info?date=');
    setState(() {
      _futureUsers = Future.value(freshNumbers);
    });
  }
  bool _onDateRangeAdd(){

    showModalBottomSheet(
        isDismissible: true,
        barrierColor: const Color(0xFFF5F6F6).withOpacity(0.7),
        elevation: 3,
        useRootNavigator: true,
        isScrollControlled: true,
        context: context,
        builder: (_)=>DateRangeBottomSheetModal( ctx: context,dateRangePost:(hasData,date)=>setState((){
          _hasDate = hasData;
          if(hasData)_date=date;
        }),onDateReset: (reset)=> setState((){
          _hasDate = reset;
          _date = {};
          if(!reset){

           }

        }), searchSourceType: 'project_history_date',)
    );
    return _hasDate;
  }
  // String _getAddressFromLtng({String? lat,String? long}) {
  //   Future.delayed(const Duration(milliseconds: 800),(){
  //     placemarkFromCoordinates(
  //         double.parse("40.1872"), double.parse("44.5152"))
  //         .then((List<Placemark> placemarks) {
  //       Placemark place = placemarks[0];
  //       setState(() {
  //         _currentAddress =
  //         '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
  //       });
  //     }).catchError((e) {
  //       debugPrint(e);
  //     });
  //   });
  //
  //   return _currentAddress;
  // }
  void _openInfoWidthMap(
      BuildContext context,Datum user ,bool isinfo) {
    FocusScope.of(context).requestFocus(FocusNode());
    showModalBottomSheet(
      isDismissible: false,
      barrierColor: const Color(0xFFF5F6F6).withOpacity(0.7),
      elevation: 3,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: false  ,
      context: context,
      builder: (newContext) => BlocProvider.value(
        value: BlocProvider.of<UsersBloc>(context),
        child: HistoryInfoScreenSheetModal(
         userInfo: user,
          updateMyAccountInProgress: false,
        ),
      ),
    );
  }
}
