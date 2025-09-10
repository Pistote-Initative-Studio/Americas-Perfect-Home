import 'package:flutter/material.dart';
import 'models.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  void _approve(MaterialRequest request) {
    setState(() {
      request.job.materials.add(
        MaterialItem(name: request.materialName, quantity: request.quantity),
      );
      materialRequests.remove(request);
    });
  }

  void _deny(MaterialRequest request) {
    setState(() {
      materialRequests.remove(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text('Inbox'),
      ),
      body: materialRequests.isEmpty
          ? const Center(child: Text('No material requests'))
          : ListView.builder(
              itemCount: materialRequests.length,
              itemBuilder: (context, index) {
                final request = materialRequests[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(request.materialName),
                    subtitle: Text(
                        'Qty: ${request.quantity}\nJob: ${request.job.name}\nBy: ${request.employeeName}\nNote: ${request.note}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () => _approve(request),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _deny(request),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
