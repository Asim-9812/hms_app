import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scheme_model.freezed.dart';
part 'scheme_model.g.dart';

@freezed
abstract class SchemePlaneModel with _$SchemePlaneModel {
  factory SchemePlaneModel({
    int? schemeplanID,
    int? schemeId,
    int? schemeAdsId,
    double? price,
    int? trailDay,
    int? storageType,
    int? storage,
    int? userCapacity,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? entryDate,
    String? remarks,
    String? schemeName,
    String? adsTitle,
    String? flag,
  }) = _SchemePlaneModel;

  factory SchemePlaneModel.empty() => SchemePlaneModel(
    schemeplanID: null,
    schemeId: null,
    schemeAdsId: null,
    price: null,
    trailDay: null,
    storageType: null,
    storage: null,
    userCapacity: null,
    isActive: null,
    startDate: null,
    endDate: null,
    entryDate: null,
    remarks: null,
    schemeName: null,
    adsTitle: null,
    flag: null,
  );

  factory SchemePlaneModel.fromJson(Map<String, dynamic> json) =>
      _$SchemePlaneModelFromJson(json);
}
