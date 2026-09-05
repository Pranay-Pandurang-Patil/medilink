import 'package:hive/hive.dart';

part 'medicine.g.dart';

@HiveType(typeId: 0)
class Medicine {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String genericName;

  @HiveField(3)
  final String manufacturer;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String unit;

  @HiveField(6)
  final double sellingPrice;

  @HiveField(7)
  final String description;

  Medicine({
    required this.id,
    required this.name,
    this.genericName = '',
    this.manufacturer = '',
    this.category = '',
    this.unit = '',
    required this.sellingPrice,
    this.description = '',
  });
}