import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:logger/logger.dart';
import 'package:producthive/database/database_helper.dart';
import 'package:producthive/models/task_model.dart';
import 'package:producthive/pages/task_form.dart';
import 'package:producthive/services/task_service.dart';
import 'package:producthive/utils/todo_list.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final TaskService _taskService = TaskService(); 
  final DateFormat formatter = DateFormat.yMMMd();
  final Logger logger = Logger();

  List<Task> toDoList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _taskService.fetchAndStoreTasks();
      List<Task> retrievedTasks = await _dbHelper.getTasks();
      setState(() {
        toDoList = retrievedTasks;
        isLoading = false;
      });
    } catch (e) {
      logger.e("Error retrieving tasks", error: e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveNewTask(
      String taskName, DateTime date, String? description) async {
    Task newTask = Task(
      name: taskName,
      completed: false,
      date: date,
      description: description,
    );

    await _taskService.addTaskToAPI(newTask);
    logger.i("New task added: ${newTask.name}");
    await _loadTasks();
  }

  Future<void> updateTask(
      int index, String updatedTaskName, DateTime date, String? description) async {
    Task updatedTask = toDoList[index];
    updatedTask.name = updatedTaskName;
    updatedTask.date = date;
    updatedTask.description = description;

    try {
      await _taskService.updateTaskInAPI(updatedTask);
      await _loadTasks();
    } catch (e) {
      logger.e('Error updating task', error: e);
    }
  }

  void deleteTask(int index) async {
    if (index < 0 || index >= toDoList.length) {
      logger.w('Index out of range');
      return;
    }

    final Task task = toDoList[index];
    final String? apiId = task.apiId;

    if (apiId != null) {
      try {
        await _loadTasks();
        await _taskService.deleteTaskFromAPI(apiId);
        

        Fluttertoast.showToast(
          msg: "Task deleted successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } catch (e) {
        logger.e('Error deleting task', error:e);
      }
    } else {
      logger.w('Task does not have a valid API ID.');
    }
  }

  Future<void> deleteAllTasks() async {
    try {
      await _taskService.deleteAllTasksFromAPI();
      await _loadTasks();

      Fluttertoast.showToast(
        msg: "All tasks deleted successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      logger.e('Error deleting all tasks',error:e);
    }
  }

  void checkBoxChanged(int index) async {
    setState(() {
      toDoList[index].completed = !toDoList[index].completed;
    });

    try {
      await _taskService.updateTaskInAPI(toDoList[index]);
      await _dbHelper.updateTask(toDoList[index]);
      await _loadTasks();
    } catch (e) {
      logger.e('Error updating task completion status', error:e);
    }
  }

  Future<void> deleteConfirmDialog(BuildContext context, String action) async {
    if (toDoList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No tasks to delete.')),
      );
      return;
    }
    final bool isClearAll = (action == "all");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            SizedBox(width: 8),
            Text('Delete All Tasks?'),
          ],
        ),
        content: const Text('Are you sure you want to delete all tasks?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (isClearAll) {
                deleteAllTasks();
              }

              Navigator.of(ctx).pop();
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

  Widget buildShimmer() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
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
      body: RefreshIndicator(
        onRefresh: _loadTasks,
        child: isLoading
            ? buildShimmer()
            : toDoList.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1, bottom: 130),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/taskloading.json',
                            width: MediaQuery.of(context).size.width,
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
                    padding: EdgeInsets.zero,
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
                                isEditing: true,
                                onSaveTask: (updatedTaskName, updatedDate, description) =>
                                    updateTask(index, updatedTaskName, updatedDate, description),
                                initialTaskName: toDoList[index].name,
                                initialDate: toDoList[index].date,
                                initialDescription: toDoList[index].description,
                              ),
                            ),
                          );
                          _showToastIfTaskSaved(result);
                        },
                        taskDate: formatter.format(toDoList[index].date),
                        taskDescription: toDoList[index].description,
                      );
                    },
                  ),
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
                isEditing: false,
                onSaveTask: (newTaskName, newDate, description) =>
                    saveNewTask(newTaskName, newDate, description),
              ),
            ),
          );
          _showToastIfTaskSaved(result);
        },
      ),
    );
  }
}
