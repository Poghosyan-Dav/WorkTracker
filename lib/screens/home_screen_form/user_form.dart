import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:worktracker/screens/Login/login_screen.dart';
import 'package:worktracker/services/data_provider/session_data_providers.dart';
import 'package:worktracker/services/data_provider/users_info_api.dart';
import 'package:worktracker/services/models/user_actions.dart';
import 'package:app_settings/app_settings.dart';

import '../../main.dart';
import '../../services/blocs/login/login_bloc.dart';

class UserScreen extends StatefulWidget {
  const  UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with WidgetsBindingObserver {
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
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;





  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _toggleServiceStatusStream();
    _loadData();

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


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      // App is in the foreground
        final prefs = await SharedPreferences.getInstance();
        final savedWorkTime = prefs.getString('work_time') ?? '';
        if (savedWorkTime.isNotEmpty) {
        // Calculate time elapsed since the app was last opened
        final currentTime = DateTime.now();
        final parsedWorkTime = DateTime.parse(savedWorkTime);

        final timeElapsed = currentTime.difference(parsedWorkTime);
        final savedTime = _stopWatchTimer.rawTime.value;
        final updatedTime = savedTime + timeElapsed.inMilliseconds;

        // Update the stopwatch timer
        _stopWatchTimer.setPresetTime(mSec: updatedTime);
        }
    }
  }

  Future<void> checkLocationServiceStatus() async {
    bool isLocationEnabled = await isLocationServiceEnabled();
    if (isLocationEnabled) {
      await requestLocationPermission();
      _isLocationEnabled = isLocationEnabled;

    } else {

      showLocationPermanentlyDeniedDialog();
     _isLocationEnabled = isLocationEnabled;
    }
  }
  void showSomething() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission Permanently Denied4'),
          content: Text('Location permission has been permanently denied. Please go to the app settings and enable location permission to use this feature.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openAppSettings(type: AppSettingsType.location);

              },
            ),
          ],
        );
      },
    );
  }
  void showLocationDisclosure() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission Disclosure3'),
          content: Text('This app requires access to your location to provide accurate results for nearby places.'),
          actions: <Widget>[
            TextButton(
              child: Text('Decline'),
              onPressed: () {
                Navigator.of(context).pop();

                // Handle user declining location permission
              },
            ),
            TextButton(
              child: Text('Accept'),
              onPressed: () {
                Navigator.of(context).pop();
                requestLocationPermission();
              },
            ),
          ],
        );
      },
    );
  }
  Future<bool> isLocationServiceEnabled() async {
    LocationPermission permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }

    bool serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    return serviceEnabled;
  }
  Future<void> requestLocationPermission() async {
    var status = await handler.Permission.locationWhenInUse.request();

    if (status.isGranted) {
      _getCurrentPosition();
    } else if (status.isDenied) {
      // Handle case when user denies the location permission request
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
                onPressed: () => _openAppSettings(),
                child: const Text('SETTINGS'),
              ),
            ],
          ),);
    } else if (status.isPermanentlyDenied) {
      showLocationPermanentlyDeniedDialog();
      // Handle case when user permanently denies the location permission request
    }
  }


  void showLocationPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Permanently Denied'),
          content:const Text('''To see maps for automatically tracked activities, allow Work Tracker to use your location all of the time.\n
Location permission has been permanently denied. Please go to the app settings and enable location permission to use this feature.\n
Work tracker collects location data to show place on a map even when the app is closed or not in use.'''),
          actions: <Widget>[
            TextButton(
              child:const Text('Deny'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Turn on'),
              onPressed: ()async {
                if(Platform.isIOS){
                 await requestLocationPermission().whenComplete(() =>  Navigator.of(context).pop());
                }else {
                  await _getCurrentPosition().whenComplete(() =>  Navigator.of(context).pop());
                }

              },
            ),
          ],
        );
      },
    );
  }
  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
            _serviceStatusStreamSubscription?.cancel();
            _serviceStatusStreamSubscription = null;
          }).listen((serviceStatus) async {

            if (serviceStatus == ServiceStatus.disabled) {
              await  HomeScreenState().stopForegroundTask();
            await  _saveData();
              _stopWatchTimer.onStopTimer();


            }
            print(serviceStatus);
          });
    }
  }
  Future<void> _getCurrentPosition() async {


      try {
        final position = await _geolocatorPlatform.getCurrentPosition(
            locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high));
        setState(() {
          _currentPosition = position;
          _isLocationEnabled = true;
        });
      } catch (error) {
        print(error);
        Fluttertoast.showToast(msg: "$error").whenComplete(() =>Future.delayed(Duration(milliseconds: 700),()=> _openLocationSettings()));
        _isLocationEnabled = false;
      }
    }



  _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedWorkTime = prefs.getString('work_time') ?? '';
    bool isLocationEnabled = await isLocationServiceEnabled();

    if (savedWorkTime.isNotEmpty) {
      final parsedWorkTime = DateTime.parse(savedWorkTime);
      final dateNow = DateTime.now();
      final difference = parsedWorkTime.difference(dateNow).inMilliseconds;
      _stopWatchTimer.setPresetTime(mSec: difference.abs());
      _checkPermission();
    }else if(!isLocationEnabled){
      showLocationPermanentlyDeniedDialog();
    }
  }
  _removeData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('work_time');
  }
  _saveData() async {
    final currentTime = _stopWatchTimer.rawTime.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'work_time',
      DateTime.now()
          .subtract(Duration(milliseconds: currentTime))
          .toIso8601String(),
    );
  }
  @override
  void dispose() async {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

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

                const   PopupMenuItem<int>(value: 0, child:  Text('Open Location Settings')),

                const   PopupMenuItem<int>(value: 1, child:  Text('Open App Settings')),

                const   PopupMenuItem<int>(value: 2, child:  Text('Logout')),


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
  Future<void> _checkPermission() async {
    await _getCurrentPosition();

    if (!_isLocationEnabled) {
      return;
    }
    if(Platform.isIOS){
      if (!await FlutterForegroundTask.canDrawOverlays) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Permission Required'),
              content: const Text(
                'The app needs the SYSTEM_ALERT_WINDOW permission to function properly. Please grant the permission in the Background App Refresh manually.',
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ).then((value) => AppSettings.openAppSettings());
        }

        return;
      }
      await HomeScreenState().startForegroundTask();
      _saveData();
      _stopWatchTimer.onStartTimer();
    }else {
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
    }



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
        _openLocationSettings();
        break;
      case 1:
        _openAppSettings();
            break;
      case 2:
        _sessionDataProvider.deleteAllToken();
        context.read<LoginCubit>().logOut();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        const LoginScreen()), (Route<dynamic> route) => false);
        break;
    }
  }

  void _openAppSettings() async {
    final opened = await _geolocatorPlatform.openAppSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Application Settings.';
      Fluttertoast.showToast(msg: displayValue);

    } else {
      displayValue = 'Error opening Application Settings.';
      Fluttertoast.showToast(msg: displayValue);
    }


  }

  void _openLocationSettings() async {
    final opened = await _geolocatorPlatform.openLocationSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Location Settings';
      Fluttertoast.showToast(msg: displayValue);
    } else {
      displayValue = 'Error opening Location Settings';
      Fluttertoast.showToast(msg: displayValue);

    }


  }

}
