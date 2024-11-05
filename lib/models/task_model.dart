// task_model.dart
import 'package:intl/intl.dart';
class Task {
  int? id; 
  String? apiId;
  String name;
  bool completed;
  DateTime date;
  String? description; 

  Task({
    this.id, 
    this.apiId,
    required this.name,
    required this.completed,
    required this.date,
    this.description,
  });

  //method to create a Task from a Map
static Task fromMap(Map<String, dynamic> map) {
  return Task(
    apiId: map['_id'],
    id: map['id'] as int,  
    name: map['name'] as String,
    completed: map['completed'] == 1,
    date: DateTime.parse(map['date']),
    description: map['description'],
  );
}


  // Method to convert a Task to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'apiId': apiId,
      'name': name,
      'completed': completed,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'description': description,
    };
  }
}
