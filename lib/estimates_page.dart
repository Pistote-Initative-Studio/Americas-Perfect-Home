import 'package:flutter/material.dart';
import 'models.dart';
import 'create_estimate_page.dart';
import 'templates_page.dart';
import 'estimate_detail_page.dart';

class EstimatesPage extends StatelessWidget {
  const EstimatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text('Estimates'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DraftEstimatesPage()),
                );
              },
              child: const Text('View Draft Estimates'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateEstimatePage()),
                );
              },
              child: const Text('Create New Estimate'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TemplatesPage()),
                );
              },
              child: const Text('Manage Templates'),
            ),
          ],
        ),
      ),
    );
  }
}

class DraftEstimatesPage extends StatefulWidget {
  const DraftEstimatesPage({super.key});

  @override
  State<DraftEstimatesPage> createState() => _DraftEstimatesPageState();
}

class _DraftEstimatesPageState extends State<DraftEstimatesPage> {
  void _deleteEstimate(Estimate estimate) {
    setState(() {
      mockEstimates.remove(estimate);
    });
  }

  void _sendToClient(Estimate estimate) {
    setState(() => estimate.status = 'Sent');
  }

  void _approve(Estimate estimate) {
    setState(() => estimate.status = 'Accepted');
  }

  void _reject(Estimate estimate) {
    setState(() => estimate.status = 'Rejected');
  }

  void _convertToJob(Estimate estimate) {
    final newJob = Job(
      id: mockJobs.length + 1,
      name: estimate.title,
      client: estimate.clientName,
      currentCost: 0,
      projectedCost: estimate.amount,
      status: 'Not Started',
      materials: List.from(estimate.materials),
      estimates: [estimate],
    );
    estimate.jobId = newJob.id;
    mockJobs.add(newJob);
    setState(() {});
  }

  void _attachToJob(Estimate estimate) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Attach to Job'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: mockJobs.length,
            itemBuilder: (context, index) {
              final job = mockJobs[index];
              return ListTile(
                title: Text(job.name),
                onTap: () {
                  setState(() {
                    estimate.jobId = job.id;
                    job.estimates.add(estimate);
                    job.materials.addAll(estimate.materials);
                    job.projectedCost += estimate.amount;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drafts = mockEstimates.where((e) => e.jobId == null).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draft Estimates'),
      ),
      body: ListView.builder(
        itemCount: drafts.length,
        itemBuilder: (context, index) {
          final estimate = drafts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text('${estimate.title} (ID: ${estimate.id})'),
              subtitle: Text('${estimate.clientName}\nStatus: ${estimate.status}'),
              isThreeLine: true,
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EstimateDetailPage(estimate: estimate)),
                      ).then((_) => setState(() {}));
                      break;
                    case 'delete':
                      _deleteEstimate(estimate);
                      break;
                    case 'send':
                      _sendToClient(estimate);
                      break;
                    case 'approve':
                      _approve(estimate);
                      break;
                    case 'reject':
                      _reject(estimate);
                      break;
                    case 'convert':
                      _convertToJob(estimate);
                      break;
                    case 'attach':
                      _attachToJob(estimate);
                      break;
                  }
                },
                itemBuilder: (context) {
                  final items = <PopupMenuEntry<String>>[
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ];
                  if (estimate.status == 'Draft' || estimate.status == 'Rejected') {
                    items.add(
                        const PopupMenuItem(value: 'send', child: Text('Send to Client')));
                  }
                  if (estimate.status == 'Sent') {
                    items.add(
                        const PopupMenuItem(value: 'approve', child: Text('Mark Accepted')));
                    items.add(
                        const PopupMenuItem(value: 'reject', child: Text('Mark Rejected')));
                  }
                  if (estimate.status == 'Accepted') {
                    items.add(
                        const PopupMenuItem(value: 'convert', child: Text('Convert to Job')));
                    items.add(const PopupMenuItem(
                        value: 'attach', child: Text('Attach to Job')));
                  }
                  return items;
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
