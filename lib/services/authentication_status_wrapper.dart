// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:frontend/forms/login.dart';
import 'package:frontend/services/auth.dart';
import 'package:provider/provider.dart';

class HomeWrapper extends StatelessWidget {
  final Widget child;

  const HomeWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return authProvider.isLoggedIn ? child : LoginForm();
      },
    );
  }
}

class DetailPageWrapper extends StatelessWidget {
  final Widget child;

  const DetailPageWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return authProvider.isLoggedIn ? child : LoginForm();
      },
    );
  }
}
