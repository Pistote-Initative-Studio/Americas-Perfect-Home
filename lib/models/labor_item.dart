class LaborItem {
  final String role;
  final double estimatedHours;
  double actualHours;
  final String? employeeId;

  LaborItem({
    required this.role,
    double? estimatedHours,
    this.actualHours = 0,
    double? hours,
    this.employeeId,
  }) : estimatedHours = estimatedHours ?? hours ?? 0;

  /// Backwards compatible getter for older code using `hours`.
  double get hours => estimatedHours;
}
