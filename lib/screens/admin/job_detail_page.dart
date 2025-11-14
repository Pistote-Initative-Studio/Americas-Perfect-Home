import 'package:americas_perfect_home/models/job.dart';
import 'package:americas_perfect_home/screens/admin/job_tasks_page.dart';
import 'package:flutter/material.dart';

class JobDetailPage extends StatefulWidget {
  const JobDetailPage({required this.job, super.key});

  final Job job;

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  late List<EmployeeAssignment> _activeEmployees;
  late List<EmployeeAssignment> _pastEmployees;
  late List<MaterialItem> _materials;

  @override
  void initState() {
    super.initState();
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
          _buildTasksSummaryCard(job),
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

  Widget _buildTasksSummaryCard(Job job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => JobTasksPage(job: job),
            ),
          );
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text(
                    'Tasks',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 12),
              if (job.tasks.isEmpty)
                const Text('No tasks have been added for this job yet.')
              else
                Column(
                  children: job.tasks
                      .map(
                        (JobTask task) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                              ),
                              _buildTaskStatusIndicator(task.status),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskStatusIndicator(JobTaskStatus status) {
    IconData icon;
    Color color;
    switch (status) {
      case JobTaskStatus.complete:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case JobTaskStatus.inReview:
        icon = Icons.hourglass_bottom;
        color = Colors.orange;
        break;
      case JobTaskStatus.inProgress:
        icon = Icons.autorenew;
        color = Colors.blue;
        break;
      case JobTaskStatus.notStarted:
        icon = Icons.radio_button_unchecked;
        color = Colors.grey;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(
          status.label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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

