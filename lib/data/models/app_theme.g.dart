// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppThemeAdapter extends TypeAdapter<AppTheme> {
  @override
  final int typeId = 4;

  @override
  AppTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppTheme(
      themeName: fields[0] as String,
      primaryColorValue: fields[1] as int,
      isDark: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppTheme obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.themeName)
      ..writeByte(1)
      ..write(obj.primaryColorValue)
      ..writeByte(2)
      ..write(obj.isDark);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
