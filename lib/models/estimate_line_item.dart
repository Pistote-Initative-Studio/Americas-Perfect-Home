enum EstimateLineCategory { labor, materials, other }

class EstimateLineItem {
  final String id;
  final String description;
  final double quantity;
  final String unit; // e.g. 'hrs', 'sq ft', 'lot'
  final double unitPrice;
  final EstimateLineCategory category;

  double get lineTotal => quantity * unitPrice;

  const EstimateLineItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.category,
  });
}
