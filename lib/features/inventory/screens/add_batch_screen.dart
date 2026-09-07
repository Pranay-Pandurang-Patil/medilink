import 'package:flutter/material.dart';

import 'package:medilink/models/medicine.dart';
import 'package:medilink/models/medicine_batch.dart';
import 'package:medilink/services/batch_service.dart';
import 'package:medilink/shared/widgets/custom_button.dart';
import 'package:medilink/shared/widgets/custom_text_field.dart';

class AddBatchScreen extends StatefulWidget {
  final Medicine medicine;

  const AddBatchScreen({
    super.key,
    required this.medicine,
  });

  @override
  State<AddBatchScreen> createState() => _AddBatchScreenState();
}

class _AddBatchScreenState extends State<AddBatchScreen> {
  final _formKey = GlobalKey<FormState>();

  final BatchService batchService = BatchService();

  final TextEditingController batchNumberController =
  TextEditingController();

  final TextEditingController quantityController =
  TextEditingController();

  final TextEditingController priceController =
  TextEditingController();

  DateTime? expiryDate;

  bool isSaving = false;
  bool isLoading = true;

  bool useCustomPrice = false;

  @override
  void initState() {
    super.initState();

    priceController.text =
        widget.medicine.sellingPrice.toStringAsFixed(2);

    _initializeBatch();
  }

  Future<void> _initializeBatch() async {
    await batchService.openBox();

    final nextBatchNumber = batchService.getNextBatchNumber(
      widget.medicine.id,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      batchNumberController.text = nextBatchNumber.toString();
      isLoading = false;
    });
  }

  @override
  void dispose() {
    batchNumberController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (selectedDate == null) {
      return;
    }

    setState(() {
      expiryDate = selectedDate;
    });
  }

  void _toggleCustomPrice(bool value) {
    setState(() {
      useCustomPrice = value;

      if (!useCustomPrice) {
        priceController.text =
            widget.medicine.sellingPrice.toStringAsFixed(2);
      }
    });
  }

  Future<void> _saveBatch() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select expiry date'),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await batchService.openBox();

      final batch = MedicineBatch(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        medicineId: widget.medicine.id,
        batchNumber: batchNumberController.text.trim(),
        quantity: int.parse(
          quantityController.text.trim(),
        ),
        expiryDate: expiryDate!,
        purchasePrice: double.parse(
          priceController.text.trim(),
        ),
      );

      await batchService.addBatch(batch);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Batch added successfully'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save batch: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add Batch'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Batch'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.medicine.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Add a new batch',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 28),

              // Automatically generated batch number.
              TextFormField(
                controller: batchNumberController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Batch Number',
                  hintText: 'Automatically generated',
                  prefixIcon: const Icon(
                    Icons.qr_code_2_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              CustomTextField(
                controller: quantityController,
                labelText: 'Quantity',
                hintText: 'Enter stock quantity',
                prefixIcon: Icons.inventory_2_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter quantity';
                  }

                  final quantity = int.tryParse(
                    value.trim(),
                  );

                  if (quantity == null || quantity < 0) {
                    return 'Please enter a valid quantity';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Batch price.
              TextFormField(
                controller: priceController,
                readOnly: !useCustomPrice,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Batch Price',
                  hintText: 'Enter batch price',
                  prefixIcon: const Icon(
                    Icons.currency_rupee,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter price';
                  }

                  final price = double.tryParse(
                    value.trim(),
                  );

                  if (price == null || price < 0) {
                    return 'Please enter a valid price';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Checkbox(
                    value: useCustomPrice,
                    onChanged: (value) {
                      _toggleCustomPrice(
                        value ?? false,
                      );
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Change price for this batch',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              Text(
                useCustomPrice
                    ? 'Enter a different price for this batch.'
                    : 'Using medicine price: ₹${widget.medicine.sellingPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 18),

              // Expiry date.
              InkWell(
                onTap: _selectExpiryDate,
                borderRadius: BorderRadius.circular(14),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    prefixIcon: const Icon(
                      Icons.calendar_month_outlined,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    expiryDate == null
                        ? 'Select expiry date'
                        : _formatDate(expiryDate!),
                    style: TextStyle(
                      color: expiryDate == null
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: isSaving ? 'Saving...' : 'Save Batch',
                icon: Icons.save_outlined,
                onPressed: isSaving
                    ? () {}
                    : _saveBatch,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}