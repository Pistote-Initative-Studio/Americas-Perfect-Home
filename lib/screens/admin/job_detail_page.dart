import 'package:americas_perfect_home/models/job.dart';
import 'package:flutter/material.dart';

class JobDetailPage extends StatefulWidget {
  const JobDetailPage({required this.job, super.key});

  final Job job;

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  late List<JobTask> _tasks;
  late List<EmployeeAssignment> _activeEmployees;
  late List<EmployeeAssignment> _pastEmployees;
  late List<MaterialItem> _materials;

  @override
  void initState() {
    super.initState();
    _tasks = widget.job.tasks
        .map(
          (JobTask task) => JobTask(
            id: task.id,
            title: task.title,
            assignedEmployeeId: task.assignedEmployeeId,
            status: task.status,
            hasBeforePhoto: task.hasBeforePhoto,
            hasAfterPhoto: task.hasAfterPhoto,
          ),
        )
        .toList();
    _activeEmployees = widget.job.activeEmployees
        .map(
          (EmployeeAssignment assignment) => EmployeeAssignment(
            id: assignment.id,
            name: assignment.name,
            hourlyRate: assignment.hourlyRate,
            hoursWorked: assignment.hoursWorked,
          ),
        )
        .toList();
    _pastEmployees = widget.job.pastEmployees
        .map(
          (EmployeeAssignment assignment) => EmployeeAssignment(
            id: assignment.id,
            name: assignment.name,
            hourlyRate: assignment.hourlyRate,
            hoursWorked: assignment.hoursWorked,
          ),
        )
        .toList();
    _materials = widget.job.materials
        .map(
          (MaterialItem item) => MaterialItem(
            name: item.name,
            quantity: item.quantity,
            quotedCost: item.quotedCost,
            actualCost: item.actualCost,
          ),
        )
        .toList();
  }

  String _formatDate(DateTime date) =>
      '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';

  String _formatCurrency(double value) => '${value.toStringAsFixed(2)} USD';

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _attachBeforePhoto(JobTask task) {
    setState(() {
      task.hasBeforePhoto = true;
    });
  }

  void _attachAfterPhoto(JobTask task) {
    setState(() {
      task.hasAfterPhoto = true;
    });
  }

  void _startTask(JobTask task) {
    if (!task.hasBeforePhoto) {
      _showSnackBar('Add a before photo before starting this task.');
      return;
    }
    if (task.status != JobTaskStatus.notStarted) {
      _showSnackBar('Only tasks that have not started can be moved to In Progress.');
      return;
    }
    setState(() {
      task.status = JobTaskStatus.inProgress;
    });
  }

  void _markTaskInReview(JobTask task) {
    if (task.status != JobTaskStatus.inProgress) {
      _showSnackBar('Only tasks In Progress can be marked as done by employees.');
      return;
    }
    if (!task.hasAfterPhoto) {
      _showSnackBar('Add an after photo before marking this task done.');
      return;
    }
    setState(() {
      task.status = JobTaskStatus.inReview;
    });
  }

  void _approveTask(JobTask task) {
    if (task.status != JobTaskStatus.inReview) {
      _showSnackBar('Only tasks in review can be approved by an admin.');
      return;
    }
    setState(() {
      task.status = JobTaskStatus.complete;
    });
  }

  Future<void> _assignEmployeeDialog() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController rateController = TextEditingController();
    final TextEditingController hoursController = TextEditingController(text: '0');

    final bool? shouldAdd = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Assign Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: rateController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Hourly Rate'),
              ),
              TextField(
                controller: hoursController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Initial Hours'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    rateController.text.trim().isEmpty) {
                  _showSnackBar('Please provide a name and hourly rate.');
                  return;
                }
                Navigator.of(context).pop(true);
              },
              child: const Text('Assign'),
            ),
          ],
        );
      },
    );

    if (shouldAdd != true) {
      return;
    }

    final String name = nameController.text.trim();
    final double? rate = double.tryParse(rateController.text.trim());
    final double hours = double.tryParse(hoursController.text.trim()) ?? 0;

    if (rate == null) {
      _showSnackBar('Hourly rate must be a valid number.');
      return;
    }

    setState(() {
      _activeEmployees.add(
        EmployeeAssignment(
          id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          hourlyRate: rate,
          hoursWorked: hours,
        ),
      );
    });
  }

  void _removeEmployee(EmployeeAssignment assignment) {
    setState(() {
      _activeEmployees.remove(assignment);
      _pastEmployees.add(assignment);
    });
  }

  double get _totalActiveHours => _activeEmployees.fold<double>(
        0,
        (double sum, EmployeeAssignment assignment) =>
            sum + assignment.hoursWorked,
      );

  double get _totalPastHours => _pastEmployees.fold<double>(
        0,
        (double sum, EmployeeAssignment assignment) =>
            sum + assignment.hoursWorked,
      );

  double get _totalQuotedMaterials => _materials.fold<double>(
        0,
        (double sum, MaterialItem item) => sum + item.quotedCost,
      );

  double get _totalActualMaterials => _materials.fold<double>(
        0,
        (double sum, MaterialItem item) => sum + item.actualCost,
      );

  @override
  Widget build(BuildContext context) {
    final Job job = widget.job;
    final double totalHours = _totalActiveHours + _totalPastHours;

    return Scaffold(
      appBar: AppBar(
        title: Text(job.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _SectionCard(
            title: 'Overview',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Customer: ${job.customerName}'),
                const SizedBox(height: 8),
                Text('Address: ${job.address}'),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Chip(
                      label: Text(job.status.label),
                      backgroundColor: job.status.color.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: job.status.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Start Date: ${_formatDate(job.startDate)}'),
                  ],
                ),
              ],
            ),
          ),
          _SectionCard(
            title: 'Tasks',
            child: Column(
              children: _tasks.isEmpty
                  ? <Widget>[
                      const Text('No tasks have been added for this job yet.'),
                    ]
                  : _tasks
                      .map((JobTask task) => _TaskTile(
                            task: task,
                            onAttachBeforePhoto: () => _attachBeforePhoto(task),
                            onAttachAfterPhoto: () => _attachAfterPhoto(task),
                            onStart: () => _startTask(task),
                            onMarkDone: () => _markTaskInReview(task),
                            onApprove: () => _approveTask(task),
                          ))
                      .toList(),
            ),
          ),
          const _SectionCard(
            title: 'Scope / Notes',
            child: Text('TODO: add scope and notes details.'),
          ),
          _SectionCard(
            title: 'Employees',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Active Employees',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextButton(
                      onPressed: _assignEmployeeDialog,
                      child: const Text('Assign Employee'),
                    ),
                  ],
                ),
                if (_activeEmployees.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('No active employees assigned.'),
                  )
                else
                  Column(
                    children: _activeEmployees
                        .map(
                          (EmployeeAssignment employee) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(employee.name),
                            subtitle: Text(
                              '${employee.hoursWorked.toStringAsFixed(1)} hrs @ ${_formatCurrency(employee.hourlyRate)}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              tooltip: 'Remove',
                              onPressed: () => _removeEmployee(employee),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 16),
                Text(
                  'Past Employees',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (_pastEmployees.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('No past employees recorded.'),
                  )
                else
                  Column(
                    children: _pastEmployees
                        .map(
                          (EmployeeAssignment employee) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(employee.name),
                            subtitle: Text(
                              '${employee.hoursWorked.toStringAsFixed(1)} hrs @ ${_formatCurrency(employee.hourlyRate)}',
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
          _SectionCard(
            title: 'Materials',
            child: Column(
              children: <Widget>[
                Column(
                  children: _materials
                      .map(
                        (MaterialItem item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.name),
                          subtitle: Text('Qty: ${item.quantity}'),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Quoted: ${_formatCurrency(item.quotedCost)}'),
                              Text('Actual: ${_formatCurrency(item.actualCost)}'),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Totals — Quoted: ${_formatCurrency(_totalQuotedMaterials)}, Actual: ${_formatCurrency(_totalActualMaterials)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
          _SectionCard(
            title: 'Financials',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Estimated Budget: ${_formatCurrency(job.estimatedBudget)}'),
                const SizedBox(height: 8),
                Text('Total Hours: ${totalHours.toStringAsFixed(1)} hrs'),
                const SizedBox(height: 8),
                Text('Hourly Rate (Estimate): ${_formatCurrency(job.hourlyRate)}'),
                const SizedBox(height: 8),
                Text('Estimated Labor Cost: ${_formatCurrency(job.hourlyRate * totalHours)}'),
                const SizedBox(height: 12),
                Text(
                  'Employee Breakdown',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                ..._activeEmployees.map(
                  (EmployeeAssignment employee) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '${employee.name} (active) – ${employee.hoursWorked.toStringAsFixed(1)} hrs @ ${_formatCurrency(employee.hourlyRate)}',
                    ),
                  ),
                ),
                ..._pastEmployees.map(
                  (EmployeeAssignment employee) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '${employee.name} (past) – ${employee.hoursWorked.toStringAsFixed(1)} hrs @ ${_formatCurrency(employee.hourlyRate)}',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Materials Totals',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'Quoted: ${_formatCurrency(_totalQuotedMaterials)} / Actual: ${_formatCurrency(_totalActualMaterials)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.onAttachBeforePhoto,
    required this.onAttachAfterPhoto,
    required this.onStart,
    required this.onMarkDone,
    required this.onApprove,
  });

  final JobTask task;
  final VoidCallback onAttachBeforePhoto;
  final VoidCallback onAttachAfterPhoto;
  final VoidCallback onStart;
  final VoidCallback onMarkDone;
  final VoidCallback onApprove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  label: Text(task.status.label),
                  backgroundColor: task.status.color.withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: task.status.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Icon(
                  task.hasBeforePhoto ? Icons.check_circle : Icons.camera_alt_outlined,
                  color: task.hasBeforePhoto ? Colors.green : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 6),
                const Text('Before Photo'),
                const SizedBox(width: 16),
                Icon(
                  task.hasAfterPhoto ? Icons.check_circle : Icons.camera_alt_outlined,
                  color: task.hasAfterPhoto ? Colors.green : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 6),
                const Text('After Photo'),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: <Widget>[
                OutlinedButton(
                  onPressed: onAttachBeforePhoto,
                  child: const Text('Attach Before Photo'),
                ),
                OutlinedButton(
                  onPressed: onAttachAfterPhoto,
                  child: const Text('Attach After Photo'),
                ),
                ElevatedButton(
                  onPressed: onStart,
                  child: const Text('Start Task'),
                ),
                ElevatedButton(
                  onPressed: onMarkDone,
                  child: const Text('Mark Done (Employee)'),
                ),
                ElevatedButton(
                  onPressed: onApprove,
                  child: const Text('Approve (Admin)'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
