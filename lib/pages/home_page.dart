import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:producthive/database/database_helper.dart';
import 'package:producthive/models/task_model.dart';
import 'package:producthive/pages/task_form.dart';
import 'package:producthive/utils/todo_list.dart';

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

    await _dbHelper.addTask(newTask);
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

  Future<void> deleteAllTasks() async {
    await _dbHelper
        .deleteAllTasks(); // Assuming you have a deleteAllTasks method in your DatabaseHelper class
    await _loadTasks(); // Reload tasks after deletion
    Fluttertoast.showToast(
      msg: "All tasks deleted successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void checkBoxChanged(int index) async {
    setState(() {
      toDoList[index].completed = !toDoList[index].completed;
    });
    await _dbHelper.updateTask(toDoList[index]);
    await _loadTasks();
  }

  Future<void> deleteConfirmDialog(BuildContext context, String action) async {
    final bool isClearAll = (action == "all");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isClearAll ? "Delete All Tasks" : "Confirm Delete Task"),
        content: Text(isClearAll
            ? "Are you sure you want to delete all tasks? "
            : "Are you sure you want to delete this task? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (isClearAll) {
                deleteAllTasks();
              } else {
                // deleteTask(context);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Clear All') {
                deleteConfirmDialog(context, "all");
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Clear All',
                  child: Text('Clear All'),
                ),
              ];
            },
          ),
        ],
      ),
      body: toDoList.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 130),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/taskloading.json',
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.4,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 0),
                    const Text(
                      'No tasks available, add a new task!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
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
