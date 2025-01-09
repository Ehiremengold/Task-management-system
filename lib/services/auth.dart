import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _accessToken;

  String? get accessToken => _accessToken;

  bool isLoggedIn = false;

  String? loggedUserEmail;

  void setAuthData(String accessToken) {
    _accessToken = accessToken;
    notifyListeners();
  }

  void clearAuthData() {
    _accessToken = null;
    notifyListeners();
  }

  void setAuthenticationStatusToLoggedIn() {
    isLoggedIn = true;
    notifyListeners();
  }

  void setAuthenticationStatusToLoggedOut() {
    isLoggedIn = false;
    _accessToken = null;
    notifyListeners();
  }

  void setLoggedInUserEmail(String email) {
    loggedUserEmail = email;
    notifyListeners();
  }
}
