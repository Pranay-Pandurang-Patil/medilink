import 'package:flutter/material.dart';

import 'package:medilink/features/inventory/screens/add_batch_screen.dart';
import 'package:medilink/models/medicine.dart';
import 'package:medilink/models/medicine_batch.dart';
import 'package:medilink/services/batch_service.dart';

class MedicineDetailsScreen extends StatefulWidget {
  final Medicine medicine;

  const MedicineDetailsScreen({
    super.key,
    required this.medicine,
  });

  @override
  State<MedicineDetailsScreen> createState() =>
      _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState
    extends State<MedicineDetailsScreen> {
  final BatchService batchService = BatchService();

  late Future<void> _boxFuture;

  @override
  void initState() {
    super.initState();

    // Open the Hive box only once.
    _boxFuture = batchService.openBox();
  }

  Future<void> _openAddBatch() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBatchScreen(
          medicine: widget.medicine,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _increaseStock(
      MedicineBatch batch,
      ) async {
    await batchService.increaseQuantity(batch.id);

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _decreaseStock(
      MedicineBatch batch,
      ) async {
    if (batch.quantity <= 0) {
      return;
    }

    await batchService.decreaseQuantity(batch.id);

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _deleteBatch(
      MedicineBatch batch,
      ) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Batch'),
          content: Text(
            'Delete batch ${batch.batchNumber}?',
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

    await batchService.deleteBatch(batch.id);

    if (!mounted) {
      return;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Batch deleted'),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _boxFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState !=
            ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final batches =
        batchService.getBatchesForMedicine(
          widget.medicine.id,
        );

        final totalStock = batches.fold<int>(
          0,
              (total, batch) => total + batch.quantity,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Medicine Details'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  widget.medicine.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Selling Price: ₹${widget.medicine.sellingPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),

                if (widget.medicine.genericName.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Generic: ${widget.medicine.genericName}',
                  ),
                ],

                if (widget.medicine.manufacturer.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Manufacturer: ${widget.medicine.manufacturer}',
                  ),
                ],

                if (widget.medicine.category.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${widget.medicine.category}',
                  ),
                ],

                if (widget.medicine.unit.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Unit: ${widget.medicine.unit}',
                  ),
                ],

                const SizedBox(height: 25),

                // Total stock
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Stock',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '$totalStock units',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Batches',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${batches.length}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                if (batches.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 30,
                    ),
                    child: Center(
                      child: Text(
                        'No batches added yet',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                else
                  ...batches.map(
                        (batch) => _BatchCard(
                      batch: batch,
                      formattedExpiry:
                      _formatDate(batch.expiryDate),
                      onIncrease: () {
                        _increaseStock(batch);
                      },
                      onDecrease: () {
                        _decreaseStock(batch);
                      },
                      onDelete: () {
                        _deleteBatch(batch);
                      },
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton:
          FloatingActionButton.extended(
            onPressed: _openAddBatch,
            icon: const Icon(Icons.add),
            label: const Text('Add Batch'),
          ),
        );
      },
    );
  }
}

class _BatchCard extends StatelessWidget {
  final MedicineBatch batch;
  final String formattedExpiry;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;

  const _BatchCard({
    required this.batch,
    required this.formattedExpiry,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = batch.quantity == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Batch ${batch.batchNumber}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'Delete batch',
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Text(
              'Stock Quantity',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                _StockButton(
                  icon: Icons.remove,
                  onPressed:
                  batch.quantity > 0
                      ? onDecrease
                      : null,
                ),

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${batch.quantity}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isOutOfStock
                              ? 'Out of Stock'
                              : 'units',
                          style: TextStyle(
                            fontSize: 12,
                            color: isOutOfStock
                                ? Colors.red
                                : Colors.grey.shade600,
                            fontWeight: isOutOfStock
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                _StockButton(
                  icon: Icons.add,
                  onPressed: onIncrease,
                ),
              ],
            ),

            const SizedBox(height: 15),

            Divider(
              color: Colors.grey.shade200,
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.currency_rupee,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  'Batch Price: ₹${batch.purchasePrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  'Expiry: $formattedExpiry',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StockButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _StockButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton.filled(
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}