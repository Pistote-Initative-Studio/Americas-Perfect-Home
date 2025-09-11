class LaborItem {
  final String role;
  final double hours;
  final String? employeeId;

  LaborItem({
    required this.role,
    required this.hours,
    this.employeeId,
  });
}
