
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../core/api.dart';
import '../../presentation/login/domain/model/user.dart';


final userUpdateProvider = StateProvider((ref) => UpdateProfile());

class UpdateProfile{

  final dio = Dio();

  Future<Either<String, dynamic>> updateUser({
    required int ID,
    required String userID,
    required int typeID,
    required String referredID,
    required String parentID,
    required String firstName,
    required String lastName,
    required String password,
    required int countryID,
    required int provinceID,
    required int districtID,
    required int municipalityID,
    required int wardNo,
    required String localAddress,
    required String contactNo,
    required String email,
    required int roleID,
    required String designation,
    required String joinedDate,
    required String validDate,
    required String signatureImage,
    required String profileImage,
    required bool isActive,
    required int genderID,
    required String entryDate,
    required int PrefixSettingID,
    required String token,
    required String flag,
    int? liscenceNo,
    int? panNo,
    XFile? profileImageUrl,
    XFile? signatureImageUrl,
  }) async {
    try {
      dio.options.headers['Authorization'] = Api.bearerToken;
      Map<String, dynamic> data = {
        'ID': ID,
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
        'validDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'signatureImage': signatureImage,
        'profileImage': profileImage,
        'isActive': isActive,
        'genderID': genderID,
        'entryDate': entryDate,
        'PrefixSettingID': PrefixSettingID,
        'token': token,
        'flag': flag,
        'liscenceNo':liscenceNo,
        'panNo' : panNo,
        'profileImageUrl': profileImageUrl !=null? await MultipartFile.fromFile(profileImageUrl.path):'',
        'signatureImageUrl': signatureImageUrl != null ? await MultipartFile.fromFile(signatureImageUrl.path):'',
      };

      FormData formData = FormData.fromMap(data);
      (data);
      final response = await dio.post('${Api.userUpdate}', data: formData);



      if (response.statusCode == 200) {
        print('This is also executed');
        String? profileImg = response.data['result']['profileImage'];
        String? signatureImg = response.data['result']['signatureImage'];

        final userBox = Hive.box<User>('session').values.toList();

        userBox[0].profileImage = profileImg??'';
        userBox[0].signatureImage = signatureImg??'';


        return Right(response.data);
      } else {
        //print(' error : ${response.data}');
        return Left('Unable to register.');
      }
    } on DioException catch (e) {
     print('${e.response?.statusCode}');
      return Left('Something went wrong');
    }
  }



}