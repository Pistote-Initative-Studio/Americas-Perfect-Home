import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  final CollectionReference<Map<String, dynamic>> _jobsCollection =
      FirebaseFirestore.instance.collection('jobs');

  Future<void> _showAddJobDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    Future<void> addJob() async {
      final title = titleController.text.trim();
      final description = descriptionController.text.trim();

      if (title.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a job title.')),
          );
        }
        return;
      }

      try {
        await _jobsCollection.add({
          'title': title,
          'description': description,
          'status': 'pending',
          'createdAt': Timestamp.now(),
        });
        if (mounted) {
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add job: ${error.message}')),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add job: $error')),
          );
        }
      }
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Job'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: addJob,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();
  }

  Future<void> _updateJobStatus(
    DocumentSnapshot<Map<String, dynamic>> job,
    String newStatus,
  ) async {
    try {
      await job.reference.update({'status': newStatus});
    } on FirebaseException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update job: ${error.message}')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update job: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _jobsCollection.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          final pendingJobs = docs
              .where(
                (doc) => (doc.data()['status'] as String? ?? 'pending') == 'pending',
              )
              .toList();

          if (pendingJobs.isEmpty) {
            return const Center(
              child: Text('No active jobs yet. Tap the + button to add one.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: pendingJobs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final job = pendingJobs[index];
              final data = job.data();
              final createdAt = data['createdAt'];
              DateTime? createdAtDate;
              if (createdAt is Timestamp) {
                createdAtDate = createdAt.toDate();
              } else if (createdAt is DateTime) {
                createdAtDate = createdAt;
              }

              final createdAtText = createdAtDate != null
                  ? 'Created: ${createdAtDate.toLocal().toString().split('.').first}'
                  : 'Created: Unknown';

              return Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'] as String? ?? 'Untitled Job',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['description'] as String? ?? 'No description provided.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        createdAtText,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => _updateJobStatus(job, 'completed'),
                            child: const Text('Mark Completed'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => _updateJobStatus(job, 'cancelled'),
                            child: const Text('Mark Cancelled'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddJobDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
