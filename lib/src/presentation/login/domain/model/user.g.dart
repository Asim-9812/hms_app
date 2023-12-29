// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int?,
      userID: fields[1] as String?,
      typeID: fields[2] as int?,
      referredID: fields[3] as String?,
      parentID: fields[4] as String?,
      firstName: fields[5] as String?,
      lastName: fields[6] as String?,
      password: fields[7] as String?,
      countryID: fields[8] as int?,
      provinceID: fields[9] as int?,
      districtID: fields[10] as int?,
      municipalityID: fields[11] as int?,
      wardNo: fields[12] as int?,
      localAddress: fields[13] as String?,
      contactNo: fields[14] as String?,
      email: fields[15] as String?,
      roleID: fields[16] as int?,
      designation: fields[17] as String?,
      joinedDate: fields[18] as String?,
      validDate: fields[19] as String?,
      signatureImage: fields[20] as String?,
      profileImage: fields[21] as String?,
      isActive: fields[22] as bool?,
      genderID: fields[23] as int?,
      entryDate: fields[24] as String?,
      prefixSettingID: fields[25] as int?,
      token: fields[26] as String?,
      panNo: fields[27] as int?,
      natureID: fields[28] as int?,
      liscenceNo: fields[29] as String?,
      flag: fields[30] as String?,
      code: fields[31] as String?,
      username: fields[32] as String?,
      orgId: fields[33] as String?,
      ageGender: fields[34] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(35)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userID)
      ..writeByte(2)
      ..write(obj.typeID)
      ..writeByte(3)
      ..write(obj.referredID)
      ..writeByte(4)
      ..write(obj.parentID)
      ..writeByte(5)
      ..write(obj.firstName)
      ..writeByte(6)
      ..write(obj.lastName)
      ..writeByte(7)
      ..write(obj.password)
      ..writeByte(8)
      ..write(obj.countryID)
      ..writeByte(9)
      ..write(obj.provinceID)
      ..writeByte(10)
      ..write(obj.districtID)
      ..writeByte(11)
      ..write(obj.municipalityID)
      ..writeByte(12)
      ..write(obj.wardNo)
      ..writeByte(13)
      ..write(obj.localAddress)
      ..writeByte(14)
      ..write(obj.contactNo)
      ..writeByte(15)
      ..write(obj.email)
      ..writeByte(16)
      ..write(obj.roleID)
      ..writeByte(17)
      ..write(obj.designation)
      ..writeByte(18)
      ..write(obj.joinedDate)
      ..writeByte(19)
      ..write(obj.validDate)
      ..writeByte(20)
      ..write(obj.signatureImage)
      ..writeByte(21)
      ..write(obj.profileImage)
      ..writeByte(22)
      ..write(obj.isActive)
      ..writeByte(23)
      ..write(obj.genderID)
      ..writeByte(24)
      ..write(obj.entryDate)
      ..writeByte(25)
      ..write(obj.prefixSettingID)
      ..writeByte(26)
      ..write(obj.token)
      ..writeByte(27)
      ..write(obj.panNo)
      ..writeByte(28)
      ..write(obj.natureID)
      ..writeByte(29)
      ..write(obj.liscenceNo)
      ..writeByte(30)
      ..write(obj.flag)
      ..writeByte(31)
      ..write(obj.code)
      ..writeByte(32)
      ..write(obj.username)
      ..writeByte(33)
      ..write(obj.orgId)
      ..writeByte(34)
      ..write(obj.ageGender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
