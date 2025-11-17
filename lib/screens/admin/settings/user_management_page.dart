import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../models/app_user.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs
              .map((doc) => AppUser.fromMap(doc.id, doc.data()))
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(
                  user.name.isNotEmpty ? user.name : user.email,
                ),
                subtitle: Text('${user.email} • ${userRoleToString(user.role)}'),
                trailing: DropdownButton<UserRole>(
                  value: user.role,
                  onChanged: (newRole) {
                    if (newRole == null) return;
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .update({'role': userRoleToString(newRole)});
                  },
                  items: const [
                    DropdownMenuItem(
                      value: UserRole.customer,
                      child: Text('Customer'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.employee,
                      child: Text('Employee'),
                    ),
                    DropdownMenuItem(
                      value: UserRole.admin,
                      child: Text('Admin'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
