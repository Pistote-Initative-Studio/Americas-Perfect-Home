import 'package:flutter/material.dart';
import 'models.dart';

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  void _openTemplateForm({EstimateTemplate? template, int? index}) {
    final nameController = TextEditingController(text: template?.name ?? '');
    List<MaterialItem> materials =
        template != null ? List.from(template.materials) : [];
    List<LaborItem> labor = template != null ? List.from(template.labor) : [];

    void addMaterialItem(List<MaterialItem> list) {
      final n = TextEditingController();
      final q = TextEditingController();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Add Material'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: n, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: q, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  final name = n.text.trim();
                  final qty = int.tryParse(q.text.trim()) ?? 0;
                  if (name.isNotEmpty && qty > 0) {
                    setState(() {
                      list.add(MaterialItem(name: name, quantity: qty));
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'))
          ],
        ),
      );
    }

    void addLaborItem(List<LaborItem> list) {
      final r = TextEditingController();
      final h = TextEditingController();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Add Labor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: r, decoration: const InputDecoration(labelText: 'Role')),
              TextField(controller: h, decoration: const InputDecoration(labelText: 'Hours'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  final role = r.text.trim();
                  final hours = double.tryParse(h.text.trim()) ?? 0.0;
                  if (role.isNotEmpty && hours > 0) {
                    setState(() {
                      list.add(LaborItem(role: role, hours: hours));
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'))
          ],
        ),
      );
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setDialog) {
        return AlertDialog(
          title: Text(template == null ? 'New Template' : 'Edit Template'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                const Text('Materials', style: TextStyle(fontWeight: FontWeight.bold)),
                ...materials.asMap().entries.map(
                      (e) => ListTile(
                        title: Text('${e.value.name} x${e.value.quantity}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setDialog(() => materials.removeAt(e.key));
                          },
                        ),
                      ),
                    ),
                TextButton(
                    onPressed: () => addMaterialItem(materials),
                    child: const Text('Add Material')),
                const SizedBox(height: 8),
                const Text('Labor', style: TextStyle(fontWeight: FontWeight.bold)),
                ...labor.asMap().entries.map(
                      (e) => ListTile(
                        title: Text('${e.value.role} — ${e.value.hours}h'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setDialog(() => labor.removeAt(e.key));
                          },
                        ),
                      ),
                    ),
                TextButton(
                    onPressed: () => addLaborItem(labor),
                    child: const Text('Add Labor')),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;
                  setState(() {
                    final tmpl = EstimateTemplate(
                        id: template?.id ?? (mockTemplates.isEmpty
                            ? 1
                            : mockTemplates
                                    .map((e) => e.id)
                                    .reduce((a, b) => a > b ? a : b) +
                                1),
                        name: name,
                        materials: materials,
                        labor: labor);
                    if (index != null) {
                      mockTemplates[index] = tmpl;
                    } else {
                      mockTemplates.add(tmpl);
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'))
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Templates'),
      ),
      body: ListView.builder(
        itemCount: mockTemplates.length,
        itemBuilder: (context, index) {
          final template = mockTemplates[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(template.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openTemplateForm(template: template, index: index)),
                  IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() => mockTemplates.removeAt(index));
                      })
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTemplateForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
