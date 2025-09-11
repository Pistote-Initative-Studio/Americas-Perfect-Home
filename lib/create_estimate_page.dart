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
  final TextEditingController materialCostController = TextEditingController();
  List<MaterialItem> materials = [];
  List<LaborItem> labor = [];

  @override
  void initState() {
    super.initState();
    materialCostController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    titleController.dispose();
    clientController.dispose();
    materialCostController.dispose();
    super.dispose();
  }

  void _selectTemplate(EstimateTemplate? template) {
    setState(() {
      selectedTemplate = template;
      if (template != null) {
        titleController.text = template.name;
        materials = template.materials
            .map((e) => MaterialItem(name: e.name, quantity: e.quantity))
            .toList();
        labor = template.labor
            .map((e) =>
                LaborItem(role: e.role, hours: e.hours, employeeId: e.employeeId))
            .toList();
      } else {
        materials = [];
        labor = [];
      }
    });
  }

  void _addMaterial() {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Material'),
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
                  materials.add(MaterialItem(name: name, quantity: qty));
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

  void _addLabor() {
    final roleController = TextEditingController();
    final hoursController = TextEditingController();
    int? selectedEmployeeId;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Add Labor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: hoursController,
                decoration: const InputDecoration(labelText: 'Hours'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<int?>(
                value: selectedEmployeeId,
                hint: const Text('Assign Employee (optional)'),
                isExpanded: true,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Employee TBD'),
                  ),
                  ...mockEmployees.map(
                    (e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                    ),
                  )
                ],
                onChanged: (value) {
                  setStateDialog(() {
                    selectedEmployeeId = value;
                  });
                },
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
                final role = roleController.text.trim();
                final hours = double.tryParse(hoursController.text.trim()) ?? 0;
                if (role.isNotEmpty && hours > 0) {
                  setState(() {
                    labor.add(LaborItem(
                        role: role, hours: hours, employeeId: selectedEmployeeId));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            )
          ],
        ),
      ),
    );
  }

  double get laborTotal =>
      labor.fold(0.0, (sum, item) => sum + item.cost);

  void _save({required bool send}) {
    final id = mockEstimates.isEmpty
        ? 1
        : mockEstimates.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    final estimate = Estimate(
      id: id,
      title: titleController.text,
      clientName: clientController.text,
      materialsCost: double.tryParse(materialCostController.text) ?? 0,
      materials: List.from(materials),
      labor: List.from(labor),
      status: send ? 'Sent' : 'Draft',
      templateId: selectedTemplate?.id,
    )..updateTotal();
    mockEstimates.add(estimate);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final laborSubtotal = laborTotal;
    final materialsSubtotal =
        double.tryParse(materialCostController.text) ?? 0;
    final estimateTotal = materialsSubtotal + laborSubtotal;

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
            controller: materialCostController,
            decoration:
                const InputDecoration(labelText: 'Materials Subtotal'),
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
            onPressed: _addMaterial,
            child: const Text('Add Material'),
          ),
          const SizedBox(height: 16),
          const Text('Labor', style: TextStyle(fontWeight: FontWeight.bold)),
          ...labor.asMap().entries.map(
                (e) => ListTile(
                  title: Text(
                    e.value.employeeId != null
                        ? '${e.value.role} (${e.value.employeeName}) — '
                            '${e.value.hours}h @ ${String.fromCharCode(36)}${e.value.rate.toStringAsFixed(2)}/hr = ${String.fromCharCode(36)}${e.value.cost.toStringAsFixed(2)}'
                        : '${e.value.role} — ${e.value.hours}h (Employee TBD)',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        labor.removeAt(e.key);
                      });
                    },
                  ),
                ),
              ),
          TextButton(
            onPressed: _addLabor,
            child: const Text('Add Labor'),
          ),
          const SizedBox(height: 8),
          Text('Total Labor Cost: ${String.fromCharCode(36)}${laborSubtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Text('Estimate Total: ${String.fromCharCode(36)}${estimateTotal.toStringAsFixed(2)}'),
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
