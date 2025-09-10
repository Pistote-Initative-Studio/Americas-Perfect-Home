import 'package:flutter/material.dart';
import 'models.dart';
import 'job_detail_page.dart';

class JobsPage extends StatefulWidget {
  final bool isAdmin;
  final String employeeName;

  const JobsPage({super.key, this.isAdmin = true, this.employeeName = 'Employee'});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text('Jobs'),
      ),
      body: ListView.builder(
        itemCount: mockJobs.length,
        itemBuilder: (context, index) {
          final job = mockJobs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(job.name),
              subtitle: Text(
                  '${job.client}\nStatus: ${job.status}\nEstimates: ${job.estimates.length}'),
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JobDetailPage(
                      job: job,
                      isAdmin: widget.isAdmin,
                      employeeName: widget.employeeName,
                    ),
                  ),
                ).then((_) => setState(() {}));
              },
            ),
          );
        },
      ),
    );
  }
}
