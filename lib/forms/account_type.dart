// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/forms/register.dart';
import 'package:provider/provider.dart';

import '../services/account_type_provider.dart';

class AccountTypeForm extends StatefulWidget {
  const AccountTypeForm({super.key});

  @override
  State<AccountTypeForm> createState() => _AccountTypeFormState();
}

class _AccountTypeFormState extends State<AccountTypeForm> {
  String? selectedAccountType = 'individual';
  List accountTypes = ['individual', 'company'];

  @override
  Widget build(BuildContext context) {
    final accountTypeProvider = Provider.of<AccountTypeProvider>(context);
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
            Navigator.of(context).pop('/home');
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
            child: Container(
              width: 600,
              height: 400,
              padding: EdgeInsets.only(left: 30, right: 30),
              // border: Border.all(color: Colors.grey),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Choose an Account Type',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: accountTypes
                        .map((index) => Container(
                              decoration: BoxDecoration(
                                  border: selectedAccountType == index
                                      ? Border.all(color: Colors.blue, width: 2)
                                      : Border.all(
                                          color: Colors.grey,
                                        ),
                                  borderRadius: BorderRadius.circular(15)),
                              width: 200,
                              child: RadioListTile(
                                  title: Text(capitalize(index)),
                                  value: index,
                                  groupValue: selectedAccountType,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedAccountType = newValue;
                                      accountTypeProvider
                                          .setAccountType(selectedAccountType);
                                    });
                                  }),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 100),
                  GestureDetector(
                      onTap: () {},
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => RegisterForm()));
                          },
                          child: Text('Next')))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
