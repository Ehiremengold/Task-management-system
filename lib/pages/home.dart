// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/detail.dart';
import 'package:frontend/services/auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/createTaskAlert.dart';
import '../data/data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool gettingTasks = false;
  List<dynamic> tasks = [];
  Map<String, int> taskCounts = {
    'Complete': 0,
    'Incomplete': 0,
    'In Progress': 0,
  };

  @override
  void initState() {
    super.initState();
    getTask(); // Call getTask from initState
  }

  Future<void> getTask() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    final access = authProvider.accessToken;
    setState(() {
      gettingTasks = true;
    });
    const String tasksURL = '$rootAPIUrl/api/v1/tasks/';
    var response = await http
        .get(Uri.parse(tasksURL), headers: {'Authorization': 'Bearer $access'});

    if (response.statusCode == 200) {
      setState(() {
        gettingTasks = false;
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      tasks = responseData['tasks'];
      taskCounts = Map<String, int>.from(responseData['status_counts']);
    } else {
      setState(() {
        gettingTasks = false;
      });
      print(response.body);
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    // getTask();
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Format the current date as "Apr 10, 2021"
    String formattedDate = DateFormat('MMM d, y').format(currentDate);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/landing-page');
            },
            child: Text(
              'taskManager.com',
              style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic),
            ),
          ),
          centerTitle: true,
          leadingWidth: 300,
          leading: Container(
            margin: const EdgeInsets.only(left: 70, top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back',
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
            GestureDetector(
              onTap: () async {
                final selectedStatus = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return createTaskAlert();
                  },
                );
                if (selectedStatus != null) {
                  setState(() {
                    // Handle selectedStatus
                  });
                }
              },
              child: Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                margin: EdgeInsets.only(right: 20),
                child: Row(children: [
                  Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Create New Task',
                    style: TextStyle(color: Colors.black),
                  )
                ]),
              ),
            ),
          ],
        ),
        body: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Drawer(
                width: 300,
                backgroundColor: Colors.grey.shade50,
                child: ListView(
                  children: [
                    DrawerHeader(
                      margin: EdgeInsets.only(left: 30, top: 100),
                      child: Container(
                          child: Text(
                        'taskManager.com',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            fontStyle: FontStyle.italic),
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.all(30),
                      child: SizedBox(
                        height: 600,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'All task(s)',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              leading: Icon(
                                Icons.task,
                                color: Colors.black,
                              ),
                            ),
                            Image.asset('assets/illustration/worker.png'),
                            TextButton(
                                onPressed: () {
                                  var authProvider = Provider.of<AuthProvider>(
                                      context,
                                      listen: false);
                                  setState(() {
                                    authProvider
                                        .setAuthenticationStatusToLoggedOut();
                                  });
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: authProvider.isLoggedIn ? Row(
                                  children: [
                                    Text(
                                      'Sign Out',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(Icons.logout_rounded,
                                        color: Colors.grey)
                                  ],
                                ): Row(
                                  children: [
                                    Text(
                                      'Sign In',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(Icons.login_rounded,
                                        color: Colors.grey)
                                  ],
                                )),
                            // GestureDetector(
                            //   onTap: () {

                            //   },
                            //   child: Container(
                            //     decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                            //     margin: EdgeInsets.only(left: 30),
                            //     child: ,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            SizedBox(
              width: 30,
            ),
            Column(
              children: [
                // a row of incomplete, in progress, complete tasks
                Container(
                  margin: EdgeInsets.all(25),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10)),
                  height: 160,
                  width: 1100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/icons/complete.png',
                            width: 50,
                          ),
                          // Icon(Icons.done),
                          Text('Complete'),
                          Text(
                            taskCounts['Complete'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/icons/progress.png',
                            width: 50,
                          ),
                          // Icon(Icons.),
                          Text('In Progress'),
                          Text(taskCounts['In Progress'].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/icons/incomplete.png',
                            width: 50,
                          ),
                          Text('Incomplete'),
                          Text(taskCounts['Incomplete'].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26))
                        ],
                      )
                    ],
                  ),
                ),

                // a table of tasks
                Container(
                  width: 1100,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10)),
                  child: tasks.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              Text(
                                'No Task created',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 70,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    fixedSize:
                                        WidgetStatePropertyAll(Size(200, 40)),
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.blue),
                                    foregroundColor:
                                        WidgetStatePropertyAll(Colors.white),
                                  ),
                                  onPressed: () async {
                                    final selectedStatus =
                                        await showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return createTaskAlert();
                                      },
                                    );
                                    if (selectedStatus != null) {
                                      setState(() {
                                        // Handle selectedStatus
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Create New Task',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(Icons.add)
                                    ],
                                  )),
                            ],
                          ),
                        )
                      : DataTable(
                          // dividerThickness: 4,
                          columns: [
                            DataColumn(
                                label: Text(
                              'S/N',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Priority',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Due Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'Created',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataColumn(label: Container()),
                          ],
                          rows: gettingTasks
                              ? List.generate(tasks.length, (index) {
                                  return DataRow(
                                    cells: List.generate(tasks.length,
                                        (cellIndex) {
                                      return DataCell(CircularProgressIndicator(
                                          color: Colors.blue));
                                    }),
                                  );
                                })
                              : List.generate(tasks.length, (index) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text((index + 1).toString())),
                                      DataCell(
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    DetailPage(
                                                        id: tasks[index]['id']),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            tasks[index]['name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          tasks[index]['status'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: PriorityIndicator(
                                              priority: tasks[index]
                                                  ['priority'],
                                            ).getColor(),
                                          ),
                                          child: Text(
                                            tasks[index]['priority'],
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          formatDateTime(tasks[index]
                                                  ['due_date'] ??
                                              'N/A'),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          formatDateTime(
                                              tasks[index]['created'] ?? 'N/A'),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      DataCell(
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  title: Text('Modify Task?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {},
                                                      child: Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {},
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.more_horiz_rounded),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                        ),
                )
              ],
            ),
            Container(
                height: 800,
                width: 400,
                // decoration: BoxDecoration(border: Border.all(color: Colors.green)),
                child: HeatMapCalendar(
                  initDate: DateTime.now(),
                  defaultColor: Colors.white,
                  flexible: true,
                  colorMode: ColorMode.opacity,
                  // datasets: {
                  //   DateTime(2021, 1, 6): 3,
                  //   DateTime(2021, 1, 7): 7,
                  //   DateTime(2021, 1, 8): 10,
                  //   DateTime(2021, 1, 9): 13,
                  //   DateTime(2021, 1, 13): 6,
                  // },
                  colorsets: const {
                    1: Colors.red,
                    3: Colors.orange,
                    5: Colors.yellow,
                    7: Colors.green,
                    9: Colors.blue,
                    11: Colors.indigo,
                    13: Colors.purple,
                  },
                ))
          ],
        ));
  }
}

formatDateTime(String isoDateTime) {
  // Parse the ISO 8601 datetime string into a DateTime object
  DateTime dateTime = DateTime.parse(isoDateTime);
  // Format the DateTime object into the desired string format
  String formattedDateTime = DateFormat('MMM d, y').format(dateTime);

  return formattedDateTime;
}
