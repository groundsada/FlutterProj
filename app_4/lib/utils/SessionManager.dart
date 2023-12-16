import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _tokenKey = 'access_token';
  static const String _expiryKey = 'expiry';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _usernameKey = 'username';

  static Future<void> saveToken(
      String token, DateTime expiry, String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_expiryKey, expiry.millisecondsSinceEpoch);
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_usernameKey, username);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<DateTime?> getExpiryDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? expiryMilliseconds = prefs.getInt(_expiryKey);

    return expiryMilliseconds != null
        ? DateTime.fromMillisecondsSinceEpoch(expiryMilliseconds)
        : null;
  }

  static Future<void> clearToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_expiryKey);
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_usernameKey);
  }

  static Future<bool> isTokenExpired() async {
    final String? token = await getToken();
    if (token == null) {
      return true;
    }

    final DateTime? expiry = await getExpiryDate();
    if (expiry == null || DateTime.now().isAfter(expiry)) {
      return true;
    }

    return false;
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<void> initialize() async {
    final String? token = await getToken();
    final DateTime? expiry = await getExpiryDate();

    if (token != null && expiry != null && !(await isTokenExpired())) {
    } else {
      await clearToken();
    }
  }
}
