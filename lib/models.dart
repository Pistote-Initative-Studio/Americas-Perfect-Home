import 'package:flutter/material.dart';

class MaterialItem {
  String name;
  int quantity;

  MaterialItem({required this.name, required this.quantity});
}

class Estimate {
  final int id;
  String title;
  double amount;
  String status;
  List<MaterialItem> materials;

  Estimate({
    required this.id,
    required this.title,
    required this.amount,
    this.status = 'Pending',
    this.materials = const [],
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
    estimates: [
      Estimate(
        id: 101,
        title: 'Original Estimate',
        amount: 12000,
        status: 'Approved',
        materials: [MaterialItem(name: 'Wood', quantity: 20)],
      ),
    ],
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
    estimates: [
      Estimate(
        id: 201,
        title: 'Initial Estimate',
        amount: 8000,
        status: 'Pending',
        materials: [MaterialItem(name: 'Tiles', quantity: 100)],
      ),
    ],
  ),
];

final List<MaterialRequest> materialRequests = [];

final List<Estimate> availableEstimates = [
  Estimate(
    id: 301,
    title: 'Cabinet Upgrade',
    amount: 2000,
    materials: [MaterialItem(name: 'Cabinet', quantity: 5)],
  ),
  Estimate(
    id: 302,
    title: 'Lighting Addition',
    amount: 1500,
    materials: [MaterialItem(name: 'LED Light', quantity: 20)],
  ),
];

