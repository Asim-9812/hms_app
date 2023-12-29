class RegisteredPatientModel {
  int? id;
  String? patientID;
  String? firstName;
  String? lastName;
  DateTime? dob;
  String? contact;
  String? imagePhoto;
  int? countryID;
  String? countryName;
  int? provinceID;
  String? provinceName;
  int? districtID;
  String? municipality;
  int? municipalityID;
  String? districtName;
  int? ward;
  String? localAddress;
  int? genderID;
  String? nid;
  String? uhid;
  DateTime? entryDate;
  dynamic flag;

  RegisteredPatientModel({
    this.id,
    this.patientID,
    this.firstName,
    this.lastName,
    this.dob,
    this.contact,
    this.imagePhoto,
    this.countryID,
    this.countryName,
    this.provinceID,
    this.provinceName,
    this.districtID,
    this.municipality,
    this.municipalityID,
    this.districtName,
    this.ward,
    this.localAddress,
    this.genderID,
    this.nid,
    this.uhid,
    this.entryDate,
    this.flag,
  });

  factory RegisteredPatientModel.fromJson(Map<String, dynamic> json) {
    return RegisteredPatientModel(
      id: json['id'],
      patientID: json['patientID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      contact: json['contact'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      imagePhoto: json['imagePhoto'],
      countryID: json['countryID'],
      countryName: json['countryName'],
      provinceID: json['provinceID'],
      provinceName: json['provinceName'],
      districtID: json['districtID'],
      municipality: json['municipality'],
      municipalityID: json['municipalityID'],
      districtName: json['districtName'],
      ward: json['ward'],
      localAddress: json['localAddress'],
      genderID: json['genderID'],
      nid: json['nid'],
      uhid: json['uhid'],
      entryDate: json['entryDate'] != null ? DateTime.parse(json['entryDate']) : null,
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientID': patientID,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob?.toIso8601String(),
      'imagePhoto': imagePhoto,
      'countryID': countryID,
      'countryName': countryName,
      'provinceID': provinceID,
      'provinceName': provinceName,
      'districtID': districtID,
      'municipality': municipality,
      'municipalityID': municipalityID,
      'districtName': districtName,
      'ward': ward,
      'localAddress': localAddress,
      'genderID': genderID,
      'nid': nid,
      'uhid': uhid,
      'entryDate': entryDate?.toIso8601String(),
      'flag': flag,
    };
  }
}
