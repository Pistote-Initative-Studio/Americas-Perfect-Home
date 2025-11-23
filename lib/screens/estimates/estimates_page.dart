import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../models/estimate.dart';
import '../estimates/estimate_detail_page.dart';

class EstimatesPage extends StatefulWidget {
  final AppUser appUser;

  const EstimatesPage({super.key, required this.appUser});

  @override
  State<EstimatesPage> createState() => _EstimatesPageState();
}

class _EstimatesPageState extends State<EstimatesPage> {
  String _searchQuery = '';

  bool get _isAdmin => widget.appUser.role == UserRole.admin;
  bool get _isCustomer => widget.appUser.role == UserRole.customer;

  List<Estimate> get _filteredEstimates {
    final List<Estimate> estimates =
        Estimate.fakeEstimatesForDemo(widget.appUser.uid, _isCustomer);
    final String query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return estimates;
    }

    return estimates
        .where(
          (Estimate estimate) => estimate.title.toLowerCase().contains(query) ||
              estimate.customerName.toLowerCase().contains(query),
        )
        .toList();
  }

  String _formatDate(DateTime date) =>
      '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';

  Widget _buildStatusChip(EstimateStatus status) {
    final Map<EstimateStatus, Color> backgroundColors = <EstimateStatus, Color>{
      EstimateStatus.draft: Colors.grey.shade200,
      EstimateStatus.sent: Colors.blue.shade50,
      EstimateStatus.approved: Colors.green.shade50,
      EstimateStatus.declined: Colors.red.shade50,
    };

    final Map<EstimateStatus, Color> textColors = <EstimateStatus, Color>{
      EstimateStatus.draft: Colors.grey.shade800,
      EstimateStatus.sent: Colors.blue.shade800,
      EstimateStatus.approved: Colors.green.shade800,
      EstimateStatus.declined: Colors.red.shade800,
    };

    final Map<EstimateStatus, String> labels = <EstimateStatus, String>{
      EstimateStatus.draft: 'Draft',
      EstimateStatus.sent: 'Sent',
      EstimateStatus.approved: 'Approved',
      EstimateStatus.declined: 'Declined',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColors[status],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        labels[status]!,
        style: TextStyle(
          color: textColors[status],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Estimate> estimates = _filteredEstimates;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estimates'),
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const Scaffold(
                      appBar: AppBar(title: Text('Create Estimate')),
                      body: Center(child: Text('TODO: Estimate creation form')),
                    ),
                  ),
                );
              },
              label: const Text('New Estimate'),
              icon: const Icon(Icons.add),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search estimates or customers',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: estimates.isEmpty
                  ? const Center(child: Text('No estimates found'))
                  : ListView.separated(
                      itemCount: estimates.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final Estimate estimate = estimates[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => EstimateDetailPage(estimate: estimate),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          estimate.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          estimate.customerName,
                                          style: TextStyle(
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: <Widget>[
                                            _buildStatusChip(estimate.status),
                                            const SizedBox(width: 12),
                                            Text(
                                              _formatDate(estimate.createdAt),
                                              style: TextStyle(color: Colors.grey.shade700),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      const Text(
                                        'Total',
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '\$${estimate.total.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
