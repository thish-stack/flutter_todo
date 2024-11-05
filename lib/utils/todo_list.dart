import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.editFunction,
    required this.taskDate,
    required this.taskDescription,
  });

  final String taskName;
  final bool taskCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext)? editFunction;
  final String taskDate;
  final String? taskDescription; 

  void _showTaskDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Name:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                taskName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Task Date:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                taskDate,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Task Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                taskDescription ?? 'No description provided',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          _showTaskDetailsBottomSheet(context);
        },
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Row(children: [
                        Icon(
                          Icons.warning,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text('Delete Task ?'),
                      ]),
                      content: const Text(
                          'Are you sure you want to delete this task?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteFunction!(context);
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icons.delete,
                foregroundColor: Colors.red,
                borderRadius: BorderRadius.circular(15),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: taskCompleted
                  ? const LinearGradient(
                      colors: [
                       

                        Color.fromARGB(255, 245, 111, 173), 
                        Color.fromARGB(255, 244, 136, 188),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ) 
                  : const LinearGradient(
                      colors: [
                        Color(0xFFE2267F),
                        Color(0xFFE94E97),
                        Color(0xFFEF6DAB),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: taskCompleted
                  ? [
                      BoxShadow(
                        color: Colors.pink.withOpacity(1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ]
                  : [
                      BoxShadow(
                        color: const Color.fromARGB(255, 232, 118, 156)
                            .withOpacity(1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Checkbox(
                //   value: taskCompleted,
                //   onChanged: onChanged,
                //   checkColor: Colors.black,
                //   activeColor: Colors.white,
                //   side: const BorderSide(
                //     color: Colors.white,
                //   ),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        taskName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,

                          // decoration: taskCompleted
                          //     ? TextDecoration.lineThrough
                          //     : TextDecoration.none,
                          decorationColor: Colors.white,
                          decorationThickness: 2,
                        ),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      taskDate,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        editFunction!(context);
                      },
                    ),
                    Checkbox(
                      value: taskCompleted,
                      onChanged: onChanged,
                      checkColor: Colors.black,
                      activeColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
