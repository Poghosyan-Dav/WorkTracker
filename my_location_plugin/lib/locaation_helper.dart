import 'package:flutter/services.dart';


class MyLocationPlugin {
  static const MethodChannel _channel = MethodChannel('my_location_plugin');

  static Future<void> initialize() async {
    await _channel.invokeMethod('initialize');
  }

  static Future<void> startLocationUpdates() async {
    await _channel.invokeMethod('startLocationUpdates');
  }
}

