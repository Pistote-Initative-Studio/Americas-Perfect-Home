import 'models/material_item.dart';
import 'models/estimate.dart';
import 'models/labor_item.dart';
import 'models/employee.dart';
import 'models/task.dart';

export 'models/material_item.dart';
export 'models/estimate.dart';
export 'models/labor_item.dart';
export 'models/employee.dart';
export 'models/task.dart';

/// Represents an estimate template that can be used as a starting point
/// when creating new estimates.
class EstimateTemplate {
  final int id;
  String name;
  List<MaterialItem> materials;
  List<LaborItem> labor;

  EstimateTemplate({
    required this.id,
    required this.name,
    this.materials = const [],
    this.labor = const [],
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
  List<LaborItem> employees;
  List<String> timeLogs;
  List<Estimate> estimates;
  List<Task> tasks;

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
    this.tasks = const [],
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
    status: 'Accepted',
    materialsCost: 12000.0,
    materials: [MaterialItem(name: 'Wood', quantity: 20)],
    jobId: 1,
  )..updateTotal(),
  Estimate(
    id: 201,
    title: 'Initial Estimate',
    clientName: 'Johnson Family',
    status: 'Draft',
    materialsCost: 8000.0,
    materials: [MaterialItem(name: 'Tiles', quantity: 100)],
    jobId: 2,
  )..updateTotal(),
  Estimate(
    id: 301,
    title: 'Cabinet Upgrade',
    clientName: 'Williams',
    materialsCost: 2000.0,
    materials: [MaterialItem(name: 'Cabinet', quantity: 5)],
  )..updateTotal(),
  Estimate(
    id: 302,
    title: 'Lighting Addition',
    clientName: 'Williams',
    materialsCost: 1500.0,
    materials: [MaterialItem(name: 'LED Light', quantity: 20)],
  )..updateTotal(),
];

final List<Job> mockJobs = [
  Job(
    id: 1,
    name: 'Kitchen Remodel',
    client: 'Smith Family',
    currentCost: 5000.0,
    projectedCost: 12000.0,
    status: 'In Progress',
    materials: [MaterialItem(name: 'Wood', quantity: 20)],
    employees: [
      LaborItem(role: 'Alice', estimatedHours: 40.0),
      LaborItem(role: 'Bob', estimatedHours: 35.0),
    ],
    timeLogs: ['Logged 8 hours'],
    estimates: [mockEstimates[0]],
    tasks: [
      Task(
        id: '1',
        title: 'Remove old cabinets',
        notes: 'Take out existing cabinets before installing new ones.',
        tools: ['Hammer'],
        requiredMaterials: [MaterialItem(name: 'Trash Bags', quantity: 5)],
        assignedEmployeeId: '1',
        status: 'In Progress',
      ),
    ],
  ),
  Job(
    id: 2,
    name: 'Bathroom Renovation',
    client: 'Johnson Family',
    currentCost: 3000.0,
    projectedCost: 8000.0,
    status: 'Not Started',
    materials: [MaterialItem(name: 'Tiles', quantity: 100)],
    employees: [LaborItem(role: 'Charlie', estimatedHours: 20.0)],
    timeLogs: [],
    estimates: [mockEstimates[1]],
    tasks: [],
  ),
];

final List<MaterialRequest> materialRequests = [];
