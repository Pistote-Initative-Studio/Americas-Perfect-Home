import 'package:flutter/material.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text('Leads'),
      ),
      body: const Center(
        child: Text('Placeholder for Leads'),
      ),
    );
  }
}
