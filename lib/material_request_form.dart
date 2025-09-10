import 'package:flutter/material.dart';
import 'models.dart';

class MaterialRequestForm extends StatefulWidget {
  final Job job;
  final String employeeName;

  const MaterialRequestForm({
    super.key,
    required this.job,
    required this.employeeName,
  });

  @override
  State<MaterialRequestForm> createState() => _MaterialRequestFormState();
}

class _MaterialRequestFormState extends State<MaterialRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = MaterialRequest(
        job: widget.job,
        materialName: _nameController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        note: _noteController.text.trim(),
        employeeName: widget.employeeName,
      );
      setState(() {
        materialRequests.add(request);
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Materials'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Material Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  return int.tryParse(value) == null ? 'Enter a number' : null;
                },
              ),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
