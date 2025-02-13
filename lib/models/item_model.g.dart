// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationModelAdapter extends TypeAdapter<LocationModel> {
  @override
  final int typeId = 0;

  @override
  LocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationModel(
      locationId: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      type: fields[3] as String,
      description: fields[4] as String,
      imagePath: fields[5] as String?,
    )..ownerId = fields[6] as String?;
  }

  @override
  void write(BinaryWriter writer, LocationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.locationId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.ownerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BoxModelAdapter extends TypeAdapter<BoxModel> {
  @override
  final int typeId = 1;

  @override
  BoxModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BoxModel(
      ownerId: fields[6] as String?,
      locationId: fields[5] as String?,
      tags: fields[2] as String,
      description: fields[3] as String,
      id: fields[0] as String,
      name: fields[1] as String,
      imagePath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BoxModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.tags)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.locationId)
      ..writeByte(6)
      ..write(obj.ownerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoxModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItemModelAdapter extends TypeAdapter<ItemModel> {
  @override
  final int typeId = 3;

  @override
  ItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemModel(
      name: fields[0] as String,
      id: fields[1] as String,
      ownerId: fields[10] as String?,
      boxId: fields[2] as String?,
      locationId: fields[3] as String?,
      description: fields[4] as String,
      purchaseDate: fields[5] as String,
      imagePath: fields[6] as String?,
      value: fields[7] as double,
      quantity: fields[8] as int,
      tags: fields[9] as String,
    )..boxLocationId = fields[11] as String?;
  }

  @override
  void write(BinaryWriter writer, ItemModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.boxId)
      ..writeByte(3)
      ..write(obj.locationId)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.purchaseDate)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.value)
      ..writeByte(8)
      ..write(obj.quantity)
      ..writeByte(9)
      ..write(obj.tags)
      ..writeByte(10)
      ..write(obj.ownerId)
      ..writeByte(11)
      ..write(obj.boxLocationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
