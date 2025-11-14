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

/// Represents an employee assignment for a job.
class EmployeeAssignment {
  EmployeeAssignment({
    required this.id,
    required this.name,
    required this.hourlyRate,
    required this.hoursWorked,
  });

  final String id;
  final String name;
  final double hourlyRate;
  double hoursWorked;
}

/// Represents a material item included in a job estimate.
class MaterialItem {
  MaterialItem({
    required this.name,
    required this.quantity,
    required this.quotedCost,
    required this.actualCost,
  });

  final String name;
  final int quantity;
  final double quotedCost;
  double actualCost;
}

/// Statuses for individual job tasks.
enum JobTaskStatus { notStarted, inProgress, inReview, complete }

extension JobTaskStatusX on JobTaskStatus {
  String get label {
    switch (this) {
      case JobTaskStatus.notStarted:
        return 'Not Started';
      case JobTaskStatus.inProgress:
        return 'In Progress';
      case JobTaskStatus.inReview:
        return 'In Review';
      case JobTaskStatus.complete:
        return 'Complete';
    }
  }

  Color get color {
    switch (this) {
      case JobTaskStatus.notStarted:
        return Colors.grey;
      case JobTaskStatus.inProgress:
        return Colors.orange;
      case JobTaskStatus.inReview:
        return Colors.blue;
      case JobTaskStatus.complete:
        return Colors.green;
    }
  }
}

/// Represents a job task with simple workflow requirements.
class JobTask {
  JobTask({
    required this.id,
    required this.title,
    this.assignedEmployeeId,
    this.status = JobTaskStatus.notStarted,
    this.hasBeforePhoto = false,
    this.hasAfterPhoto = false,
  });

  final String id;
  final String title;
  final String? assignedEmployeeId;
  JobTaskStatus status;
  bool hasBeforePhoto;
  bool hasAfterPhoto;
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
    this.activeEmployees = const <EmployeeAssignment>[],
    this.pastEmployees = const <EmployeeAssignment>[],
    this.materials = const <MaterialItem>[],
    this.tasks = const <JobTask>[],
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
  final List<EmployeeAssignment> activeEmployees;
  final List<EmployeeAssignment> pastEmployees;
  final List<MaterialItem> materials;
  final List<JobTask> tasks;
}
