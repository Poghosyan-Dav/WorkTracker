import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:worktracker/screens/Login/login_screen.dart';
import 'package:worktracker/services/data_provider/session_data_providers.dart';
import 'package:worktracker/services/data_provider/users_info_api.dart';
import 'package:worktracker/services/models/user_actions.dart';

import '../../main.dart';
import '../../services/blocs/login/login_bloc.dart';

class UserScreen extends StatefulWidget {
  const  UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserActionsProvider _userActionsProvider = UserActionsProvider();
  final _isHours = true;
  bool timerOn = false;
  final  _sessionDataProvider =  SessionDataProvider();
  late  String stopedTimerData ='';
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );
  Position? _currentPosition;
  bool _isLocationEnabled = false;

  Future<void> _getCurrentPosition() async {
    final permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      // permission is granted, get the location
      try {
        final geolocator = GeolocatorPlatform.instance;
        final position = await geolocator.getCurrentPosition(
            locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high));
        setState(() {
          _currentPosition = position;
          _isLocationEnabled = true;
        });
      } catch (error) {
        print(error);
        _isLocationEnabled = false;
      }
    } else if (permissionStatus.isDenied ||
        permissionStatus.isPermanentlyDenied) {
      _isLocationEnabled = false;
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Location Permission'),
          content: const Text('Please enable location services all the time'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('SETTINGS'),
            ),
          ],
        ),
      );
    }
  }


  Future<bool> _handleLocationPermission() async{

    LocationPermission permission;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _isLocationEnabled = serviceEnabled;
    });
    if (!serviceEnabled) {
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services')));
      }

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied')));
        }

        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if(context.mounted){

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));}

      return false;
    }
    return true;
  }


  @override
  void initState() {
    _loadData();
    _handleLocationPermission();

    _stopWatchTimer.rawTime.listen((value) {
      if (kDebugMode) {
       // print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}');
        setState(() {
          stopedTimerData = StopWatchTimer.getDisplayTime(value);

        });
      }

    }
    );
    super.initState();
  }
  _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedWorkTime = prefs.getString('work_time') ?? '';
    if (savedWorkTime.isNotEmpty) {
      final parsedWorkTime = DateTime.parse(savedWorkTime);
      final dateNow = DateTime.now();
      final difference = parsedWorkTime.difference(dateNow).inMilliseconds;
      _stopWatchTimer.setPresetTime(mSec: difference.abs());
      _startTimer();
    }
  }
  _removeData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('work_time');
  }
  _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('work_time', DateTime.now().toString());
  }
  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,title:const Text('Working Time'),
          actions: [
            PopupMenuButton<int>(
              onSelected: (item) => _handleClick(item),
              itemBuilder: (context) => [
              const   PopupMenuItem<int>(value: 0, child:  Text('Logout')),


              ],
            ),
          ],
        ),

        body:  Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _getRadialGauge(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              !_stopWatchTimer.isRunning ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue ),

                  onPressed: _startTimer,
                  child: const Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ): const SizedBox(),

              _stopWatchTimer.isRunning ?   Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child:ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen ),

                  onPressed:_stopTimer,
                  child: const Text(
                    'Stop',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ) :const SizedBox(),

            ],
          ),
        ],
      ),
    )));
  }
  Widget _getRadialGauge() {
    return SfRadialGauge(
        axes:<RadialAxis>[RadialAxis( interval: 1, showFirstLabel: false,
          startAngle: 270, endAngle: 270, minimum: 0, maximum: 12,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data!;
                    final displayTime =
                    StopWatchTimer.getDisplayTime(value, hours: _isHours,milliSecond: false);
                    return
                      Container(
                        margin: const EdgeInsets.only(bottom: 150),
                        child: Text(
                          displayTime,
                          style: const TextStyle(
                              fontSize: 40,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),

                      );
                  },
                ),
                angle: 90,
                positionFactor: 0.5)
          ],


        ),
        ]
    )
    ;
  }

  Future<void> _startTimer() async {
    await _getCurrentPosition();

    if (!_isLocationEnabled) {
      return;
    }

    if (!await FlutterForegroundTask.canDrawOverlays) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'The app needs the SYSTEM_ALERT_WINDOW permission to function properly. Please grant the permission in the app settings.',
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ).then((value) => FlutterForegroundTask.openSystemAlertWindowSettings());
      }

      return;
    }

    await HomeScreenState().startForegroundTask();
    _saveData();
    _stopWatchTimer.onStartTimer();

    if (_currentPosition != null && _stopWatchTimer.isRunning) {
      final location = UserLocation(
        lat: _currentPosition!.latitude.toString(),
        lng: _currentPosition!.longitude.toString(),
      );

      final action = UserActions(
        location: location,
        time: stopedTimerData,
        type: 'start',
      );

      _userActionsProvider.fetchUserActions(action);
    }
  }


  Future<void> _stopTimer() async {
    await _getCurrentPosition();
    if (!_isLocationEnabled) return;

    if (!await FlutterForegroundTask.canDrawOverlays) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'The app needs the SYSTEM_ALERT_WINDOW permission to function properly. Please grant the permission in the app settings.',
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
      return;
    }

    await HomeScreenState().stopForegroundTask();
    _removeData();
    _stopWatchTimer.onStopTimer();

    if (_currentPosition != null && !_stopWatchTimer.isRunning) {
      final location = UserLocation(
          lat: _currentPosition!.latitude.toString(),
          lng: _currentPosition!.longitude.toString());
      final action = UserActions(
        location: location,
        time: stopedTimerData,
        type: 'end',
      );
      _userActionsProvider.fetchUserActions(action);
    }
  }

  void _handleClick(int item) {
    switch (item) {
      case 0:
        _sessionDataProvider.deleteAllToken();
        context.read<LoginCubit>().logOut();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        const LoginScreen()), (Route<dynamic> route) => false);
        break;
    }
  }
}
