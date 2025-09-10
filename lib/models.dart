import 'package:flutter/material.dart';

class MaterialItem {
  String name;
  int quantity;

  MaterialItem({required this.name, required this.quantity});
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
  List<String> invoices;

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
    this.invoices = const [],
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
    invoices: ['Invoice #1'],
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
    invoices: [],
  ),
];

final List<MaterialRequest> materialRequests = [];

