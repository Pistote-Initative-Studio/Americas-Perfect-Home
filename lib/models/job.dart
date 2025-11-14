import 'package:flutter/material.dart';

/// Represents the possible states for an admin job.
enum JobStatus { lead, scheduled, inProgress, completed, onHold }

/// Convenience extensions for working with [JobStatus] values.
extension JobStatusX on JobStatus {
  /// A user-friendly label for the status.
  String get label {
    switch (this) {
      case JobStatus.lead:
        return 'Lead';
      case JobStatus.scheduled:
        return 'Scheduled';
      case JobStatus.inProgress:
        return 'In Progress';
      case JobStatus.completed:
        return 'Completed';
      case JobStatus.onHold:
        return 'On Hold';
    }
  }

  /// A color that can be used when displaying the status.
  Color get color {
    switch (this) {
      case JobStatus.lead:
        return Colors.blueGrey;
      case JobStatus.scheduled:
        return Colors.blue;
      case JobStatus.inProgress:
        return Colors.orange;
      case JobStatus.completed:
        return Colors.green;
      case JobStatus.onHold:
        return Colors.redAccent;
    }
  }
}

/// Basic data structure representing a job in the admin flow.
class Job {
  const Job({
    required this.id,
    required this.name,
    required this.customerName,
    required this.address,
    required this.status,
    required this.startDate,
    required this.estimatedBudget,
    required this.totalHours,
    required this.hourlyRate,
    required this.notes,
  });

  final String id;
  final String name;
  final String customerName;
  final String address;
  final JobStatus status;
  final DateTime startDate;
  final double estimatedBudget;
  final double totalHours;
  final double hourlyRate;
  final String notes;
}
