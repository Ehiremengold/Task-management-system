// ignore_for_file: prefer_const_constructors
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/auth.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class createTaskAlert extends StatefulWidget {
  const createTaskAlert({super.key});

  @override
  State<createTaskAlert> createState() => _createTaskAlertState();
}

class _createTaskAlertState extends State<createTaskAlert> {
  int selectedStatusIndex = 0;
  List<String> status = ["Incomplete", "In Progress", "Complete"];
  late String selectedStatus;
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  List<String> priority = ["High", "Medium", "Low"];
  String? selectedPriority;

  DateTime? selectedDate;

  Future<void> createTask() async {
    // create TASK
    final authProvider = Provider.of<AuthProvider>(context);
    const createAPIUrl = '$rootAPIUrl/api/v1/task/';
    final access = authProvider.accessToken;
    var taskName = taskNameController.text.trim();
    var response = http.post(Uri.parse(createAPIUrl), headers: {
      'Authorization': 'Bearer $access',
    }, body: {
      "name": taskName,
      "description": "Stuff",
      "status": "Incomplete",
      "priority": "High",
      "due_date": "2024-06-11T6:00:00Z",
      "assigned_to": ["admin@gmail.com", "user@company.com"]
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ListTile(
        title: Text(
          'Create new task',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: Icon(Icons.edit),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: taskNameController,
              decoration: InputDecoration(
                  labelText: 'Task name',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              maxLines: 4,
              controller: taskDescriptionController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left:20, top: 20),
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Select Status',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 8,
            ),
            Column(
              children: status.asMap().entries.map((entry) {
                final index = entry.key;
                final label = entry.value;
                return RadioListTile<int>(
                  title: Text(label),
                  value: index,
                  groupValue: selectedStatusIndex,
                  onChanged: (value) {
                    setState(() {
                      selectedStatusIndex = value!;
                      selectedStatus = status[selectedStatusIndex];
                    });
                    setState(() {}); // Force UI rebuild
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: 320,
              child: DatePickerDialog(
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                helpText: 'Due date',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Priority:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: priority
                  .map((index) => ElevatedButton(
                      style: ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.all(19)),
                          backgroundColor: selectedPriority == index
                              ? WidgetStatePropertyAll(Colors.blue)
                              : WidgetStatePropertyAll(Colors.white),
                          foregroundColor: selectedPriority == index
                              ? WidgetStatePropertyAll(Colors.white)
                              : WidgetStatePropertyAll(Colors.blue)),
                      onPressed: () {
                        setState(() {
                          selectedPriority = index;
                        });
                      },
                      child: Text(index.toString())))
                  .toList(),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Assigned to:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  helperText:
                      'Enter emails assigned to this Task separated by commas',
                  helperStyle: TextStyle(color: Colors.grey)),
              maxLines: 4,
            ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () {}, child: Text('CREATE'))],
    );
  }
}
