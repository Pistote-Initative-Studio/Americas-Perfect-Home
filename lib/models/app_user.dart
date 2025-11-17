import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, employee, customer }

UserRole userRoleFromString(String value) {
  switch (value) {
    case 'admin':
      return UserRole.admin;
    case 'employee':
      return UserRole.employee;
    default:
      return UserRole.customer;
  }
}

String userRoleToString(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'admin';
    case UserRole.employee:
      return 'employee';
    case UserRole.customer:
      return 'customer';
  }
}

class AppUser {
  final String uid;
  final String name;
  final String email;
  final UserRole role;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: userRoleFromString(data['role'] as String? ?? 'customer'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': userRoleToString(role),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
