class PatientInfoModel {
  final int? id;
  final String? patientID;
  final String? firstName;
  final String? lastName;
  final String? code;
  final String? dob;
  final String? imagePhoto;
  final int? countryID;
  final int? provinceID;
  final int? districtID;
  final int? municipalityID;
  final int? ward;
  final String? localAddress;
  final String? email;
  final String? contact;
  final int? genderID;
  final String? nid;
  final String? uhid;
  final String? entryDate;
  final String? consultDate;
  final dynamic? flag;
  final int? patientVisitID;
  final int? costCategoryID;
  final int? departmentID;
  final int? patientGroupID;
  final dynamic? doctorID;
  final int? referedByID;
  final int? tpid;
  final dynamic? policyNo;
  final dynamic? claimCode;
  final int? serviceCategoryID;
  final int? ledgerID;
  final String? typeID;
  final dynamic? patientCode;
  final int? ownerId;
  final String? userID;
  final String? entryDate1;
  final dynamic? mcb1;
  final dynamic? mcb2;
  final int? txtAge;
  final int? txtAge1;
  final int? years;
  final int? months;
  final int? days;
  final int? hours;
  final String? countryName;
  final dynamic? provinceName;
  final dynamic? districtName;
  final dynamic? municipality;

  PatientInfoModel({
    this.id,
    this.patientID,
    this.firstName,
    this.lastName,
    this.code,
    this.dob,
    this.imagePhoto,
    this.countryID,
    this.provinceID,
    this.districtID,
    this.municipalityID,
    this.ward,
    this.localAddress,
    this.email,
    this.contact,
    this.genderID,
    this.nid,
    this.uhid,
    this.entryDate,
    this.consultDate,
    this.flag,
    this.patientVisitID,
    this.costCategoryID,
    this.departmentID,
    this.patientGroupID,
    this.doctorID,
    this.referedByID,
    this.tpid,
    this.policyNo,
    this.claimCode,
    this.serviceCategoryID,
    this.ledgerID,
    this.typeID,
    this.patientCode,
    this.ownerId,
    this.userID,
    this.entryDate1,
    this.mcb1,
    this.mcb2,
    this.txtAge,
    this.txtAge1,
    this.years,
    this.months,
    this.days,
    this.hours,
    this.countryName,
    this.provinceName,
    this.districtName,
    this.municipality,
  });

  factory PatientInfoModel.fromJson(Map<String, dynamic>? json) {
    return PatientInfoModel(
      id: json?['id'],
      patientID: json?['patientID'],
      firstName: json?['firstName'],
      lastName: json?['lastName'],
      code: json?['code'],
      dob: json?['dob'],
      imagePhoto: json?['imagePhoto'],
      countryID: json?['countryID'],
      provinceID: json?['provinceID'],
      districtID: json?['districtID'],
      municipalityID: json?['municipalityID'],
      ward: json?['ward'],
      localAddress: json?['localAddress'],
      email: json?['email'],
      contact: json?['contact'],
      genderID: json?['genderID'],
      nid: json?['nid'],
      uhid: json?['uhid'],
      entryDate: json?['entryDate'],
      consultDate: json?['consultDate'],
      flag: json?['flag'],
      patientVisitID: json?['patientVisitID'],
      costCategoryID: json?['costCategoryID'],
      departmentID: json?['departmentID'],
      patientGroupID: json?['patientGroupID'],
      doctorID: json?['doctorID'],
      referedByID: json?['referedByID'],
      tpid: json?['tpid'],
      policyNo: json?['policyNo'],
      claimCode: json?['claimCode'],
      serviceCategoryID: json?['serviceCategoryID'],
      ledgerID: json?['ledgerID'],
      typeID: json?['typeID'],
      patientCode: json?['patientCode'],
      ownerId: json?['ownerId'],
      userID: json?['userID'],
      entryDate1: json?['entryDate1'],
      mcb1: json?['mcb1'],
      mcb2: json?['mcb2'],
      txtAge: json?['txtAge'],
      txtAge1: json?['txtAge1'],
      years: json?['years'],
      months: json?['months'],
      days: json?['days'],
      hours: json?['hours'],
      countryName: json?['countryName'],
      provinceName: json?['provinceName'],
      districtName: json?['districtName'],
      municipality: json?['municipality'],
    );
  }
}
