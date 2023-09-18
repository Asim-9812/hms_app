class PatientReportModel {
  final int? id;
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
    );
  }
}
