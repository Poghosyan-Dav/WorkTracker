


import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:worktracker/base_data/base_api.dart';
import 'package:worktracker/screens/Login/login_screen.dart';
import 'package:worktracker/screens/users/users.dart';
import 'screens/home_screen_form/user_form.dart';
import 'services/blocs/login/login_bloc.dart';
import 'services/blocs/register/register_bloc.dart';
import 'services/blocs/user/user_bloc.dart';
import 'services/blocs/user/user_state.dart';
import 'services/data_provider/user_data_provider.dart';
import 'services/models/user_actions.dart';
import 'services/data_provider/session_data_providers.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  initialization();
  runApp(const WorkTrackerApp());
}


@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}
class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;
  SessionDataProvider sessionDataProvider = SessionDataProvider();
  Future<void> updateLocation(UserLocation location) async{
    var token = await sessionDataProvider.readsAccessToken();
    final userdataProvider = UserDataProvider();

    Map userData = {"location": {
    "lat":"${location.lat}",
    "lng":"${location.lng}"
    }};

    try {
      var response = await http.post(
        Uri.parse(Api.updateLocation),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':'Bearer $token'
        },
        body: json.encode(userData),
      );
      if (response.statusCode == 200) {

   debugPrint('Lat :${userData['location']['lat']} \n Lng :${userData['location']['lng']}');


      } else if (response.statusCode == 401) {
        bool isTrue = await userdataProvider.refresh();

        if (isTrue) {
          return await updateLocation(location); // Call saveFavorite recursively after refreshing token
        } else {
          debugPrint("false");
        }
      } else {
        debugPrint("failed");

      }
    } catch (e) {
      debugPrint("$e");
    }

  }
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    // You can use the getData function to get the stored data.
    final customData =
    await FlutterForegroundTask.getData<String>(key: 'customData');
    debugPrint('customData: $customData');
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    String formattedTimestamp =
    DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);

    FlutterForegroundTask.updateService(
      notificationTitle: 'WorkTracker',
      notificationText: 'Date: $formattedTimestamp',
    );

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    UserLocation userLocation = UserLocation(
        lat: position.latitude.toString(),
        lng: position.longitude.toString());
    await updateLocation(userLocation);

    // Send data to the main isolate.
    sendPort?.send(_eventCount);

    _eventCount++;
  }



  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    debugPrint('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    // Called when the notification itself on the Android platform is pressed.
    //
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // this function to be called.

    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/userscreen");
    _sendPort?.send('onNotificationPressed');
  }
}


Future initialization() async {

  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}
class WorkTrackerApp extends StatelessWidget {
  const WorkTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = UserDataProvider();

    return MultiBlocProvider(
              providers: [
        BlocProvider<LoginCubit>(create: (_) => LoginCubit(user)),
        BlocProvider<RegisterCubit>(create: (_) => RegisterCubit(user)),
       BlocProvider<UsersBloc>(create: (_) => UsersBloc(MyAccountInitial())),
      ],

      child: MaterialApp(
            debugShowCheckedModeBanner: false,

      initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/userscreen': (context) => const UserScreen(),
        },
      ),
    );
  }
}
class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final SessionDataProvider _sessionDataProvider = SessionDataProvider();
//String? _token;


  void _initForegroundTask() {

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
        'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'clock',
          backgroundColor: Colors.orange,
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 300000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }
  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      // This function requires `android.permission.SYSTEM_ALERT_WINDOW` permission.
      await FlutterForegroundTask.openSystemAlertWindowSettings();
    }

    // Android 12 or higher, there are restrictions on starting a foreground service.
    //
    // To restart the service on device reboot or unexpected problem, you need to allow below permission.
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
    final NotificationPermission notificationPermissionStatus =
    await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  Future<bool> startForegroundTask() async {
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      final isGranted =
      await FlutterForegroundTask.openSystemAlertWindowSettings();
      if (!isGranted) {
        debugPrint('SYSTEM_ALERT_WINDOW permission denied!');
        return false;
      }
    }

    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }

  Future<bool> stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('App was detached!');
      await _requestPermissionForAndroid();
      _initForegroundTask();
    });
    loginUser();
    super.initState();
  }


  Future<Widget> loginUser() async {
    final isValid = await _sessionDataProvider.readsAccessToken();
    final isAUser = await _sessionDataProvider.readRole() ?? '';
    final bool tokenIsExpired = await hasToken();
    if (isValid != null  && isAUser.contains('true') && tokenIsExpired) {
      return const UserScreen();
    }

    if (isValid != null && isAUser.contains('false') && tokenIsExpired) {
      return const UsersScreen();
    }

    return const LoginScreen();
  }

  Future<bool> hasToken() async {
    final token = await _sessionDataProvider.readsAccessToken();
    if (token != null) {
      // Check if the token has expired
      Map<String, dynamic> decodedToken = json.decode(
          ascii.decode(
              base64.decode(base64.normalize(token.split(".")[1]))
          )
      );
      if (DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000).isBefore(DateTime.now())) {
        // Token has expired, log the user out
        await _sessionDataProvider.deleteAllToken();
        return false;
      }
      // Token is valid, the user is logged in
      return true;
    }
    // Token not found, the user is not logged in
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: Scaffold(
        body: FutureBuilder<Widget>(
          future: loginUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            }
            return const SizedBox();
          },
        )

      ),
    );
  }

}
