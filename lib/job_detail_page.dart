import 'package:flutter/material.dart';
import 'models.dart';
import 'material_request_form.dart';

class JobDetailPage extends StatefulWidget {
  final Job job;
  final bool isAdmin;
  final String employeeName;

  const JobDetailPage({
    super.key,
    required this.job,
    this.isAdmin = true,
    this.employeeName = 'Employee',
  });

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addOrEditMaterial({MaterialItem? material, int? index}) {
    final nameController =
        TextEditingController(text: material != null ? material.name : '');
    final quantityController = TextEditingController(
        text: material != null
            ? material.estimatedQuantity.toString()
            : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(material == null ? 'Add Material' : 'Edit Material'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final quantity =
                  double.tryParse(quantityController.text.trim()) ?? 0;
              if (name.isNotEmpty && quantity > 0) {
                setState(() {
                  final item = MaterialItem(
                    name: name,
                    estimatedQuantity: quantity,
                    actualQuantity: material?.actualQuantity ?? 0,
                  );
                  if (material == null) {
                    widget.job.materials.add(item);
                  } else if (index != null) {
                    widget.job.materials[index] = item;
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _requestMaterials() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MaterialRequestForm(
          job: widget.job,
          employeeName: widget.employeeName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Time Logs'),
            Tab(text: 'Invoices/Payments'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _overviewTab(),
          _listTab(widget.job.timeLogs),
          _estimatesTab(),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _overviewTab() {
    final job = widget.job;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Client: ${job.client}'),
          Text('Status: ${job.status}'),
          Text('Current Cost: \$${job.currentCost.toStringAsFixed(2)}'),
          Text('Projected Cost: \$${job.projectedCost.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          if (job.materials.isNotEmpty) ...[
            const Text('Materials',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DataTable(
              columns: const [
                DataColumn(label: Text('Material')),
                DataColumn(label: Text('Estimated')),
                DataColumn(label: Text('Actual')),
              ],
              rows: job.materials
                  .map(
                    (m) => DataRow(
                      cells: [
                        DataCell(Text(m.name)),
                        DataCell(Text(m.estimatedQuantity.toString())),
                        DataCell(
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              initialValue: m.actualQuantity.toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                setState(() {
                                  m.actualQuantity =
                                      double.tryParse(val) ?? 0;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
          if (job.employees.isNotEmpty) ...[
            const Text('Employees',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DataTable(
              columns: const [
                DataColumn(label: Text('Role/Employee')),
                DataColumn(label: Text('Estimated Hours')),
                DataColumn(label: Text('Actual Hours')),
              ],
              rows: job.employees
                  .map(
                    (e) => DataRow(
                      cells: [
                        DataCell(Text(e.role)),
                        DataCell(Text(e.estimatedHours.toString())),
                        DataCell(
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              initialValue: e.actualHours.toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                setState(() {
                                  e.actualHours =
                                      double.tryParse(val) ?? 0;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _listTab(List<String> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(items[index]),
      ),
    );
  }

  Widget _estimatesTab() {
    final estimates = widget.job.estimates;
    if (estimates.isEmpty) {
      return const Center(child: Text('No estimates attached'));
    }
    return ListView.builder(
      itemCount: estimates.length,
      itemBuilder: (context, index) {
        final estimate = estimates[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListTile(
            title: Text(estimate.title),
            subtitle: Text('Status: ${estimate.status}' +
                (widget.isAdmin
                    ? '\nAmount: \$${estimate.amount.toStringAsFixed(2)}'
                    : '')),
            isThreeLine: widget.isAdmin,
          ),
        );
      },
    );
  }

  FloatingActionButton? _buildFab() {
    if (_tabController.index == 0) {
      return widget.isAdmin
          ? FloatingActionButton(
              onPressed: () => _addOrEditMaterial(),
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: _requestMaterials,
              child: const Icon(Icons.add),
            );
    }
    return null;
  }
}
