import 'package:flutter/material.dart';

import 'package:medilink/features/inventory/screens/add_medicine_screen.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  void _openAddMedicine(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMedicineScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Search
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search medicines...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _MedicineCard(
                  name: 'Paracetamol',
                  details: '500 mg • 20 tablets',
                  stock: 50,
                ),
                _MedicineCard(
                  name: 'Amoxicillin',
                  details: '500 mg • 10 capsules',
                  stock: 8,
                ),
                _MedicineCard(
                  name: 'Cetirizine',
                  details: '10 mg • 10 tablets',
                  stock: 0,
                ),
              ],
            ),
          ),
        ],
      ),

      // Inventory Add Medicine button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddMedicine(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Medicine'),
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  final String name;
  final String details;
  final int stock;

  const _MedicineCard({
    required this.name,
    required this.details,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = stock == 0;
    final bool isLowStock = stock > 0 && stock <= 10;

    String stockText;

    if (isOutOfStock) {
      stockText = 'Out of stock';
    } else if (isLowStock) {
      stockText = 'Low stock: $stock';
    } else {
      stockText = 'Stock: $stock';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: const CircleAvatar(
          child: Icon(Icons.medication_outlined),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '$details\n$stockText',
          ),
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Medicine details
        },
      ),
    );
  }
}