import 'package:americas_perfect_home/data/fake_jobs.dart';
import 'package:americas_perfect_home/models/job.dart';
import 'package:americas_perfect_home/screens/admin/create_job_page.dart';
import 'package:americas_perfect_home/screens/admin/job_detail_page.dart';
import 'package:flutter/material.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  String _searchQuery = '';
  JobStatus? _selectedStatus;

  List<Job> get _filteredJobs {
    final String query = _searchQuery.trim().toLowerCase();

    return fakeJobs.where((Job job) {
      final bool matchesQuery;
      if (query.isEmpty) {
        matchesQuery = true;
      } else {
        final String name = job.name.toLowerCase();
        final String customer = job.customerName.toLowerCase();
        final String address = job.address.toLowerCase();
        matchesQuery =
            name.contains(query) || customer.contains(query) || address.contains(query);
      }

      final bool matchesStatus = _selectedStatus == null || job.status == _selectedStatus;

      return matchesQuery && matchesStatus;
    }).toList();
  }

  String _formatDate(DateTime date) =>
      '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';

  void _openCreateJob(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const CreateJobPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<JobStatus?, String> statusFilters = <JobStatus?, String>{
      null: 'All',
      JobStatus.lead: JobStatus.lead.label,
      JobStatus.scheduled: JobStatus.scheduled.label,
      JobStatus.inProgress: JobStatus.inProgress.label,
      JobStatus.completed: JobStatus.completed.label,
      JobStatus.onHold: JobStatus.onHold.label,
    };

    final List<Job> jobs = _filteredJobs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Job',
            onPressed: () => _openCreateJob(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateJob(context),
        icon: const Icon(Icons.add),
        label: const Text('New Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search jobs, customers, or address',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final JobStatus? status = statusFilters.keys.elementAt(index);
                  final String label = statusFilters[status]!;
                  final bool isSelected = _selectedStatus == status;

                  return ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedStatus = selected ? status : null;
                      });
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: statusFilters.length,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: jobs.isEmpty
                  ? const Center(child: Text('No jobs match your search.'))
                  : ListView.builder(
                      itemCount: jobs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Job job = jobs[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => JobDetailPage(job: job),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          job.name,
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(job.customerName),
                                        const SizedBox(height: 4),
                                        Text(job.address),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Chip(
                                        label: Text(job.status.label),
                                        backgroundColor: job.status.color.withOpacity(0.1),
                                        labelStyle: TextStyle(
                                          color: job.status.color,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _formatDate(job.startDate),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
