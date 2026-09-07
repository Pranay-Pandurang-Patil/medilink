// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_batch.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineBatchAdapter extends TypeAdapter<MedicineBatch> {
  @override
  final int typeId = 1;

  @override
  MedicineBatch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineBatch(
      id: fields[0] as String,
      medicineId: fields[1] as String,
      batchNumber: fields[2] as String,
      quantity: fields[3] as int,
      expiryDate: fields[4] as DateTime,
      purchasePrice: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineBatch obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medicineId)
      ..writeByte(2)
      ..write(obj.batchNumber)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.expiryDate)
      ..writeByte(5)
      ..write(obj.purchasePrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineBatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
