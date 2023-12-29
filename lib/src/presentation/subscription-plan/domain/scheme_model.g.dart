// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SchemePlaneModel _$$_SchemePlaneModelFromJson(Map<String, dynamic> json) =>
    _$_SchemePlaneModel(
      schemeplanID: json['schemeplanID'] as int?,
      schemeId: json['schemeId'] as int?,
      schemeAdsId: json['schemeAdsId'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      trailDay: json['trailDay'] as int?,
      storageType: json['storageType'] as int?,
      storage: json['storage'] as int?,
      userCapacity: json['userCapacity'] as int?,
      isActive: json['isActive'] as bool?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      entryDate: json['entryDate'] == null
          ? null
          : DateTime.parse(json['entryDate'] as String),
      remarks: json['remarks'] as String?,
      schemeName: json['schemeName'] as String?,
      adsTitle: json['adsTitle'] as String?,
      flag: json['flag'] as String?,
    );

Map<String, dynamic> _$$_SchemePlaneModelToJson(_$_SchemePlaneModel instance) =>
    <String, dynamic>{
      'schemeplanID': instance.schemeplanID,
      'schemeId': instance.schemeId,
      'schemeAdsId': instance.schemeAdsId,
      'price': instance.price,
      'trailDay': instance.trailDay,
      'storageType': instance.storageType,
      'storage': instance.storage,
      'userCapacity': instance.userCapacity,
      'isActive': instance.isActive,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'entryDate': instance.entryDate?.toIso8601String(),
      'remarks': instance.remarks,
      'schemeName': instance.schemeName,
      'adsTitle': instance.adsTitle,
      'flag': instance.flag,
    };
