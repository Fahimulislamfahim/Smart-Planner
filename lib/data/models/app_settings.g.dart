// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 1;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      enableMorningReminder: fields[0] as bool,
      morningReminderTime: fields[1] as String,
      enableEveningReminder: fields[2] as bool,
      eveningReminderTime: fields[3] as String,
      defaultTaskReminderOffset: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.enableMorningReminder)
      ..writeByte(1)
      ..write(obj.morningReminderTime)
      ..writeByte(2)
      ..write(obj.enableEveningReminder)
      ..writeByte(3)
      ..write(obj.eveningReminderTime)
      ..writeByte(4)
      ..write(obj.defaultTaskReminderOffset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
