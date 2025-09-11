import 'package:flutter/material.dart';
import 'models.dart';
import 'material_request_form.dart';

class JobDetailPage extends StatefulWidget {
  final Job job;
  final bool isAdmin;
  final String employeeName;

  const JobDetailPage({
    super.key,
    required this.job,
    this.isAdmin = true,
    this.employeeName = 'Employee',
  });

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addOrEditMaterial({MaterialItem? material, int? index}) {
    final nameController =
        TextEditingController(text: material != null ? material.name : '');
    final quantityController = TextEditingController(
        text: material != null
            ? material.estimatedQuantity.toString()
            : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(material == null ? 'Add Material' : 'Edit Material'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final quantity =
                  double.tryParse(quantityController.text.trim()) ?? 0;
              if (name.isNotEmpty && quantity > 0) {
                setState(() {
                  final item = MaterialItem(
                    name: name,
                    estimatedQuantity: quantity,
                    actualQuantity: material?.actualQuantity ?? 0,
                  );
                  if (material == null) {
                    widget.job.materials.add(item);
                  } else if (index != null) {
                    widget.job.materials[index] = item;
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _requestMaterials() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MaterialRequestForm(
          job: widget.job,
          employeeName: widget.employeeName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Tasks'),
            Tab(text: 'Time Logs'),
            Tab(text: 'Invoices/Payments'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _overviewTab(),
          _tasksTab(),
          _listTab(widget.job.timeLogs),
          _estimatesTab(),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _overviewTab() {
    final job = widget.job;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Client: ${job.client}'),
          Text('Status: ${job.status}'),
          Text('Current Cost: \$${job.currentCost.toStringAsFixed(2)}'),
          Text('Projected Cost: \$${job.projectedCost.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          if (job.materials.isNotEmpty) ...[
            const Text('Materials',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: job.materials
                  .map(
                    (m) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.name,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Estimated: ${m.estimatedQuantity}'),
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  controller: TextEditingController(
                                      text: m.actualQuantity.toString()),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    setState(() {
                                      m.actualQuantity =
                                          double.tryParse(val) ?? 0;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
          if (job.employees.isNotEmpty) ...[
            const Text('Employees',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: job.employees
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.role,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Estimated Hours: ${e.estimatedHours}'),
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  controller: TextEditingController(
                                      text: e.actualHours.toString()),
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    setState(() {
                                      e.actualHours =
                                          double.tryParse(val) ?? 0;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tasksTab() {
    final job = widget.job;
    if (widget.isAdmin) {
      final Map<String, List<Task>> grouped = {};
      for (final task in job.tasks) {
        grouped.putIfAbsent(task.status, () => []).add(task);
      }
      return ListView(
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
              ...entry.value.map((task) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Assigned: ${_employeeName(task.assignedEmployeeId)}'),
                          Text('Tools: ${task.tools.join(', ')}'),
                          Text('Materials: ${task.requiredMaterials.map((m) => m.name).join(', ')}'),
                          if (task.beforePhotos.isNotEmpty)
                            Text('Before Photos: ${task.beforePhotos.length}'),
                          if (task.afterPhotos.isNotEmpty)
                            Text('After Photos: ${task.afterPhotos.length}'),
                          if (task.status == 'Awaiting Approval')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () => _approveTask(task),
                                    child: const Text('Approve')),
                                TextButton(
                                    onPressed: () => _rejectTask(task),
                                    child: const Text('Reject')),
                              ],
                            ),
                        ],
                      ),
                    ),
                  )),
            ],
          );
        }).toList(),
      );
    } else {
      final currentId = mockEmployees
          .firstWhere((e) => e.name == widget.employeeName,
              orElse: () => mockEmployees.first)
          .id
          .toString();
      final tasks =
          job.tasks.where((t) => t.assignedEmployeeId == currentId).toList();
      if (tasks.isEmpty) {
        return const Center(child: Text('No tasks assigned'));
      }
      return ListView(
        padding: const EdgeInsets.all(8),
        children: tasks.map((task) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title,
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
      );
    }
  }

  String _employeeName(String? id) {
    if (id == null) return 'Unassigned';
    return mockEmployees
        .firstWhere((e) => e.id.toString() == id,
            orElse: () => mockEmployees.first)
        .name;
  }

  void _approveTask(Task task) {
    setState(() {
      task.status = 'Completed';
      for (final material in task.requiredMaterials) {
        final existing = widget.job.materials.firstWhere(
          (m) => m.name == material.name,
          orElse: () {
            final item = MaterialItem(name: material.name, quantity: 0);
            widget.job.materials.add(item);
            return item;
          },
        );
        existing.actualQuantity += material.estimatedQuantity;
      }

      final employee = mockEmployees.firstWhere(
          (e) => e.id.toString() == task.assignedEmployeeId,
          orElse: () => mockEmployees.first);
      final labor = widget.job.employees.firstWhere(
          (l) => l.role == employee.name,
          orElse: () => widget.job.employees.first);
      labor.actualHours += 1;
      widget.job.currentCost +=
          employee.hourlyRate +
              task.requiredMaterials
                  .fold(0, (s, m) => s + m.estimatedQuantity * 10);
    });
    print(
        'Customer notified: Task ${task.title} completed with before/after photos.');
  }

  void _rejectTask(Task task) {
    final feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reject Task'),
        content: TextField(
          controller: feedbackController,
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
                task.adminFeedback = feedbackController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _createTask() {
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    final toolsController = TextEditingController();
    final materialsController = TextEditingController();
    String? selectedEmployee;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              StatefulBuilder(builder: (context, setStateSB) {
                return DropdownButton<String>(
                  value: selectedEmployee,
                  hint: const Text('Assign Employee'),
                  isExpanded: true,
                  items: mockEmployees
                      .map((e) => DropdownMenuItem(
                            value: e.id.toString(),
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setStateSB(() => selectedEmployee = val);
                  },
                );
              }),
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
              final id = DateTime.now().millisecondsSinceEpoch.toString();
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
                widget.job.tasks.add(Task(
                  id: id,
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

  Widget _listTab(List<String> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(items[index]),
      ),
    );
  }

  Widget _estimatesTab() {
    final estimates = widget.job.estimates;
    if (estimates.isEmpty) {
      return const Center(child: Text('No estimates attached'));
    }
    return ListView.builder(
      itemCount: estimates.length,
      itemBuilder: (context, index) {
        final estimate = estimates[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListTile(
            title: Text(estimate.title),
            subtitle: Text('Status: ${estimate.status}' +
                (widget.isAdmin
                    ? '\nAmount: \$${estimate.amount.toStringAsFixed(2)}'
                    : '')),
            isThreeLine: widget.isAdmin,
          ),
        );
      },
    );
  }

  FloatingActionButton? _buildFab() {
    if (_tabController.index == 0) {
      return widget.isAdmin
          ? FloatingActionButton(
              onPressed: () => _addOrEditMaterial(),
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: _requestMaterials,
              child: const Icon(Icons.add),
            );
    } else if (_tabController.index == 1 && widget.isAdmin) {
      return FloatingActionButton(
        onPressed: _createTask,
        child: const Icon(Icons.add_task),
      );
    }
    return null;
  }
}
