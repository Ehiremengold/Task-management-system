import 'package:flutter/material.dart';

class AccountTypeProvider extends ChangeNotifier {
  String? _accountType = 'individual';

  String? get accountType => _accountType;

  void setAccountType(String? accountType) {
    _accountType = accountType;
    notifyListeners();
  }

  void clearAccountType() {
    _accountType = null;
    notifyListeners();
  }
}
