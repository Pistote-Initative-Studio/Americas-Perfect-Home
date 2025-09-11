class MaterialItem {
  final String name;
  final double estimatedQuantity;
  double actualQuantity;

  MaterialItem({
    required this.name,
    double? estimatedQuantity,
    this.actualQuantity = 0,
    int? quantity,
  }) : estimatedQuantity = estimatedQuantity ?? quantity?.toDouble() ?? 0;

  /// Backwards compatible getter for older code using `quantity`.
  int get quantity => estimatedQuantity.toInt();
}
