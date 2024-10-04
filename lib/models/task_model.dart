// task_model.dart

class Task {
  int? id; // Added id property
  String name;
  bool completed;
  DateTime date;

  Task({
    this.id, // Make id optional; it will be set when the task is added to the database
    required this.name,
    required this.completed,
    required this.date,
  });

  // Factory method to create a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?, // Cast id from the map
      name: map['name'] as String,
      completed: map['completed'] as bool,
      date: DateTime.parse(map['date']),
    );
  }

  // Method to convert a Task to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id in the map
      'name': name,
      'completed': completed,
      'date': date.toIso8601String(), // Converting DateTime to String
    };
  }
}
