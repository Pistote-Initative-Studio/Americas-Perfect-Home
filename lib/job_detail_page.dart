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
    _tabController = TabController(length: 5, vsync: this);
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
        text: material != null ? material.quantity.toString() : '');

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
              final quantity = int.tryParse(quantityController.text.trim()) ?? 0;
              if (name.isNotEmpty && quantity > 0) {
                setState(() {
                  final item = MaterialItem(name: name, quantity: quantity);
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

  void _deleteMaterial(int index) {
    setState(() {
      widget.job.materials.removeAt(index);
    });
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
            Tab(text: 'Materials'),
            Tab(text: 'Employees'),
            Tab(text: 'Time Logs'),
            Tab(text: 'Invoices/Payments'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _overviewTab(),
          _materialsTab(),
          _listTab(widget.job.employees),
          _listTab(widget.job.timeLogs),
          _estimatesTab(),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _overviewTab() {
    final job = widget.job;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Client: ${job.client}'),
          Text('Status: ${job.status}'),
          Text('Current Cost: \$${job.currentCost.toStringAsFixed(2)}'),
          Text('Projected Cost: \$${job.projectedCost.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _materialsTab() {
    return ListView.builder(
      itemCount: widget.job.materials.length,
      itemBuilder: (context, index) {
        final material = widget.job.materials[index];
        return ListTile(
          title: Text(material.name),
          subtitle: Text('Quantity: ${material.quantity}'),
          trailing: widget.isAdmin
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _addOrEditMaterial(material: material, index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteMaterial(index),
                    ),
                  ],
                )
              : null,
        );
      },
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
            trailing: widget.isAdmin && estimate.status != 'Approved'
                ? TextButton(
                    onPressed: () => _approveEstimate(estimate),
                    child: const Text('Approve'),
                  )
                : null,
          ),
        );
      },
    );
  }

  FloatingActionButton? _buildFab() {
    if (_tabController.index == 1) {
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
    if (_tabController.index == 4 && widget.isAdmin) {
      return FloatingActionButton(
        onPressed: _attachEstimate,
        child: const Icon(Icons.attach_file),
      );
    }
    return null;
  }

  void _attachEstimate() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Attach Estimate'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableEstimates.length,
              itemBuilder: (context, index) {
                final estimate = availableEstimates[index];
                return ListTile(
                  title: Text(estimate.title),
                  subtitle:
                      Text('Amount: \$${estimate.amount.toStringAsFixed(2)}'),
                  onTap: () {
                    setState(() {
                      widget.job.estimates.add(estimate);
                      availableEstimates.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _approveEstimate(Estimate estimate) {
    setState(() {
      estimate.status = 'Approved';
      for (final item in estimate.materials) {
        final existingIndex = widget.job.materials
            .indexWhere((m) => m.name == item.name);
        if (existingIndex >= 0) {
          widget.job.materials[existingIndex].quantity += item.quantity;
        } else {
          widget.job.materials
              .add(MaterialItem(name: item.name, quantity: item.quantity));
        }
      }
      widget.job.projectedCost += estimate.amount;
    });
  }
}
