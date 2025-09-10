import 'package:flutter/material.dart';

class MaterialItem {
  String name;
  int quantity;

  MaterialItem({required this.name, required this.quantity});
}

/// Represents an estimate template that can be used as a starting point
/// when creating new estimates.
class EstimateTemplate {
  final int id;
  String name;
  List<MaterialItem> materials;
  List<MaterialItem> labor;

  EstimateTemplate({
    required this.id,
    required this.name,
    this.materials = const [],
    this.labor = const [],
  });
}

/// Model representing an estimate in the system. Estimates can be linked to a
/// job once approved. Until then they remain in draft form.
class Estimate {
  final int id;
  String title;
  String clientName;
  double amount;
  String status; // Draft, Sent, Accepted, Rejected
  List<MaterialItem> materials;
  List<MaterialItem> labor;
  int? templateId;
  int? jobId; // populated when converted or attached to a job

  Estimate({
    required this.id,
    required this.title,
    required this.clientName,
    required this.amount,
    this.status = 'Draft',
    this.materials = const [],
    this.labor = const [],
    this.templateId,
    this.jobId,
  });
}

class Job {
  final int id;
  String name;
  String client;
  double currentCost;
  double projectedCost;
  String status;
  List<MaterialItem> materials;
  List<String> employees;
  List<String> timeLogs;
  List<Estimate> estimates;

  Job({
    required this.id,
    required this.name,
    required this.client,
    required this.currentCost,
    required this.projectedCost,
    required this.status,
    this.materials = const [],
    this.employees = const [],
    this.timeLogs = const [],
    this.estimates = const [],
  });
}

class MaterialRequest {
  final Job job;
  final String materialName;
  final int quantity;
  final String note;
  final String employeeName;

  MaterialRequest({
    required this.job,
    required this.materialName,
    required this.quantity,
    required this.note,
    required this.employeeName,
  });
}

/// Pre-populated templates and estimates used throughout the demo
final List<EstimateTemplate> mockTemplates = [
  EstimateTemplate(
    id: 1,
    name: 'Basic Kitchen',
    materials: [MaterialItem(name: 'Wood', quantity: 10)],
  ),
];

/// Global list of all estimates (drafts and those linked to jobs)
final List<Estimate> mockEstimates = [
  Estimate(
    id: 101,
    title: 'Original Estimate',
    clientName: 'Smith Family',
    amount: 12000,
    status: 'Accepted',
    materials: [MaterialItem(name: 'Wood', quantity: 20)],
    jobId: 1,
  ),
  Estimate(
    id: 201,
    title: 'Initial Estimate',
    clientName: 'Johnson Family',
    amount: 8000,
    status: 'Draft',
    materials: [MaterialItem(name: 'Tiles', quantity: 100)],
    jobId: 2,
  ),
  Estimate(
    id: 301,
    title: 'Cabinet Upgrade',
    clientName: 'Williams',
    amount: 2000,
    materials: [MaterialItem(name: 'Cabinet', quantity: 5)],
  ),
  Estimate(
    id: 302,
    title: 'Lighting Addition',
    clientName: 'Williams',
    amount: 1500,
    materials: [MaterialItem(name: 'LED Light', quantity: 20)],
  ),
];

final List<Job> mockJobs = [
  Job(
    id: 1,
    name: 'Kitchen Remodel',
    client: 'Smith Family',
    currentCost: 5000,
    projectedCost: 12000,
    status: 'In Progress',
    materials: [MaterialItem(name: 'Wood', quantity: 20)],
    employees: ['Alice', 'Bob'],
    timeLogs: ['Logged 8 hours'],
    estimates: [mockEstimates[0]],
  ),
  Job(
    id: 2,
    name: 'Bathroom Renovation',
    client: 'Johnson Family',
    currentCost: 3000,
    projectedCost: 8000,
    status: 'Not Started',
    materials: [MaterialItem(name: 'Tiles', quantity: 100)],
    employees: ['Charlie'],
    timeLogs: [],
    estimates: [mockEstimates[1]],
  ),
];

final List<MaterialRequest> materialRequests = [];

