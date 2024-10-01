import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TaskForm extends StatefulWidget {
  final Function(String, DateTime)
      onSaveTask; 
  final String? initialTaskName; 
  final DateTime? initialDate; 

  const TaskForm({
    super.key,
    required this.onSaveTask,
    this.initialTaskName,
    this.initialDate,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  late TextEditingController nameController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialTaskName ?? '');   
    _selectedDate = widget.initialDate;
  }

  // Date picker
  void _presentDatePicker() async {
    
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _showInvalidInputDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid Input'),
        content: const Text(
          'Please make sure a valid task name and date are entered.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: const Color(0xFFE94E97),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Task Name Input
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your task',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.pink.withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.task),
              ),
            ),
            const SizedBox(height: 10),

            // Date Picker Row
            GestureDetector(
              onTap: _presentDatePicker,
              child: AbsorbPointer(
               
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.pink.withOpacity(0.1),
                    prefixIcon: const Icon(Icons.calendar_today),
                    hintText: _selectedDate == null
                        ? 'Select date'
                        : 'Date: ${formatter.format(_selectedDate!)}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Save Button
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||  _selectedDate == null) {
                  _showInvalidInputDialog();
                  return;
                } 

               
                widget.onSaveTask(nameController.text, _selectedDate!);

               Navigator.pop(context, 'Task saved successfully!');
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 90, vertical: 12),
                backgroundColor: const Color(0xFFE94E97),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
