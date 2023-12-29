class HealthTipsModel {
  final int? healthTipsID;
  final String? type;
  final String? description;
  final String? createdBy;
  final bool? isActive;
  final DateTime? validDate;
  final DateTime? toDate;
  final dynamic flag;

  HealthTipsModel({
    this.healthTipsID,
    this.type,
    this.description,
    this.createdBy,
    this.isActive,
    this.validDate,
    this.toDate,
    required this.flag,
  });

  factory HealthTipsModel.fromJson(Map<String, dynamic> json) {
    return HealthTipsModel(
      healthTipsID: json['healthTipsID'],
      type: json['type'],
      description: json['description'],
      isActive: json['isActive'],
      flag: json['flag'],
      validDate: DateTime.parse(json['validDate']),
      toDate: DateTime.parse(json['toDate']),
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'healthTipsID': healthTipsID,
      'type': type,
      'description': description,
      'isActive': isActive,
      'createdBy': createdBy,
      'flag': flag,
      'validDate': validDate,
      'toDate': toDate,
    };
  }
}
