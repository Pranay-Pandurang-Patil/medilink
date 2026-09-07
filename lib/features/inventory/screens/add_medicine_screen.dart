import 'package:flutter/material.dart';

import 'package:medilink/models/medicine.dart';
import 'package:medilink/services/medicine_service.dart';
import 'package:medilink/shared/widgets/custom_button.dart';
import 'package:medilink/shared/widgets/custom_text_field.dart';

class AddMedicineScreen extends StatefulWidget {
  final Medicine? medicine;

  const AddMedicineScreen({
    super.key,
    this.medicine,
  });

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  final MedicineService medicineService = MedicineService();

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

  bool isSaving = false;

  bool get isEditing => widget.medicine != null;

  @override
  void initState() {
    super.initState();

    final medicine = widget.medicine;

    if (medicine != null) {
      nameController.text = medicine.name;
      genericNameController.text = medicine.genericName;
      manufacturerController.text = medicine.manufacturer;
      categoryController.text = medicine.category;
      unitController.text = medicine.unit;
      priceController.text = medicine.sellingPrice.toString();
      descriptionController.text = medicine.description;
    }
  }

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

  Future<void> _saveMedicine() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await medicineService.openBox();

      final medicine = Medicine(
        id: widget.medicine?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text.trim(),
        genericName: genericNameController.text.trim(),
        manufacturer: manufacturerController.text.trim(),
        category: categoryController.text.trim(),
        unit: unitController.text.trim(),
        sellingPrice: double.parse(priceController.text.trim()),
        description: descriptionController.text.trim(),
      );

      await medicineService.box.put(
        medicine.id,
        medicine,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Medicine updated successfully'
                : 'Medicine saved successfully',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save medicine: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Medicine' : 'Add Medicine',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing
                    ? 'Update Medicine Information'
                    : 'Medicine Information',
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

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

              CustomTextField(
                controller: genericNameController,
                labelText: 'Generic Name',
                hintText: 'Enter generic name',
                prefixIcon: Icons.science_outlined,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: manufacturerController,
                labelText: 'Manufacturer',
                hintText: 'Enter manufacturer',
                prefixIcon: Icons.factory_outlined,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: categoryController,
                labelText: 'Category',
                hintText: 'e.g. Tablet, Syrup, Capsule',
                prefixIcon: Icons.category_outlined,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: unitController,
                labelText: 'Unit / Pack',
                hintText: 'e.g. 10 tablets',
                prefixIcon: Icons.inventory_2_outlined,
              ),

              const SizedBox(height: 16),

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

              CustomTextField(
                controller: descriptionController,
                labelText: 'Description',
                hintText: 'Enter description',
                prefixIcon: Icons.description_outlined,
              ),

              const SizedBox(height: 28),

              CustomButton(
                text: isSaving
                    ? 'Saving...'
                    : isEditing
                    ? 'Update Medicine'
                    : 'Save Medicine',
                icon: isEditing
                    ? Icons.update_outlined
                    : Icons.save_outlined,
                onPressed: isSaving ? () {} : _saveMedicine,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}