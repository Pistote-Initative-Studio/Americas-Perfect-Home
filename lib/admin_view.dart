import 'package:flutter/material.dart';
import 'models.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  void _createTask() {
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    final toolsController = TextEditingController();
    final materialsController = TextEditingController();
    String? selectedEmployee;
    Job selectedJob = mockJobs.first;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<Job>(
                value: selectedJob,
                isExpanded: true,
                items: mockJobs
                    .map((j) => DropdownMenuItem(value: j, child: Text(j.name)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => selectedJob = val);
                  }
                },
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              TextField(
                controller: toolsController,
                decoration:
                    const InputDecoration(labelText: 'Tools (comma separated)'),
              ),
              TextField(
                controller: materialsController,
                decoration: const InputDecoration(
                    labelText: 'Materials (name:qty, comma separated)'),
              ),
              DropdownButton<String>(
                value: selectedEmployee,
                isExpanded: true,
                hint: const Text('Assign Employee'),
                items: mockEmployees
                    .map((e) => DropdownMenuItem(
                          value: e.id.toString(),
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => selectedEmployee = val),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final tools = toolsController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              final materials = materialsController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .map((str) {
                final parts = str.split(':');
                final name = parts[0];
                final qty =
                    parts.length > 1 ? double.tryParse(parts[1]) ?? 0 : 0;
                return MaterialItem(name: name, estimatedQuantity: qty);
              }).toList();
              setState(() {
                selectedJob.tasks.add(Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  notes: notesController.text,
                  tools: tools,
                  requiredMaterials: materials,
                  assignedEmployeeId: selectedEmployee,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _approveTask(Job job, Task task) {
    setState(() {
      task.status = 'Completed';
      for (final material in task.requiredMaterials) {
        final existing = job.materials.firstWhere(
          (m) => m.name == material.name,
          orElse: () {
            final item = MaterialItem(name: material.name, quantity: 0);
            job.materials.add(item);
            return item;
          },
        );
        existing.actualQuantity += material.estimatedQuantity;
      }
      final employee = mockEmployees.firstWhere(
          (e) => e.id.toString() == task.assignedEmployeeId,
          orElse: () => mockEmployees.first);
      final labor = job.employees.firstWhere(
          (l) => l.role == employee.name,
          orElse: () => job.employees.first);
      labor.actualHours += 1;
      job.currentCost +=
          employee.hourlyRate +
              task.requiredMaterials
                  .fold(0, (s, m) => s + m.estimatedQuantity * 10);
    });
    print(
        'Customer notified: Task ${task.title} completed with before/after photos.');
  }

  void _rejectTask(Task task) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reject Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Feedback'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                task.status = 'In Progress';
                task.adminFeedback = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  String _employeeName(String? id) {
    if (id == null) return 'Unassigned';
    return mockEmployees
        .firstWhere((e) => e.id.toString() == id,
            orElse: () => mockEmployees.first)
        .name;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<MapEntry<Job, Task>>> grouped = {};
    for (final job in mockJobs) {
      for (final task in job.tasks) {
        grouped
            .putIfAbsent(task.status, () => [])
            .add(MapEntry(job, task));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Tasks')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...entry.value.map((e) => Card(
                    child: ListTile(
                      title: Text('${e.value.title} - ${e.key.name}'),
                      subtitle: Text(
                          'Employee: ${_employeeName(e.value.assignedEmployeeId)}'),
                      trailing: e.value.status == 'Awaiting Approval'
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () => _approveTask(e.key, e.value),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => _rejectTask(e.value),
                                )
                              ],
                            )
                          : null,
                    ),
                  ))
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTask,
        child: const Icon(Icons.add_task),
      ),
    );
  }
}
