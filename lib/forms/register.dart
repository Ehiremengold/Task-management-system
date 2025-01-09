// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable
import 'package:frontend/forms/account_type.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/services/account_type_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/forms/login.dart';
import 'package:frontend/services/auth.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool changeObscureOption = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  bool creatingAccount = false;
  bool loggingIn = false;
  String emailError = '';
  String passwordError = '';
  String genericError = 'An Error occurred creating your account';

  Future<void> register() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String repeatPassword = repeatPasswordController.text.trim();
    const String loginAPIUrl = '$rootAPIUrl/api/token/';
    const String registerAPIUrl = '$rootAPIUrl/api/v1/create-account/';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final accountTypeProvider =
        Provider.of<AccountTypeProvider>(context, listen: false);

    if (accountTypeProvider.accountType == null) {
      Navigator.of(context).push(
          CupertinoPageRoute(builder: (context) => const AccountTypeForm()));
    }

    setState(() {
      creatingAccount = true;
      passwordError = '';
    });

    try {
      var response = await http.post(Uri.parse(registerAPIUrl), body: {
        'email': email,
        'password': password,
        'confirm_password': repeatPassword,
        'account_type': accountTypeProvider.accountType?.toLowerCase().trim()
      });

      authProvider.clearAuthData(); // Clear any store auth token data
      if (response.statusCode == 200) {
        authProvider.setLoggedInUserEmail(email);
        setState(() {
          creatingAccount = false;
          loggingIn = true;
        });
        try {
          var loginResponse = await http.post(Uri.parse(loginAPIUrl),
              body: {'email': email, 'password': password});
          final Map<String, dynamic> responseData =
              json.decode(loginResponse.body);
          final String accessToken = responseData['access'];
          authProvider.setAuthData(accessToken);
          authProvider.setAuthenticationStatusToLoggedIn();
          Navigator.of(context)
              .push(CupertinoPageRoute(builder: (context) => const Home()));
        } catch (e) {
          throw Exception(e);
        }
      } else {
        final responseData = json.decode(response.body);
        setState(() {
          loggingIn = false;
          creatingAccount = false;
          if (responseData['email'] != null &&
              responseData['email'].isNotEmpty) {
            emailError = responseData['email']
                .join(', '); // Joining list elements into a single string
          } else if (responseData['password'] != null &&
              responseData['password'].isNotEmpty) {
            passwordError = responseData['password']
                .join('\n'); // Joining list elements into a single string
          } else {
            genericError =
                'Unknown error occurred'; // Set a generic error message
          }
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context).pop('/landing-page');
          },
          child: Text(
            'taskManager.com',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Drawer(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset('assets/illustration/tasks.png')],
            ),
          ),
          SizedBox(
            width: 350,
          ),
          Center(
            child: Card(
              elevation: 4,
              child: Container(
                width: 530,
                height: 555,
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sign up',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Email entry
                        TextField(
                          controller: emailController,
                          onChanged: (value) => {
                            setState(() {
                              emailError = '';
                            })
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: emailError.isNotEmpty
                                ? TextStyle(color: Colors.red)
                                : TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: emailError.isNotEmpty
                                      ? Colors.red
                                      : Colors.black),
                            ),
                            errorText: emailError.isNotEmpty
                                ? capitalize(emailError)
                                : null,
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        // Password entry
                        TextField(
                          onChanged: (value) => {
                            setState(() {
                              passwordError = '';
                            })
                          },
                          controller: passwordController,
                          obscureText: changeObscureOption,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: passwordError.isNotEmpty
                                  ? TextStyle(color: Colors.red)
                                  : TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: passwordError.isNotEmpty
                                        ? Colors.red
                                        : Colors.grey),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    changeObscureOption = !changeObscureOption;
                                  });
                                },
                                icon: changeObscureOption
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              )),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        // Repeat password
                        TextField(
                          onChanged: (value) => {
                            setState(() {
                              passwordError = '';
                            })
                          },
                          controller: repeatPasswordController,
                          obscureText: changeObscureOption,
                          decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: passwordError.isNotEmpty
                                  ? TextStyle(color: Colors.red)
                                  : TextStyle(color: Colors.grey),
                              errorText: passwordError.isNotEmpty
                                  ? capitalize(passwordError)
                                  : null,
                              errorStyle: TextStyle(color: Colors.red),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: passwordError.isNotEmpty
                                        ? Colors.red
                                        : Colors.black),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    changeObscureOption = !changeObscureOption;
                                  });
                                },
                                icon: changeObscureOption
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              )),
                        ),

                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                fixedSize:
                                    MaterialStatePropertyAll(Size(200, 40)),
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.blue),
                                foregroundColor:
                                    MaterialStatePropertyAll(Colors.white),
                                padding: MaterialStatePropertyAll(
                                    EdgeInsets.only(top: 8, bottom: 8))),
                            onPressed: register,
                            child: loggingIn | creatingAccount
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Create account',
                                    maxLines: 1,
                                  )),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) => LoginForm()));
                                },
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.blue),
                                ))
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// captialize first letter
String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}
