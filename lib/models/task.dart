import "material_item.dart";
class Task {
  final String id;
  String title;
  String notes;
  List<String> beforePhotos;
  List<String> afterPhotos;
  List<String> tools;
  List<MaterialItem> requiredMaterials;
  String? assignedEmployeeId;
  String status; // Pending, In Progress, Awaiting Approval, Completed
  String? adminFeedback;

  Task({
    required this.id,
    required this.title,
    required this.notes,
    this.beforePhotos = const [],
    this.afterPhotos = const [],
    this.tools = const [],
    this.requiredMaterials = const [],
    this.assignedEmployeeId,
    this.status = 'Pending',
    this.adminFeedback,
  });
}
