import 'package:shared_preferences/shared_preferences.dart';


final SharedPrefsHelper prefsHelper =  SharedPrefsHelper();

class SharedPrefsHelper{

  static final SharedPrefsHelper _instance = SharedPrefsHelper._internal();

  factory SharedPrefsHelper() {
    return _instance;
  }

  SharedPrefsHelper._internal();

  SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    return 0;
  }

  String getToken() {
    return _prefs.getString("token");
  }

  Future<bool> setToken(String token) {
    return _prefs.setString("token", token);
  }
  String getUserId() {
    return _prefs.getString("userId");
  }

  Future<bool> setUserId(String userId) {
    return _prefs.setString("userId", userId);
  }
  String getMobile() {
    return _prefs.getString("mobile");
  }

  Future<bool> setMobile(String mobile) {
    return _prefs.setString("mobile", mobile);
  }
  String getFirstName() {
    return _prefs.getString("firstName");
  }

  Future<bool> setFirstName(String firstName) {
    return _prefs.setString("firstName", firstName);
  }
  String getGender() {
    return _prefs.getString("gender");
  }

  Future<bool> setGender(String gender) {
    return _prefs.setString("gender", gender);
  }
  int getAge() {
    return _prefs.getInt("age");
  }

  Future<bool> setAge(int age) {
    return _prefs.setInt("age", age);
  }
  String getEmail() {
    return _prefs.getString("email");
  }

  Future<bool> setEmail(String email) {
    return _prefs.setString("email", email);
  }

}
