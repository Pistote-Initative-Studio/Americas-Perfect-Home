import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _navButton(context, 'Jobs', '/jobs'),
                _navButton(context, 'Estimates', '/estimates'),
                _navButton(context, 'Employees', '/employees'),
                _navButton(context, 'Inbox', '/inbox'),
                _navButton(context, 'Leads', '/leads'),
                _navButton(context, 'Calendar', '/calendar'),
                _navButton(context, 'Vehicles', '/vehicles'),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[300],
              child: const Center(
                child: Text('Image Area'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        child: Text(title),
      ),
    );
  }
}
