import 'package:flutter/material.dart';

import '../../models/estimate.dart';
import '../../models/estimate_line_item.dart';

class EstimateDetailPage extends StatelessWidget {
  final Estimate estimate;

  const EstimateDetailPage({super.key, required this.estimate});

  String _formatDate(DateTime date) =>
      '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';

  String _categoryLabel(EstimateLineCategory category) {
    switch (category) {
      case EstimateLineCategory.labor:
        return 'Labor';
      case EstimateLineCategory.materials:
        return 'Materials';
      case EstimateLineCategory.other:
        return 'Other';
    }
  }

  Color _statusColor(EstimateStatus status) {
    switch (status) {
      case EstimateStatus.draft:
        return Colors.grey.shade800;
      case EstimateStatus.sent:
        return Colors.blue.shade700;
      case EstimateStatus.approved:
        return Colors.green.shade700;
      case EstimateStatus.declined:
        return Colors.red.shade700;
    }
  }

  String _statusLabel(EstimateStatus status) {
    switch (status) {
      case EstimateStatus.draft:
        return 'Draft';
      case EstimateStatus.sent:
        return 'Sent';
      case EstimateStatus.approved:
        return 'Approved';
      case EstimateStatus.declined:
        return 'Declined';
    }
  }

  Widget _buildOverviewCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      estimate.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Estimate #${estimate.estimateNumber}',
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor(estimate.status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _statusLabel(estimate.status),
                    style: TextStyle(
                      color: _statusColor(estimate.status),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                const Icon(Icons.person_outline),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    estimate.customerName,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                const Icon(Icons.calendar_today_outlined, size: 20),
                const SizedBox(width: 8),
                Text('Created ${_formatDate(estimate.createdAt)}'),
              ],
            ),
            if (estimate.validUntil != null) ...<Widget>[
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  const Icon(Icons.schedule_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text('Valid until ${_formatDate(estimate.validUntil!)}'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLineItemsCard() {
    final Map<EstimateLineCategory, List<EstimateLineItem>> groupedItems = {
      for (final EstimateLineCategory category in EstimateLineCategory.values)
        category: estimate.lineItems
            .where((EstimateLineItem item) => item.category == category)
            .toList(),
    };

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Line Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            for (final EstimateLineCategory category in EstimateLineCategory.values)
              if (groupedItems[category]!.isNotEmpty) ...<Widget>[
                Text(
                  _categoryLabel(category),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ...groupedItems[category]!.map(
                  (EstimateLineItem item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                item.description,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.quantity} ${item.unit} × \$${item.unitPrice.toStringAsFixed(2)}',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${item.lineTotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Totals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Subtotal'),
                Text('\$${estimate.subtotal.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Tax'),
                Text('\$${estimate.taxAmount.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '\$${estimate.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12),
            Text('TODO: show estimate activity and approvals'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(estimate.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildOverviewCard(),
            const SizedBox(height: 12),
            _buildLineItemsCard(),
            const SizedBox(height: 12),
            _buildTotalsCard(),
            const SizedBox(height: 12),
            _buildActivityCard(),
          ],
        ),
      ),
    );
  }
}
