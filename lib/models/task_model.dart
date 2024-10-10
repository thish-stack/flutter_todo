// task_model.dart
import 'package:intl/intl.dart';
class Task {
  int? id; 
  String name;
  bool completed;
  DateTime date;

  Task({
    this.id, 
    required this.name,
    required this.completed,
    required this.date,
  });

  //method to create a Task from a Map
static Task fromMap(Map<String, dynamic> map) {
  return Task(
    id: map['id'] as int,  
    name: map['name'] as String,
    completed: map['completed'] == 1,
    date: DateTime.parse(map['date']),
  );
}


  // Method to convert a Task to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'name': name,
      'completed': completed,
      'date': DateFormat('yyyy-MM-dd').format(date),
    };
  }
}
