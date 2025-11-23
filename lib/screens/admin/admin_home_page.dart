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
  void _openJobs(BuildContext context) {
    Navigator.pushNamed(context, '/admin/jobs');
  }

  void _openEstimates(BuildContext context) {
    Navigator.pushNamed(context, '/admin/estimates');
  }

  void _openEmployees(BuildContext context) {
    Navigator.pushNamed(context, '/admin/employees');
  }

  void _openInbox(BuildContext context) {
    Navigator.pushNamed(context, '/admin/inbox');
  }

  void _openLeads(BuildContext context) {
    Navigator.pushNamed(context, '/admin/leads');
  }

  void _openCalendar(BuildContext context) {
    Navigator.pushNamed(context, '/admin/calendar');
  }

  void _openVehicles(BuildContext context) {
    Navigator.pushNamed(context, '/admin/vehicles');
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsPage(appUser: widget.appUser),
      ),
    );
  }

  Widget _buildNavButton(String label, VoidCallback onTap) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
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
            label,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.appUser.role;

    final allNavItems = <_NavItem>[
      _NavItem(
        label: 'Jobs',
        onTap: () => _openJobs(context),
      ),
      _NavItem(
        label: 'Estimates',
        onTap: () => _openEstimates(context),
      ),
      _NavItem(
        label: 'Employees',
        onTap: () => _openEmployees(context),
      ),
      _NavItem(
        label: 'Inbox',
        onTap: () => _openInbox(context),
      ),
      _NavItem(
        label: 'Leads',
        onTap: () => _openLeads(context),
      ),
      _NavItem(
        label: 'Calendar',
        onTap: () => _openCalendar(context),
      ),
      _NavItem(
        label: 'Vehicles',
        onTap: () => _openVehicles(context),
      ),
    ];

    late final List<_NavItem> visibleNavItems;

    switch (role) {
      case UserRole.admin:
        visibleNavItems = allNavItems;
        break;
      case UserRole.employee:
        visibleNavItems = allNavItems
            .where(
              (item) =>
                  item.label == 'Jobs' ||
                  item.label == 'Inbox' ||
                  item.label == 'Calendar' ||
                  item.label == 'Vehicles',
            )
            .toList();
        break;
      case UserRole.customer:
        visibleNavItems = allNavItems
            .where(
              (item) =>
                  item.label == 'Jobs' ||
                  item.label == 'Estimates' ||
                  item.label == 'Inbox' ||
                  item.label == 'Calendar',
            )
            .toList();
        break;
    }

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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final item in visibleNavItems) ...[
                        _buildNavButton(item.label, item.onTap),
                        const SizedBox(height: 16),
                      ],
                      const Spacer(),
                      _buildNavButton('Settings', () => _openSettings(context)),
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

class _NavItem {
  final String label;
  final VoidCallback onTap;

  _NavItem({required this.label, required this.onTap});
}
