import 'package:flutter/material.dart';
import 'models.dart';

class EstimateDetailPage extends StatefulWidget {
  final Estimate estimate;
  const EstimateDetailPage({super.key, required this.estimate});

  @override
  State<EstimateDetailPage> createState() => _EstimateDetailPageState();
}

class _EstimateDetailPageState extends State<EstimateDetailPage> {
  late TextEditingController titleController;
  late TextEditingController clientController;
  late TextEditingController amountController;
  late List<MaterialItem> materials;
  late List<LaborItem> labor;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.estimate.title);
    clientController = TextEditingController(text: widget.estimate.clientName);
    amountController =
        TextEditingController(text: widget.estimate.amount.toString());
    materials = widget.estimate.materials
        .map((e) => MaterialItem(name: e.name, quantity: e.quantity))
        .toList();
    labor = widget.estimate.labor
        .map((e) => LaborItem(role: e.role, hours: e.hours, employeeId: e.employeeId))
        .toList();
  }

  @override
  void dispose() {
    titleController.dispose();
    clientController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _addMaterialItem(List<MaterialItem> list) {
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

  void _addLaborItem(List<LaborItem> list) {
    final roleController = TextEditingController();
    final hoursController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
                  list.add(LaborItem(role: role, hours: hours));
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

  void _save() {
    setState(() {
      widget.estimate.title = titleController.text;
      widget.estimate.clientName = clientController.text;
      widget.estimate.amount =
          double.tryParse(amountController.text) ?? widget.estimate.amount;
      widget.estimate.materials = List.from(materials);
      widget.estimate.labor = List.from(labor);
    });
    Navigator.pop(context);
  }

  void _delete() {
    mockEstimates.remove(widget.estimate);
    for (final job in mockJobs) {
      job.estimates.removeWhere((e) => e.id == widget.estimate.id);
    }
    Navigator.pop(context);
  }

  void _sendToClient() {
    setState(() => widget.estimate.status = 'Sent');
  }

  void _approve() {
    setState(() => widget.estimate.status = 'Accepted');
  }

  void _reject() {
    setState(() => widget.estimate.status = 'Rejected');
  }

  void _convertToJob() {
    final newJob = Job(
      id: mockJobs.length + 1,
      name: widget.estimate.title,
      client: widget.estimate.clientName,
      currentCost: 0,
      projectedCost: widget.estimate.amount,
      status: 'Not Started',
      materials: List.from(widget.estimate.materials),
      estimates: [widget.estimate],
    );
    widget.estimate.jobId = newJob.id;
    mockJobs.add(newJob);
    Navigator.pop(context);
  }

  void _attachToJob() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Attach to Job'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: mockJobs.length,
            itemBuilder: (context, index) {
              final job = mockJobs[index];
              return ListTile(
                title: Text(job.name),
                onTap: () {
                  setState(() {
                    widget.estimate.jobId = job.id;
                    job.estimates.add(widget.estimate);
                    job.materials.addAll(widget.estimate.materials);
                    job.projectedCost += widget.estimate.amount;
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final est = widget.estimate;
    return Scaffold(
      appBar: AppBar(
        title: Text('Estimate ${est.id}'),
        actions: [
          IconButton(onPressed: _delete, icon: const Icon(Icons.delete)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
            onPressed: () => _addMaterialItem(materials),
            child: const Text('Add Material'),
          ),
          const SizedBox(height: 16),
          const Text('Labor', style: TextStyle(fontWeight: FontWeight.bold)),
          ...labor
              .asMap()
              .entries
              .map((e) => ListTile(
                    title: Text('${e.value.role} — ${e.value.hours}h'),
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
            onPressed: () => _addLaborItem(labor),
            child: const Text('Add Labor'),
          ),
          const SizedBox(height: 24),
          Text('Status: ${est.status}'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(onPressed: _save, child: const Text('Save')),
              if (est.status == 'Draft' || est.status == 'Rejected')
                ElevatedButton(
                    onPressed: _sendToClient, child: const Text('Send to Client')),
              if (est.status == 'Sent')
                ElevatedButton(
                    onPressed: _approve, child: const Text('Mark Accepted')),
              if (est.status == 'Sent')
                ElevatedButton(
                    onPressed: _reject, child: const Text('Mark Rejected')),
              if (est.status == 'Accepted' && est.jobId == null)
                ElevatedButton(
                    onPressed: _convertToJob,
                    child: const Text('Convert to Job')),
              if (est.status == 'Accepted' && est.jobId == null)
                ElevatedButton(
                    onPressed: _attachToJob,
                    child: const Text('Attach to Job')),
            ],
          )
        ],
      ),
    );
  }
}
