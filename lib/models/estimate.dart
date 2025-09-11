import 'labor_item.dart';
import 'material_item.dart';

class Estimate {
  final int id;
  String title;
  String clientName;
  String status; // Draft, Sent, Accepted, Rejected
  List<MaterialItem> materials;
  List<LaborItem> labor;
  int? templateId;
  int? jobId; // populated when converted or attached to a job
  double materialsCost;
  double amount; // total cost including labor

  Estimate({
    required this.id,
    required this.title,
    required this.clientName,
    this.status = 'Draft',
    this.materials = const [],
    this.labor = const [],
    this.templateId,
    this.jobId,
    this.materialsCost = 0,
  }) : amount = materialsCost;

  double get laborCost => 0;

  void updateTotal() {
    amount = materialsCost;
  }
}
