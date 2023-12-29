


class RegisterDoctorModel {
  final String firstName;
  final String lastName;
  final String email;
  final String contactNo;
  // final String licenseNo;
  final String password;
  final int genderId;
  final String code;
  final int natureId;

  RegisterDoctorModel({
    // required this.licenseNo,
    required this.genderId,
    required this.contactNo,
    required this.password,
    required this.email,
    required this.lastName,
    required this.firstName,
    required this.code,
    required this.natureId
});

}



class NatureTypeModel {
  int natureTypeID;
  int typeID;
  String natureType;
  dynamic flag;

  NatureTypeModel({
    required this.natureTypeID,
    required this.typeID,
    required this.natureType,
    this.flag,
  });

  factory NatureTypeModel.fromJson(Map<String, dynamic> json) {
    return NatureTypeModel(
      natureTypeID: json['natureTypeID'],
      typeID: json['typeID'],
      natureType: json['natureType'],
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'natureTypeID': natureTypeID,
      'typeID': typeID,
      'natureType': natureType,
      'flag': flag,
    };
  }
}