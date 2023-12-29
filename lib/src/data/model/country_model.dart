

class Country{
  final int countryId;
  final String countryName;
  final bool isActive;

  Country({
    required this.countryId,
    required this.countryName,
    required this.isActive
});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryId: json['countryId'],
      countryName: json['countryName'],
      isActive: json['isActive']
    );
  }
}

class ProvinceModel {
  int provinceId;
  String provinceName;
  bool isActive;
  int countryId;

  ProvinceModel({
    required this.provinceId,
    required this.provinceName,
    required this.isActive,
    required this.countryId,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      provinceId: json['provinceId'],
      provinceName: json['provinceName'],
      isActive: json['isActive'],
      countryId: json['countryId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['provinceId'] = this.provinceId;
    data['provinceName'] = this.provinceName;
    data['isActive'] = this.isActive;
    data['countryId'] = this.countryId;
    return data;
  }
}


class DistrictModel {
  int districtId;
  String districtName;
  int provinceId;
  String provinceName;

  DistrictModel({
    required this.districtId,
    required this.districtName,
    required this.provinceId,
    required this.provinceName,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      districtId: json['districtId'],
      districtName: json['districtName'],
      provinceId: json['provinceId'],
      provinceName: json['provinceName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['districtId'] = this.districtId;
    data['districtName'] = this.districtName;
    data['provinceId'] = this.provinceId;
    data['provinceName'] = this.provinceName;
    return data;
  }
}

class MunicipalityModel {
  int municipalityId;
  String municipalityName;
  int districtId;
  String districtName;

  MunicipalityModel({
    required this.municipalityId,
    required this.municipalityName,
    required this.districtId,
    required this.districtName
  });

  factory MunicipalityModel.fromJson(Map<String, dynamic> json) {
    return MunicipalityModel(
      municipalityId: json['municipalityId'],
      municipalityName: json['municipality'],
      districtId: json['districtId'],
      districtName: json['districtName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['municipalityId'] = this.municipalityId;
    data['municipality'] = this.municipalityName;
    data['districtId'] = this.districtId;
    data['districtName'] = this.districtName;
    return data;
  }
}




