class Employee {
  final int id;
  final String name;
  final double hourlyRate;

  Employee({required this.id, required this.name, required this.hourlyRate});
}

final List<Employee> mockEmployees = [
  Employee(id: 1, name: 'Bob', hourlyRate: 50),
  Employee(id: 2, name: 'Susan', hourlyRate: 65),
];
