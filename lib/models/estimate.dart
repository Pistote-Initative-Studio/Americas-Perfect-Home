import 'package:cloud_firestore/cloud_firestore.dart';

import 'estimate_line_item.dart';

enum EstimateStatus { draft, sent, approved, declined }

class Estimate {
  final String id;
  final String estimateNumber;
  final String title;
  final String customerId;
  final String customerName;
  final EstimateStatus status;
  final DateTime createdAt;
  final DateTime? validUntil;
  final List<EstimateLineItem> lineItems;

  const Estimate({
    required this.id,
    required this.estimateNumber,
    required this.title,
    required this.customerId,
    required this.customerName,
    required this.status,
    required this.createdAt,
    this.validUntil,
    required this.lineItems,
  });

  double get subtotal =>
      lineItems.fold(0.0, (double sum, EstimateLineItem item) => sum + item.lineTotal);

  double get taxAmount => 0.0; // placeholder for now

  double get total => subtotal + taxAmount;

  static List<Estimate> fakeEstimatesForDemo(String currentUserId, bool isCustomer) {
    const String customerPeterId = 'demo-customer-peter';
    const String otherCustomerId = 'demo-customer-other';

    final List<Estimate> estimates = <Estimate>[
      Estimate(
        id: 'est1',
        estimateNumber: 'EST-0001',
        title: 'Bathroom Remodel – Johnson',
        customerId: customerPeterId,
        customerName: 'Alex Johnson',
        status: EstimateStatus.sent,
        createdAt: DateTime(2024, 3, 12),
        validUntil: DateTime(2024, 4, 12),
        lineItems: const <EstimateLineItem>[
          EstimateLineItem(
            id: 'li1',
            description: 'Demo and haul away',
            quantity: 1,
            unit: 'lot',
            unitPrice: 1500,
            category: EstimateLineCategory.labor,
          ),
          EstimateLineItem(
            id: 'li2',
            description: 'Tile and waterproofing',
            quantity: 80,
            unit: 'sq ft',
            unitPrice: 30,
            category: EstimateLineCategory.materials,
          ),
          EstimateLineItem(
            id: 'li3',
            description: 'Plumbing fixtures allowance',
            quantity: 1,
            unit: 'lot',
            unitPrice: 2200,
            category: EstimateLineCategory.materials,
          ),
        ],
      ),
      Estimate(
        id: 'est2',
        estimateNumber: 'EST-0002',
        title: 'Kitchen Remodel – Morgan',
        customerId: otherCustomerId,
        customerName: 'Morgan Smith',
        status: EstimateStatus.draft,
        createdAt: DateTime(2024, 5, 2),
        validUntil: DateTime(2024, 6, 2),
        lineItems: const <EstimateLineItem>[
          EstimateLineItem(
            id: 'li4',
            description: 'Cabinet installation',
            quantity: 35,
            unit: 'hrs',
            unitPrice: 95,
            category: EstimateLineCategory.labor,
          ),
          EstimateLineItem(
            id: 'li5',
            description: 'Quartz countertops',
            quantity: 60,
            unit: 'sq ft',
            unitPrice: 70,
            category: EstimateLineCategory.materials,
          ),
          EstimateLineItem(
            id: 'li6',
            description: 'Appliance delivery',
            quantity: 1,
            unit: 'lot',
            unitPrice: 350,
            category: EstimateLineCategory.other,
          ),
        ],
      ),
      Estimate(
        id: 'est3',
        estimateNumber: 'EST-0003',
        title: 'Extra Bedroom Addition – Lee',
        customerId: customerPeterId,
        customerName: 'Jamie Lee',
        status: EstimateStatus.approved,
        createdAt: DateTime(2024, 4, 5),
        validUntil: null,
        lineItems: const <EstimateLineItem>[
          EstimateLineItem(
            id: 'li7',
            description: 'Foundation and framing',
            quantity: 1,
            unit: 'lot',
            unitPrice: 18000,
            category: EstimateLineCategory.labor,
          ),
          EstimateLineItem(
            id: 'li8',
            description: 'Roofing tie-in',
            quantity: 450,
            unit: 'sq ft',
            unitPrice: 9,
            category: EstimateLineCategory.materials,
          ),
        ],
      ),
      Estimate(
        id: 'est4',
        estimateNumber: 'EST-0004',
        title: 'Deck Replacement – Rivera',
        customerId: otherCustomerId,
        customerName: 'Sam Rivera',
        status: EstimateStatus.declined,
        createdAt: DateTime(2024, 2, 18),
        validUntil: DateTime(2024, 3, 18),
        lineItems: const <EstimateLineItem>[
          EstimateLineItem(
            id: 'li9',
            description: 'Old deck demolition',
            quantity: 10,
            unit: 'hrs',
            unitPrice: 85,
            category: EstimateLineCategory.labor,
          ),
          EstimateLineItem(
            id: 'li10',
            description: 'Composite decking boards',
            quantity: 320,
            unit: 'sq ft',
            unitPrice: 14,
            category: EstimateLineCategory.materials,
          ),
          EstimateLineItem(
            id: 'li11',
            description: 'Permit and inspection fees',
            quantity: 1,
            unit: 'lot',
            unitPrice: 280,
            category: EstimateLineCategory.other,
          ),
        ],
      ),
    ];

    if (!isCustomer) {
      return estimates;
    }

    return estimates.where((Estimate e) => e.customerId == currentUserId).toList();
  }
}
