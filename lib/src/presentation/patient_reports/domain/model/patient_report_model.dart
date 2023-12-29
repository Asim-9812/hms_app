class ConsultantModel {
  int id;
  String userID;
  String firstName;
  String lastName;
  String typeID;
  dynamic flag;
  dynamic code;
  dynamic departmentID;

  ConsultantModel({
    required this.id,
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.typeID,
    this.flag,
    this.code,
    this.departmentID,
  });

  factory ConsultantModel.fromJson(Map<String, dynamic> json) {
    return ConsultantModel(
      id: json['id'] as int,
      userID: json['userID'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      typeID: json['typeID'] as String,
      flag: json['flag'],
      code: json['code'],
      departmentID: json['departmentID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'firstName': firstName,
      'lastName': lastName,
      'typeID': typeID,
      'flag': flag,
      'code': code,
      'departmentID': departmentID,
    };
  }
}




class PatientReportModel {
  final int? id;
  final String? typeId;
  final int? patientVisitID;
  final String? patientID;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? dob;
  final String? patientinfo;
  final int? departmentId;
  final String? departmentName;
  final String? address;
  final int? genderId;
  final String? gender;
  final int? countryId;
  final String? countryName;
  final int? provinceId;
  final String? provinceName;
  final int? districtId;
  final String? districtName;
  final int? municipalityId;
  final String? municipality;
  final int? costCategoryID;
  final String? costCategoryType;
  final String? entrydate;
  final String? contact;
  final String? colorCode;
  final String? departmentConsult;

  PatientReportModel({
    this.id,
    this.patientVisitID,
    this.patientID,
    this.firstName,
    this.lastName,
    this.fullName,
    this.dob,
    this.patientinfo,
    this.departmentId,
    this.departmentName,
    this.address,
    this.genderId,
    this.gender,
    this.countryId,
    this.countryName,
    this.provinceId,
    this.provinceName,
    this.districtId,
    this.districtName,
    this.municipalityId,
    this.municipality,
    this.costCategoryID,
    this.costCategoryType,
    this.entrydate,
    this.contact,
    this.typeId,
    this.colorCode,
    this.departmentConsult
  });

  factory PatientReportModel.fromJson(Map<String, dynamic> json) {
    return PatientReportModel(
      id: json['id'],
      patientVisitID: json['patientVisitID'],
      patientID: json['patientID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      dob: json['dob'],
      patientinfo: json['patientinfo'],
      departmentId: json['departmentId'],
      departmentName: json['departmentName'],
      address: json['address'],
      genderId: json['genderId'],
      gender: json['gender'],
      countryId: json['countryId'],
      countryName: json['countryName'],
      provinceId: json['provinceId'],
      provinceName: json['provinceName'],
      districtId: json['districtId'],
      districtName: json['districtName'],
      municipalityId: json['municipalityId'],
      municipality: json['municipality'],
      costCategoryID: json['costCategoryID'],
      costCategoryType: json['costCategoryType'],
      entrydate: json['entrydate'],
      contact: json['contact'],
      typeId: json['typeId'],
      colorCode: json['colorcode'],
      departmentConsult: json['departmentConsult']
    );
  }
}



class UserListModel {
  int? id;
  String? userID;
  String? firstName;
  String? lastName;
  String? typeID;
  String? flag;
  String? code;
  int? departmentID;

  UserListModel({
    this.id,
    this.userID,
    this.firstName,
    this.lastName,
    this.typeID,
    this.flag,
    this.code,
    this.departmentID,
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      id: json['id'] as int?,
      userID: json['userID'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      typeID: json['typeID'] as String?,
      flag: json['flag'] as String?,
      code: json['code'] as String?,
      departmentID: json['departmentID'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userID'] = this.userID;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['typeID'] = this.typeID;
    data['flag'] = this.flag;
    data['code'] = this.code;
    data['departmentID'] = this.departmentID;
    return data;
  }
}


class PatientGroupModel {
  final int? patientGroupId;
  final String? groupName;
  final double? discountCategory;
  final bool? isActive;
  final String? remarks;
  final String? colorCode;
  final String? entryDate;
  final String? flag;

  PatientGroupModel({
    this.patientGroupId,
    this.groupName,
    this.discountCategory,
    this.isActive,
    this.remarks,
    this.colorCode,
    this.entryDate,
    this.flag,
  });

  factory PatientGroupModel.fromJson(Map<String, dynamic>? json) {
    return PatientGroupModel(
      patientGroupId: json?['patientGroupId'],
      groupName: json?['groupName'],
      discountCategory: json?['discountCategory']?.toDouble(),
      isActive: json?['isActive'],
      remarks: json?['remarks'],
      colorCode: json?['colorCode'],
      entryDate: json?['entryDate'],
      flag: json?['flag'],
    );
  }
}

