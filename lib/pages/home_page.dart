// homepage.dart

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:producthive/models/task_model.dart';
import 'package:producthive/pages/task_form.dart';
import 'package:producthive/utils/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> toDoList = [
    {'name': 'Learn Flutter', 'completed': true, 'date': DateTime.now()},
    {'name': 'Drink Coffee', 'completed': false, 'date': DateTime.now()},
    {'name': 'Drink Coffee', 'completed': false, 'date': DateTime.now()},
    {'name': 'Drink Coffee', 'completed': false, 'date': DateTime.now()},
    {'name': 'Drink Coffee', 'completed': false, 'date': DateTime.now()},
    {'name': 'Learn Flutter', 'completed': true, 'date': DateTime.now()},
    {'name': 'Learn Flutter', 'completed': true, 'date': DateTime.now()},
  ];

  // final List<Task> toDoList = [];

  final DateFormat formatter = DateFormat.yMMMd();

  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index]['completed'] = !toDoList[index]['completed'];
    });
  }

  void saveNewTask(String taskName, DateTime date) {
    setState(() {
      toDoList.add({'name': taskName, 'completed': false, 'date': date});
    });
  }

  void updateTask(int index, String updatedTaskName, DateTime date) {
    setState(() {
      toDoList[index]['name'] = updatedTaskName;
      toDoList[index]['date'] = date;
    });
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  void _showToastIfTaskSaved(String? result) {
    if (result != null && result == 'Task saved successfully!') {
      Fluttertoast.showToast(
        msg: result,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Todo',
        ),
      ),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (BuildContext context, int index) {
          return TodoList(
            taskName: toDoList[index]['name'],
            taskCompleted: toDoList[index]['completed'],
            onChanged: (value) => checkBoxChanged(index),
            deleteFunction: (context) => deleteTask(index),
            editFunction: (context) async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskForm(
                    onSaveTask: (updatedTaskName, updatedDate) =>
                        updateTask(index, updatedTaskName, updatedDate),
                    initialTaskName: toDoList[index]['name'],
                    initialDate: toDoList[index]['date'],
                  ),
                ),
              );
              _showToastIfTaskSaved(result);
            },
            taskDate: formatter.format(toDoList[index]['date']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFE2267F), Color(0xFFE94E97), Color(0xFFEF6DAB)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.3),
                blurRadius: 10,
                // spreadRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskForm(
                onSaveTask: (newTaskName, newDate) =>
                    saveNewTask(newTaskName, newDate),
              ),
            ),
          );
          _showToastIfTaskSaved(result);
        },
      ),
    );
  }
}
