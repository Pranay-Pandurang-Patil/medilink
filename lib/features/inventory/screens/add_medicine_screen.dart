import 'package:flutter/material.dart';

import 'package:medilink/shared/widgets/custom_button.dart';
import 'package:medilink/shared/widgets/custom_text_field.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController genericNameController =
  TextEditingController();
  final TextEditingController manufacturerController =
  TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController =
  TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    genericNameController.dispose();
    manufacturerController.dispose();
    categoryController.dispose();
    unitController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveMedicine() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medicine saved successfully'),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Medicine Information',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              // REQUIRED
              CustomTextField(
                controller: nameController,
                labelText: 'Medicine Name *',
                hintText: 'Enter medicine name',
                prefixIcon: Icons.medication_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter medicine name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // OPTIONAL
              CustomTextField(
                controller: genericNameController,
                labelText: 'Generic Name',
                hintText: 'Enter generic name',
                prefixIcon: Icons.science_outlined,
              ),

              const SizedBox(height: 16),

              // OPTIONAL
              CustomTextField(
                controller: manufacturerController,
                labelText: 'Manufacturer',
                hintText: 'Enter manufacturer',
                prefixIcon: Icons.factory_outlined,
              ),

              const SizedBox(height: 16),

              // OPTIONAL
              CustomTextField(
                controller: categoryController,
                labelText: 'Category',
                hintText: 'e.g. Tablet, Syrup, Capsule',
                prefixIcon: Icons.category_outlined,
              ),

              const SizedBox(height: 16),

              // OPTIONAL
              CustomTextField(
                controller: unitController,
                labelText: 'Unit / Pack',
                hintText: 'e.g. 10 tablets',
                prefixIcon: Icons.inventory_2_outlined,
              ),

              const SizedBox(height: 16),

              // REQUIRED
              CustomTextField(
                controller: priceController,
                labelText: 'Selling Price *',
                hintText: 'Enter selling price',
                prefixIcon: Icons.currency_rupee,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter selling price';
                  }

                  if (double.tryParse(value.trim()) == null) {
                    return 'Please enter a valid price';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // OPTIONAL
              CustomTextField(
                controller: descriptionController,
                labelText: 'Description',
                hintText: 'Enter description',
                prefixIcon: Icons.description_outlined,
              ),

              const SizedBox(height: 28),

              CustomButton(
                text: 'Save Medicine',
                icon: Icons.save_outlined,
                onPressed: _saveMedicine,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}