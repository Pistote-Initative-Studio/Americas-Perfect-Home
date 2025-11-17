import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../settings/settings_page.dart';

class AdminHomePage extends StatefulWidget {
  final AppUser appUser;

  const AdminHomePage({super.key, required this.appUser});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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

    final routeByItem = <String, String>{
      'Jobs': '/admin/jobs',
      'Estimates': '/admin/estimates',
      'Employees': '/admin/employees',
      'Inbox': '/admin/inbox',
      'Leads': '/admin/leads',
      'Calendar': '/admin/calendar',
      'Vehicles': '/admin/vehicles',
    };

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
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: navigationItems.length,
                          itemBuilder: (context, index) {
                            final item = navigationItems[index];
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final route = routeByItem[item];
                                    if (route != null) {
                                      Navigator.pushNamed(context, route);
                                    }
                                  },
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
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SettingsPage(appUser: widget.appUser),
                                ),
                              );
                            },
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
                            child: const Text(
                              'Settings',
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                        ),
                      ),
                    ],
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
