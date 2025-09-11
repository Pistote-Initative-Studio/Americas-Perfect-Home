import 'package:flutter/material.dart';
import 'models.dart';

class EmployeeView extends StatefulWidget {
  final String employeeName;
  const EmployeeView({super.key, this.employeeName = 'Bob'});

  @override
  State<EmployeeView> createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  @override
  Widget build(BuildContext context) {
    final id = mockEmployees
        .firstWhere((e) => e.name == widget.employeeName,
            orElse: () => mockEmployees.first)
        .id
        .toString();
    final tasks = <MapEntry<Job, Task>>[];
    for (final job in mockJobs) {
      for (final task in job.tasks.where((t) => t.assignedEmployeeId == id)) {
        tasks.add(MapEntry(job, task));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('${widget.employeeName} Tasks')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: tasks.map((entry) {
          final job = entry.key;
          final task = entry.value;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${task.title} - ${job.name}',
                      style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Status: ${task.status}'),
                  if (task.adminFeedback != null)
                    Text('Feedback: ${task.adminFeedback}'),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              task.beforePhotos.add(
                                  'before_${task.beforePhotos.length + 1}.png');
                              if (task.status == 'Pending') {
                                task.status = 'In Progress';
                              }
                            });
                          },
                          child: const Text('Add Before Photo')),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              task.afterPhotos.add(
                                  'after_${task.afterPhotos.length + 1}.png');
                            });
                          },
                          child: const Text('Add After Photo')),
                    ],
                  ),
                  if (task.status != 'Awaiting Approval' &&
                      task.status != 'Completed')
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          if (task.beforePhotos.isEmpty ||
                              task.afterPhotos.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please add before and after photos')));
                            return;
                          }
                          setState(() {
                            task.status = 'Awaiting Approval';
                          });
                          print(
                              'Admin notified: Task ${task.title} awaiting approval');
                        },
                        child: const Text('Request Complete'),
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
