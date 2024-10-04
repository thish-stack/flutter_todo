import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:producthive/models/task_model.dart';
import 'package:producthive/pages/task_form.dart';
import 'package:producthive/utils/todo_list.dart';
import 'package:producthive/database/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final DateFormat formatter = DateFormat.yMMMd();

  List<Task> toDoList = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Task> tasks = await _dbHelper.getTasks();
    // Debugging: Check what tasks are loaded
    print('Loaded Tasks: ${tasks.length}'); // Debugging statement
    for (var task in tasks) {
      print(
          'Task: ${task.name}, Completed: ${task.completed}'); // Debugging statement
    }
    print('db load tasks called');
    setState(() { 
      toDoList = tasks;
    });
  }

  Future<void> saveNewTask(String taskName, DateTime date) async {
    Task newTask = Task(
      name: taskName,
      completed: false,
      date: date,
    );
    
    try {
  await _dbHelper.addTask(newTask);
} catch (e) {
  print('Error adding task: $e');
}

    await _loadTasks(); // Reload tasks after insertion
    
  }

  Future<void> updateTask(
      int index, String updatedTaskName, DateTime date) async {
    Task updatedTask = toDoList[index];
    updatedTask.name = updatedTaskName;
    updatedTask.date = date;

    await _dbHelper.updateTask(updatedTask);
    await _loadTasks(); // Reload tasks after update
  }

  Future<void> deleteTask(int index) async {
    await _dbHelper.deleteTask(toDoList[index].id!);
    await _loadTasks(); // Reload tasks after deletion
  }

  void checkBoxChanged(int index) async {
    setState(() {
      toDoList[index].completed = !toDoList[index].completed;
    });
    await _dbHelper.updateTask(toDoList[index]);
    await _loadTasks(); // Reload tasks after updating the checkbox state
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
        title: const Text('Todo'),
      ),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (BuildContext context, int index) {
          return TodoList(
            taskName: toDoList[index].name,
            taskCompleted: toDoList[index].completed,
            onChanged: (value) => checkBoxChanged(index),
            deleteFunction: (context) => deleteTask(index),
            editFunction: (context) async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskForm(
                    onSaveTask: (updatedTaskName, updatedDate) =>
                        updateTask(index, updatedTaskName, updatedDate),
                    initialTaskName: toDoList[index].name,
                    initialDate: toDoList[index].date,
                  ),
                ),
              );
              _showToastIfTaskSaved(result);
            },
            taskDate: formatter.format(toDoList[index].date),
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
