import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // after FlutterFire CLI setup

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
      title: 'Admin Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const AdminNavigationPage(),
    );
  }
}

class AdminNavigationPage extends StatelessWidget {
  const AdminNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationItems = const <String>[
      'Jobs',
      'Estimates',
      'Employees',
      'Inbox',
      'Leads',
      'Calendar',
      'Vehicles',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                color: const Color(0xFF344E5C),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
                  child: ListView.separated(
                    itemCount: navigationItems.length,
                    itemBuilder: (context, index) {
                      final item = navigationItems[index];
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blueGrey.shade800,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              minimumSize: const Size(160, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: const StadiumBorder(),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Text(
                              item,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                color: const Color(0xFFE6E7EB),
                child: const Center(
                  child: Text(
                    'Image Area',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5B5B5B),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
