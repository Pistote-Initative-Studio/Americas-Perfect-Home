import 'package:flutter/material.dart';

void main() {
  runApp(const ConstructionManagementApp());
}

class ConstructionManagementApp extends StatelessWidget {
  const ConstructionManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Construction Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F6F8F)),
        scaffoldBackgroundColor: const Color(0xFFF3F4F8),
        useMaterial3: true,
      ),
      home: const NavigationPage(),
    );
  }
}

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    const buttonLabels = <String>[
      'Jobs',
      'Estimates',
      'Employees',
      'Inbox',
      'Leads',
      'Calendar',
      'Vehicles',
    ];

    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: const Color(0xFF2E3A59),
      backgroundColor: const Color(0xFFE9EDF5),
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 140,
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F5061),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Navigation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (var i = 0; i < buttonLabels.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: i == buttonLabels.length - 1 ? 0 : 12,
                        ),
                        child: ElevatedButton(
                          style: buttonStyle,
                          onPressed: () {},
                          child: Text(buttonLabels[i]),
                        ),
                      ),
                    const Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: const Color(0xFFF3F4F8),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
