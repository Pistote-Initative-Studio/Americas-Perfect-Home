import 'package:flutter/material.dart';

class EstimatesPage extends StatelessWidget {
  const EstimatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text('Estimates'),
      ),
      body: const Center(
        child: Text('Placeholder for Estimates'),
      ),
    );
  }
}
