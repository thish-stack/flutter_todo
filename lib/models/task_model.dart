// task_model.dart

class Task {
  String name;
  bool completed;
  DateTime date;

  Task({
    required this.name,
    required this.completed,
    required this.date,
  });

  // Factory method to create a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      name: map['name'] as String,
      completed: map['completed'] as bool,
      date: DateTime.parse(map['date']),
    );
  }

  // Method to convert a Task to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'completed': completed,
      'date': date.toIso8601String(), // Converting DateTime to String
    };
  }
}
