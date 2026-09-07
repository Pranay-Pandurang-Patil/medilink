import 'package:flutter/material.dart';

import 'package:medilink/features/inventory/screens/add_medicine_screen.dart';
import 'package:medilink/features/inventory/screens/medicine_details_screen.dart';
import 'package:medilink/models/medicine.dart';
import 'package:medilink/services/medicine_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final MedicineService medicineService = MedicineService();

  Future<void> _openAddMedicine() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMedicineScreen(),
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _openEditMedicine(Medicine medicine) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMedicineScreen(
          medicine: medicine,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _openMedicineDetails(Medicine medicine) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicineDetailsScreen(
          medicine: medicine,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _deleteMedicine(Medicine medicine) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Medicine'),
          content: Text(
            'Are you sure you want to delete ${medicine.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await medicineService.box.delete(medicine.id);

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medicine deleted'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: medicineService.openBox(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final medicines = medicineService.box.values.toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Inventory'),
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
                child: medicines.isEmpty
                    ? const Center(
                  child: Text(
                    'No medicines added yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = medicines[index];

                    return _MedicineCard(
                      medicine: medicine,
                      onEdit: () {
                        _openEditMedicine(medicine);
                      },
                      onDelete: () {
                        _deleteMedicine(medicine);
                      },
                      onTap: () {
                        _openMedicineDetails(medicine);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openAddMedicine,
            icon: const Icon(Icons.add),
            label: const Text('Add Medicine'),
          ),
        );
      },
    );
  }
}

class _MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const _MedicineCard({
    required this.medicine,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        onTap: onTap,

        leading: const CircleAvatar(
          child: Icon(
            Icons.medication_outlined,
          ),
        ),

        title: Text(
          medicine.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        subtitle: Text(
          '₹${medicine.sellingPrice.toStringAsFixed(2)}',
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            }

            if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 10),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}