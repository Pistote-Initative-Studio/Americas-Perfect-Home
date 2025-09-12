import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'splash_screen.dart';
import 'home_page.dart';
import 'jobs_page.dart';
import 'estimates_page.dart';
import 'employees_page.dart';
import 'inbox_page.dart';
import 'leads_page.dart';
import 'calendar_page.dart';
import 'vehicles_page.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "America's Perfect Home",
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/jobs': (context) => const JobsPage(),
        '/estimates': (context) => const EstimatesPage(),
        '/employees': (context) => const EmployeesPage(),
        '/inbox': (context) => const InboxPage(),
        '/leads': (context) => const LeadsPage(),
        '/calendar': (context) => const CalendarPage(),
        '/vehicles': (context) => const VehiclesPage(),
      },
    );
  }
}
