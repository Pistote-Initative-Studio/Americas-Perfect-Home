import 'package:americas_perfect_home/models/job.dart';
import 'package:flutter/material.dart';

class JobDetailPage extends StatelessWidget {
  const JobDetailPage({required this.job, super.key});

  final Job job;

  String _formatDate(DateTime date) =>
      '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';

  String _formatCurrency(double value) => '${value.toStringAsFixed(2)} USD';

  @override
  Widget build(BuildContext context) {
    final double laborCost = job.totalHours * job.hourlyRate;

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
          const _SectionCard(
            title: 'Scope / Notes',
            child: Text('TODO: add scope and notes details.'),
          ),
          const _SectionCard(
            title: 'Schedule & Tasks',
            child: Text('TODO: show schedule and task breakdown.'),
          ),
          const _SectionCard(
            title: 'Files & Photos',
            child: Text('TODO: manage files and photos.'),
          ),
          const _SectionCard(
            title: 'Activity / Communication',
            child: Text('TODO: log activity and communication history.'),
          ),
          _SectionCard(
            title: 'Financials',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Estimated Budget: ${_formatCurrency(job.estimatedBudget)}'),
                const SizedBox(height: 8),
                Text('Total Hours: ${job.totalHours.toStringAsFixed(1)} hrs'),
                const SizedBox(height: 8),
                Text('Hourly Rate: ${_formatCurrency(job.hourlyRate)}'),
                const SizedBox(height: 8),
                Text('Estimated Labor Cost: ${_formatCurrency(laborCost)}'),
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
