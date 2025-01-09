// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/services/auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart ' as http;

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.id});

  final String id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<dynamic, dynamic> task = {};
  bool gettingTask = false;
  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Future<void> getDetails() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    var access = authProvider.accessToken;
    var detailURL = '$rootAPIUrl/api/v1/task/${widget.id}/';
    setState(() {
      gettingTask = true;
    });
    var response = await http.get(Uri.parse(detailURL), headers: {
      'Authorization': 'Bearer $access',
      'Content-type': 'application/json'
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        gettingTask = false;
        task = responseData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Format the current date as "Apr 10, 2021"
    String formattedDate = DateFormat('MMM d, y').format(currentDate);

    List chatMessages = [
      'great that worked😌 thank you',
      'how do i reset my password?',
      'here\'s the plan for Q3...',
      'that\'s  what we have in the list😂',
      'cool, any other book in project management',
      'thanks',
      'yeah looks promising',
      'thanks everyone, that\'s a great meeting',
      'record time too',
      'exactly',
      'I know right',
      'When is tomorrows meeting time'
    ];
    return Scaffold(
        appBar: _appBar(formattedDate),
        body: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Drawer(
              width: 300,
              backgroundColor: Colors.grey.shade50,
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 100),
                      child: DrawerHeader(
                          padding: EdgeInsets.all(0),
                          margin: EdgeInsets.all(0),
                          child: Text(
                            'taskManager.com',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                fontStyle: FontStyle.italic),
                          ))),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: ListTile(
                      leading:
                          Icon(Icons.file_copy_rounded, color: Colors.white),
                      title: Text(
                        'TaskID: ${task['id']}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      selectedTileColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the radius as needed
                      ),
                      selected: true,
                    ),
                  )
                ],
              ),
            ),
            gettingTask
                ? Center(child: CircularProgressIndicator())
                : Container(
                    width: 800,
                    margin: EdgeInsets.only(left: 30, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.04)),
                                    child: IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(
                                            Icons.arrow_back_ios_new_rounded))),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 500,
                                  child: Text(
                                    'Task: ${task['name']}',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.blue)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        // SizedBox(width: 5,),
                                        Text(
                                          'Edit',
                                          style: TextStyle(color: Colors.blue),
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.red)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.remove_circle_rounded,
                                          color: Colors.red,
                                        ),
                                        // SizedBox(width: 5,),
                                        Text(
                                          'Remove',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 65, bottom: 15),
                          child: Row(
                            children: [
                              Text(
                                'Priority:',
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Medium',
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 65),
                          child: Row(
                            children: [
                              Text(
                                'Assigned to: ',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              if (task['assigned_to'] != null &&
                                  task['assigned_to'].isNotEmpty)
                                for (String email in task['assigned_to'])
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      email,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                              else
                                Text('Not assigned Yet')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 65),
                          child: Row(
                            children: [
                              Text(
                                'Due Date:',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(formatDateTime(task['due_date']))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 65),
                          child: Row(
                            children: [
                              Text(
                                'Created by:',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    task['user']['email'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 65),
                            child: Text(
                              'Discussions(25)',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          padding: EdgeInsets.only(top: 20),
                          margin: EdgeInsets.only(left: 65),
                          height: 590,
                          width: 800,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 490,
                                child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: Text('user ${index + 1}:'),
                                        trailing: Text(DateFormat.jm()
                                            .format(DateTime.now())),
                                        title: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.green.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(
                                              chatMessages[index],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      );
                                    },
                                    separatorBuilder: (context, builder) =>
                                        SizedBox(
                                          height: 10,
                                        ),
                                    itemCount: chatMessages.length),
                              ),
                              Spacer(),
                              Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: 'Say something',
                                        border: InputBorder.none,
                                        suffixIcon: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.send))),
                                  ))
                            ],
                          ),
                          // child: ListView.separated(itemBuilder: (context, builder){
                          //   return Container(height: 30, color: Colors.blue,);
                          // }, separatorBuilder: (context, builder) => SizedBox(height: 10,), itemCount: 30),
                        )
                      ],
                    ),
                  ),
            SizedBox(
              width: 200,
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.white,
                    Colors.blue.shade50,
                    Colors.blue.shade100,
                    Colors.blue.shade200
                  ]),
                  borderRadius: BorderRadius.circular(15)),
              height: 200,
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded),
                  SizedBox(height:10),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Description: ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    TextSpan(
                      text: task['description'],
                      style: TextStyle(fontSize: 17)
                    ),
                  ]))
                ],
              ),
            )
          ],
        ));
  }

  AppBar _appBar(String formattedDate) {
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      title: Text(
        'taskManager.com',
        style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic),
      ),
      centerTitle: true,
      leadingWidth: 300,
      leading: Container(
        margin: const EdgeInsets.only(left: 70, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back, Andrew',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade300),
            )
          ],
        ),
      ),
      actions: [
        Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: Icon(
              Icons.person,
              size: 30,
              color: Colors.black,
            )),
        SizedBox(
          width: 20,
        ),
        // Container(
        //   padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        //   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        //   margin: EdgeInsets.only(right: 20),
        //   child: Row(
        //     children: [
        //       Icon(Icons.add, color: Colors.black,),
        //       SizedBox(width: 5,),
        //       Text('Create New Task', style: TextStyle(color: Colors.black),)
        //     ]
        //   ),
        // )
      ],
    );
  }
}
