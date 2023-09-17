class HealthTipsModel {
  final int? healthTipsID;
  final String? type;
  final String? description;
  final bool? isActive;
  final dynamic flag;

  HealthTipsModel({
    this.healthTipsID,
    this.type,
    this.description,
    this.isActive,
    required this.flag,
  });

  factory HealthTipsModel.fromJson(Map<String, dynamic> json) {
    return HealthTipsModel(
      healthTipsID: json['healthTipsID'],
      type: json['type'],
      description: json['description'],
      isActive: json['isActive'],
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'healthTipsID': healthTipsID,
      'type': type,
      'description': description,
      'isActive': isActive,
      'flag': flag,
    };
  }
}
