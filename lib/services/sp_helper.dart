import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  // keys
  static String userLoggedInKey = "USERLOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  // we cannot save SP as a variable because the getInstance() returns a Future

  // saving data to SP
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUsername(String username) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(userNameKey, username);
  }

  static Future<bool> saveEmail(String email) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(userEmailKey, email);
  }


  // getting data from SP

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userLoggedInKey);
  }

  static Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  static Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  // Remove data from SP
  static Future<bool> removeUserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}
