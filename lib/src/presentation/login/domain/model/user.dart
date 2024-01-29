import 'package:hive/hive.dart';

part 'user.g.dart';


@HiveType(typeId: 0) // Unique identifier for the User model
class User extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? userID;

  @HiveField(2)
  int? typeID;

  @HiveField(3)
  String? referredID;

  @HiveField(4)
  String? parentID;

  @HiveField(5)
  String? firstName;

  @HiveField(6)
  String? lastName;

  @HiveField(7)
  String? password;

  @HiveField(8)
  int? countryID;

  @HiveField(9)
  int? provinceID;

  @HiveField(10)
  int? districtID;

  @HiveField(11)
  int? municipalityID;

  @HiveField(12)
  int? wardNo;

  @HiveField(13)
  String? localAddress;

  @HiveField(14)
  String? contactNo;

  @HiveField(15)
  String? email;

  @HiveField(16)
  int? roleID;

  @HiveField(17)
  String? designation;

  @HiveField(18)
  String? joinedDate;

  @HiveField(19)
  String? validDate;

  @HiveField(20)
  String? signatureImage;

  @HiveField(21)
  String? profileImage;

  @HiveField(22)
  bool? isActive;

  @HiveField(23)
  int? genderID;

  @HiveField(24)
  String? entryDate;

  @HiveField(25)
  int? prefixSettingID;

  @HiveField(26)
  String? token;

  @HiveField(27)
  int? panNo;

  @HiveField(28)
  int? natureID;

  @HiveField(29)
  String? liscenceNo;

  @HiveField(30)
  String? flag;

  @HiveField(31)
  String? code;

  @HiveField(32)
  String? username;

  @HiveField(33)
  String? orgId;

  @HiveField(34)
  String? ageGender;

  @HiveField(35)
  String? dob;

  User({
    this.id,
    this.userID,
    this.typeID,
    this.referredID,
    this.parentID,
    this.firstName,
    this.lastName,
    this.password,
    this.countryID,
    this.provinceID,
    this.districtID,
    this.municipalityID,
    this.wardNo,
    this.localAddress,
    this.contactNo,
    this.email,
    this.roleID,
    this.designation,
    this.joinedDate,
    this.validDate,
    this.signatureImage,
    this.profileImage,
    this.isActive,
    this.genderID,
    this.entryDate,
    this.prefixSettingID,
    this.token,
    this.panNo,
    this.natureID,
    this.liscenceNo,
    this.flag,
    this.code,
    this.username,
    this.orgId,
    this.ageGender,
    this.dob,
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      userID: json['userID'] as String?,
      typeID: json['typeID'] as int?,
      referredID: json['referredID'] as String?,
      parentID: json['parentID'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      password: json['password'] as String?,
      countryID: json['countryID'] as int?,
      provinceID: json['provinceID'] as int?,
      districtID: json['districtID'] as int?,
      municipalityID: json['municipalityID'] as int?,
      wardNo: json['wardNo'] as int?,
      localAddress: json['localAddress'] as String?,
      contactNo: json['contactNo'] as String?,
      email: json['email'] as String?,
      roleID: json['roleID'] as int?,
      designation: json['designation'] as String?,
      joinedDate: json['joinedDate'] as String?,
      validDate: json['validDate'] as String?,
      signatureImage: json['signatureImage'] as String?,
      profileImage: json['profileImage'] as String?,
      isActive: json['isActive'] as bool?,
      genderID: json['genderID'] as int?,
      entryDate: json['entryDate'] as String?,
      prefixSettingID: json['prefixSettingID'] as int?,
      token: json['token'] as String?,
      panNo: json['panNo'] as int?,
      natureID: json['natureID'] as int?,
      liscenceNo: json['liscenceNo'] as String?,
      flag: json['flag'] as String?,
      code: json['code'] as String?,
      username: json['userName'] as String?,
      orgId: json['orgId'] as String?,
      ageGender: json['ageGender'] as String?,
      dob: json['dob'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'typeID': typeID,
      'referredID': referredID,
      'parentID': parentID,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'countryID': countryID,
      'provinceID': provinceID,
      'districtID': districtID,
      'municipalityID': municipalityID,
      'wardNo': wardNo,
      'localAddress': localAddress,
      'contactNo': contactNo,
      'email': email,
      'roleID': roleID,
      'designation': designation,
      'joinedDate': joinedDate,
      'validDate': validDate,
      'signatureImage': signatureImage,
      'profileImage': profileImage,
      'isActive': isActive,
      'genderID': genderID,
      'entryDate': entryDate,
      'prefixSettingID': prefixSettingID,
      'token': token,
      'panNo': panNo,
      'natureID': natureID,
      'liscenceNo': liscenceNo,
      'flag': flag,
      'code': code,
      'userName': username,
      'orgId': orgId,
      'ageGender': ageGender,
      'dob' : dob
    };
  }

  // Factory method for empty state
  factory User.empty() {
    return User(
      id: null,
      userID: null,
      typeID: null,
      referredID: null,
      parentID: null,
      firstName: null,
      lastName: null,
      password: null,
      countryID: null,
      provinceID: null,
      districtID: null,
      municipalityID: null,
      wardNo: null,
      localAddress: null,
      contactNo: null,
      email: null,
      roleID: null,
      designation: null,
      joinedDate: null,
      validDate: null,
      signatureImage: null,
      profileImage: null,
      isActive: null,
      genderID: null,
      entryDate: null,
      prefixSettingID: null,
      token: null,
      panNo: null,
      natureID: null,
      liscenceNo: null,
      flag: null,
      code: null,
      username: null,
      orgId: null,
      ageGender: null,
      dob: null
    );
  }
}
