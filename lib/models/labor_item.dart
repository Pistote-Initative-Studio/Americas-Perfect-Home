import 'employee.dart';

class LaborItem {
  String role;
  double hours;
  int? employeeId;

  LaborItem({required this.role, required this.hours, this.employeeId});

  Employee? get employee {
    if (employeeId == null) return null;
    try {
      return mockEmployees.firstWhere((e) => e.id == employeeId);
    } catch (_) {
      return null;
    }
  }

  double get rate => employee?.hourlyRate ?? 0;

  double get cost => rate * hours;

  String get employeeName => employee?.name ?? 'Employee TBD';
}
