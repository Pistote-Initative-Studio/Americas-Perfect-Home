import 'package:americas_perfect_home/models/job.dart';
import 'package:flutter/material.dart';

class JobTasksPage extends StatefulWidget {
  const JobTasksPage({super.key, required this.job});

  final Job job;

  @override
  State<JobTasksPage> createState() => _JobTasksPageState();
}

class _JobTasksPageState extends State<JobTasksPage> {
  late List<JobTask> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = widget.job.tasks;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks – ${widget.job.name}'),
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text('No tasks have been added for this job yet.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              itemBuilder: (BuildContext context, int index) {
                final JobTask task = _tasks[index];
                return _TaskCard(
                  task: task,
                  onAttachBeforePhoto: () => _attachBeforePhoto(task),
                  onAttachAfterPhoto: () => _attachAfterPhoto(task),
                  onStart: () => _startTask(task),
                  onMarkDone: () => _markTaskInReview(task),
                  onApprove: () => _approveTask(task),
                );
              },
            ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
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
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Row(
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
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                task.hasBeforePhoto
                    ? Icons.check_circle
                    : Icons.camera_alt_outlined,
                color: task.hasBeforePhoto ? Colors.green : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 6),
              const Text('Before Photo'),
              const SizedBox(width: 16),
              Icon(
                task.hasAfterPhoto
                    ? Icons.check_circle
                    : Icons.camera_alt_outlined,
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
            runSpacing: 8,
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
    );
  }
}
