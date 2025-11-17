import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart'; // after FlutterFire CLI setup
import 'screens/admin/admin_home_page.dart';
import 'screens/admin/calendar_page.dart';
import 'screens/admin/employees_page.dart';
import 'screens/admin/estimates_page.dart';
import 'screens/admin/inbox_page.dart';
import 'screens/admin/jobs_page.dart';
import 'screens/admin/leads_page.dart';
import 'screens/admin/vehicles_page.dart';
import 'screens/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'America\'s Perfect Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const AuthGate(),
      routes: {
        '/admin/jobs': (context) => const JobsPage(),
        '/admin/estimates': (context) => const EstimatesPage(),
        '/admin/employees': (context) => const EmployeesPage(),
        '/admin/inbox': (context) => const InboxPage(),
        '/admin/leads': (context) => const LeadsPage(),
        '/admin/calendar': (context) => const CalendarPage(),
        '/admin/vehicles': (context) => const VehiclesPage(),
      },
    );
  }
}
