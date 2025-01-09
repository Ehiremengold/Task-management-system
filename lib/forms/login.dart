// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/forms/register.dart';
import 'package:frontend/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

import '../pages/home.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool changeObscureOption = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoggingIn = false;
  String emailError = '';
  String genericError = '';
  String passwordError = '';
  String emailValue = '';
  String passwordValue = '';

  Future<void> login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    const String loginAPIUrl = '$rootAPIUrl/api/token/';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (email.isEmpty) {
      setState(() {
        emailError = 'Please enter your email';
        isLoggingIn = false;
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        passwordError = 'Password cannot be empty';
        isLoggingIn = false;
      });
      return;
    }
    setState(() {
      isLoggingIn = true;
      emailError = '';
      passwordError = '';
      genericError = '';
    });

    try {
      authProvider.clearAuthData();
      var response = await http.post(Uri.parse(loginAPIUrl),
          body: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String accessToken = responseData['access'];
        authProvider.setAuthData(accessToken);
        authProvider.setLoggedInUserEmail(responseData['email']);
        authProvider.setAuthenticationStatusToLoggedIn();
        setState(() {
          isLoggingIn = false;
        });
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (context) => const Home()));
      } else {
        final responseData = json.decode(response.body);
        final List<dynamic> error = responseData['error'];
        setState(() {
          isLoggingIn = false;
          if (error.contains('Incorrect password, please try again.')) {
            passwordError = 'Incorrect password, please try again';
          } else if (error
              .contains('No account found with the provided email address.')) {
            emailError = 'No account found with the provided email address.';
          } else {
            // Handle other error cases if needed
            genericError = 'There is a problem Signing in';
          }
        });
      }
    } catch (e) {
      setState(() {
        isLoggingIn = false;
      });
      print('e: $e');
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
          onTap: (){
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
                width: 500,
                height: 450,
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
                      'Sign in',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: emailController,
                      onChanged: (value) {
                        setState(() {
                          emailValue = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color:
                              emailError.isNotEmpty ? Colors.red : Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: emailError.isNotEmpty
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                        errorText: emailError.isNotEmpty ? emailError : null,
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: changeObscureOption,
                      onChanged: (value) {
                        setState(() {
                          passwordValue = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: passwordError.isNotEmpty
                              ? Colors.red
                              : Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: passwordError.isNotEmpty
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                        errorText:
                            passwordError.isNotEmpty ? passwordError : null,
                        errorStyle: TextStyle(color: Colors.red),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              changeObscureOption = !changeObscureOption;
                            });
                          },
                          icon: changeObscureOption
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(200, 40)),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.only(top: 8, bottom: 8),
                        ),
                      ),
                      onPressed: login,
                      child: isLoggingIn
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                    SizedBox(height: 30),
                    if (genericError.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          genericError,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    Row(
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                  builder: (context) => RegisterForm()),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(fontSize: 15, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
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
