const String baseUrl = 'https://phplaravel-1129724-3949044.cloudwaysapps.com';
const apiUrl = '$baseUrl/api';



class Api {
  //Login
  static String get login => '$apiUrl/login';
  static String get logout => '$apiUrl/logout';
  static String get refresh => '$apiUrl/refresh';

  //User api
  static String get updateLocation => '$apiUrl/location';
  static String get startAndEndActions => '$apiUrl/action';
  //Admin api
      //User api
      static String get getAllUsers => '$apiUrl/users';
      static String get deleteUsersFromHistory => '$apiUrl/info/delete';
      static String getUser(String id) => '$apiUrl/users/$id';
      static String deleteUser(int id) => '$apiUrl/users/$id';


  static String updateUser(int id) => '$apiUrl/users/$id';
      static String get createUsers => '$apiUrl/users';
      //Info users
      static String allInfo(String? dateTime)=>  '$apiUrl/info?date=$dateTime';
      static String  getInfo(String id) => '$apiUrl/info/$id';

}