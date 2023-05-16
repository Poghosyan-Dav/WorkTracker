import 'package:geolocator/geolocator.dart';

abstract class UsersLocation {

  Future<void> getCurrentPosition();

  Future<bool> handleLocationPermission();

  Future<void> getAddressFromLtng(Position position);
}