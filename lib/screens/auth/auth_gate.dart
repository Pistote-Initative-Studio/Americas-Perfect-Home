import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../admin/admin_home_page.dart';
import '../customer/customer_home_page.dart';
import '../employee/employee_home_page.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginPage();
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              FirebaseAuth.instance.signOut();
              return const LoginPage();
            }

            final appUser =
                AppUser.fromMap(user.uid, userSnapshot.data!.data()!);

            switch (appUser.role) {
              case UserRole.admin:
                return const AdminHomePage();
              case UserRole.employee:
                return EmployeeHomePage(appUser: appUser);
              case UserRole.customer:
                return CustomerHomePage(appUser: appUser);
            }
          },
        );
      },
    );
  }
}
