class UpdateProfileModel {
  final int id;
  final String patientID;
  final String firstName;
  final String lastName;
  final String dob;
  final int countryID;
  final int districtID;
  final int ward;
  final String localAddress;
  final String email;
  final String contact;
  final int genderID;
  final String entryDate;
  final String flag;

  UpdateProfileModel({
    required this.id,
    required this.patientID,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.countryID,
    required this.districtID,
    required this.ward,
    required this.localAddress,
    required this.email,
    required this.contact,
    required this.genderID,
    required this.entryDate,
    required this.flag,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      id: json['id'] ?? 0,
      patientID: json['patientID'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      dob: json['dob'] ?? '',
      countryID: json['countryID'] ?? 0,
      districtID: json['districtID'] ?? 0,
      ward: json['ward'] ?? 0,
      localAddress: json['localAddress'] ?? '',
      email: json['email'] ?? '',
      contact: json['contact'] ?? '',
      genderID: json['genderID'] ?? 0,
      entryDate: json['entryDate'] ?? '',
      flag: json['flag'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientID': patientID,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'countryID': countryID,
      'districtID': districtID,
      'ward': ward,
      'localAddress': localAddress,
      'email': email,
      'contact': contact,
      'genderID': genderID,
      'entryDate': entryDate,
      'flag': flag,
    };
  }
}
