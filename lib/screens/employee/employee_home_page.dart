import 'package:flutter/material.dart';

import '../../models/app_user.dart';

class EmployeeHomePage extends StatelessWidget {
  final AppUser appUser;
  const EmployeeHomePage({super.key, required this.appUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee – ${appUser.name.isEmpty ? appUser.email : appUser.name}'),
      ),
      body: const Center(
        child: Text('TODO: Employee home'),
      ),
    );
  }
}
