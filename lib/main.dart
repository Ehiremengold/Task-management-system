// ignore_for_file: unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/utils/scroll.dart';
import 'forms/account_type.dart';
import 'package:provider/provider.dart';
import 'forms/login.dart';
import 'forms/register.dart';
import 'pages/landing_page.dart';
import 'services/auth.dart';
import 'services/authentication_status_wrapper.dart';
import 'utils/clipper.dart';
import 'services/account_type_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AccountTypeProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return ScrollConfiguration(
      behavior: SmoothScrollBehavior(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          dividerTheme: const DividerThemeData(color:Colors.transparent),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            fontFamily: 'Poppins'),
        // home: Consumer<AuthProvider>(
        //   builder: (context, authProvider, _) {
        //     return authProvider.isLoggedIn ? const Home() : const LoginForm();
        //   },
        // ),
        // home: const Home(),
        home: LandingPage(),
        // home: const AccountTypeForm(),
        // home: const RegisterForm(),
        // home:const LoginForm(),
        routes: {
          // '/home': (context) => const HomeWrapper(
          //       child: Home(),
          //     ),
          // '/detail': (context) => const DetailPageWrapper(
          //       child: DetailPage(),
          //     ),
          '/account-type': (context) => const AccountTypeForm(),
          '/landing-page': (context) => LandingPage(),
          '/register': (context) => const RegisterForm(),
          '/login': (context) => const LoginForm(),
        },
      ),
    );
  }
}
