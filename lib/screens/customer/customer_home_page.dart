import 'package:flutter/material.dart';

import '../../models/app_user.dart';

class CustomerHomePage extends StatelessWidget {
  final AppUser appUser;
  const CustomerHomePage({super.key, required this.appUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer – ${appUser.name.isEmpty ? appUser.email : appUser.name}'),
      ),
      body: const Center(
        child: Text('TODO: Customer home'),
      ),
    );
  }
}
