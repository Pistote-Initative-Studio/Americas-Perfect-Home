import 'package:flutter/material.dart';
import 'models.dart';

class CreateEstimatePage extends StatefulWidget {
  const CreateEstimatePage({super.key});

  @override
  State<CreateEstimatePage> createState() => _CreateEstimatePageState();
}

class _CreateEstimatePageState extends State<CreateEstimatePage> {
  EstimateTemplate? selectedTemplate;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController clientController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  List<MaterialItem> materials = [];
  List<MaterialItem> labor = [];

  void _selectTemplate(EstimateTemplate? template) {
    setState(() {
      selectedTemplate = template;
      if (template != null) {
        titleController.text = template.name;
        materials = template.materials
            .map((e) => MaterialItem(name: e.name, quantity: e.quantity))
            .toList();
        labor = template.labor
            .map((e) => MaterialItem(name: e.name, quantity: e.quantity))
            .toList();
      } else {
        materials = [];
        labor = [];
      }
    });
  }

  void _addItem(List<MaterialItem> list) {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: qtyController,
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
              final qty = int.tryParse(qtyController.text.trim()) ?? 0;
              if (name.isNotEmpty && qty > 0) {
                setState(() {
                  list.add(MaterialItem(name: name, quantity: qty));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  void _save({required bool send}) {
    final id = mockEstimates.isEmpty
        ? 1
        : mockEstimates.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    final estimate = Estimate(
      id: id,
      title: titleController.text,
      clientName: clientController.text,
      amount: double.tryParse(amountController.text) ?? 0,
      materials: List.from(materials),
      labor: List.from(labor),
      status: send ? 'Sent' : 'Draft',
      templateId: selectedTemplate?.id,
    );
    mockEstimates.add(estimate);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Estimate'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButton<EstimateTemplate>(
            value: selectedTemplate,
            hint: const Text('Select Template'),
            isExpanded: true,
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Blank'),
              ),
              ...mockTemplates.map(
                (t) => DropdownMenuItem(
                  value: t,
                  child: Text(t.name),
                ),
              )
            ],
            onChanged: _selectTemplate,
          ),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: clientController,
            decoration: const InputDecoration(labelText: 'Client Name'),
          ),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          const Text('Materials', style: TextStyle(fontWeight: FontWeight.bold)),
          ...materials
              .asMap()
              .entries
              .map((e) => ListTile(
                    title: Text('${e.value.name} x${e.value.quantity}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          materials.removeAt(e.key);
                        });
                      },
                    ),
                  )),
          TextButton(
            onPressed: () => _addItem(materials),
            child: const Text('Add Material'),
          ),
          const SizedBox(height: 16),
          const Text('Labor', style: TextStyle(fontWeight: FontWeight.bold)),
          ...labor
              .asMap()
              .entries
              .map((e) => ListTile(
                    title: Text('${e.value.name} x${e.value.quantity}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          labor.removeAt(e.key);
                        });
                      },
                    ),
                  )),
          TextButton(
            onPressed: () => _addItem(labor),
            child: const Text('Add Labor'),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => _save(send: false),
                  child: const Text('Save Draft')),
              ElevatedButton(
                  onPressed: () => _save(send: true),
                  child: const Text('Send to Client')),
            ],
          ),
        ],
      ),
    );
  }
}
