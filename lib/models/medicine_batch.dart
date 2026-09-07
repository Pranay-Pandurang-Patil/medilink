import 'package:hive/hive.dart';

part 'medicine_batch.g.dart';

@HiveType(typeId: 1)
class MedicineBatch {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String medicineId;

  @HiveField(2)
  final String batchNumber;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final DateTime expiryDate;

  @HiveField(5)
  final double purchasePrice;

  MedicineBatch({
    required this.id,
    required this.medicineId,
    required this.batchNumber,
    required this.quantity,
    required this.expiryDate,
    required this.purchasePrice,
  });

  MedicineBatch copyWith({
    String? id,
    String? medicineId,
    String? batchNumber,
    int? quantity,
    DateTime? expiryDate,
    double? purchasePrice,
  }) {
    return MedicineBatch(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      batchNumber: batchNumber ?? this.batchNumber,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
    );
  }
}