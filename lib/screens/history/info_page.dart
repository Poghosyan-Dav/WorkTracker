import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:worktracker/screens/edit_screen/edit_info_screen.dart';
import 'package:worktracker/services/data_provider/user_data_provider.dart';
import 'package:worktracker/services/models/info.dart';

import '../../date_range/date_range_bottom_sheet_modal.dart';
import '../../services/blocs/user/user_bloc.dart';
import '../../services/models/user.dart';
import '../../services/models/user_info.dart';
import 'history_info_screen.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int currentPage = 1;
  int lastPage = 1;
  String nexPageUrl = '';

  List<dynamic> data = [];
  bool isLoading = false;
  final DateTime now = DateTime. now();
  final DateFormat formatter = DateFormat("yyyy-MM-ddT00:00:00");
  late final String date;

  bool _hasDate = false;
  Map<String,String> _date={};
  final String _currentAddress ='';
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final url = _hasDate ? 'http://165.227.204.177/api/info?date=${_date['startDate']}' : 'http://165.227.204.177/api/info?page=$currentPage';
    final response = await http.get(Uri.parse(url)); // Replace with your API endpoint
    final dataList = jsonDecode(response.body)['data'];
    final currentPg = jsonDecode(response.body)['current_page'];
    final lastPg = jsonDecode(response.body)['last_page'];
    final nextPage = jsonDecode(response.body)['next_page_url'];
    setState(() {
      data = dataList.map((json) => Datum.fromJson(json)).toList();
      currentPage  = currentPg;
      lastPage = lastPg;
      nexPageUrl = nextPage ?? '';
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.blueAccent,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(value: 0, child:  Text('Get Info')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView.builder(
                itemCount: data.length + 1,
                itemBuilder: (BuildContext context, int index) {

                  if (index == data.length) {
                    if (isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      _hasDate = false;
                      return Container();
                    }
                  } else {
                    var user = data[index] as Datum;

                    return GestureDetector(
                      onTap: ()=>_openInfoWidthMap(context,user  ,true),
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text('First Name: ${user.user?.firstName ?? '' }'),
                                const SizedBox(height: 16),
                                Text('Last Name: ${user.user?.lastName ?? '' }'),
                                const SizedBox(height: 16),
                                Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse('${user.date}'))}'),
                                const SizedBox(height: 16),
                                Text('Duration: ${user.duration}'),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Times:'),
                                    if(user.times != null) for (var time in user!.times!.take(2))
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Start: ${time.start}'),
                                            const SizedBox(height: 8),
                                            Text('End: ${time.end}'),
                                            const SizedBox(height: 16),
                                          ],
                                        ),
                                      ),
                                    if (user.times != null && user.times!.length > 2)
                                      const Padding(
                                        padding:  EdgeInsets.only(left: 16.0,top: 20),
                                        child: Align(
                                            alignment:Alignment.bottomRight,
                                            child: Text('...',textAlign: TextAlign.right,style: TextStyle(fontSize: 16),)),
                                      ),

                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: currentPage == 1
                      ? null
                      : () {
                    setState(() {
                      currentPage--;
                      data = [];
                    });
                    fetchData();
                  },
                  child: const Text('Previous'),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  onPressed: currentPage < lastPage || nexPageUrl.isEmpty
                      ? null
                      : () {
                    setState(() {
                      currentPage++;
                      data = [];
                    });
                    fetchData();
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleClick(int item) {
    switch (item){
      case 0:
        _onDateRangeAdd();
        break;
    }
  }
  Future<void> _pullRefresh() async {
    fetchData();

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
          if(hasData)_date = date;
          if (hasData) {
            setState(() {
              currentPage = 1;
              data = [];
            });
            fetchData();
          }

        }),onDateReset: (reset)=> setState((){
          _hasDate = reset;
          _date = {};
          fetchData();
          if(!reset){

          }

        }), searchSourceType: 'project_history_date',)
    );
    return _hasDate;
  }
  void _openInfoWidthMap(
      BuildContext context,Datum user ,bool isinfo) {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>HistoryInfoScreenSheetModal(
      userInfo: user,
      updateMyAccountInProgress: false,
    )));

  }
}
