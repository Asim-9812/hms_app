




import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../../../../core/api.dart';
import '../model/patient_update_model.dart';

class PatientUpdateService{

  final dio = Dio();

  Future<Either<String,String>> updateProfile({
    required UpdateProfileModel updateProfile
}) async {
    dio.options.headers['Authorization'] = Api.bearerToken;
    try{
      // final data = updateProfile.toJson();
      final data = {
        'id': updateProfile.id,
        'patientID': updateProfile.patientID,
        'firstName': updateProfile.firstName,
        'lastName': updateProfile.lastName,
        'dob': updateProfile.dob,
        'countryID': updateProfile.countryID,
        'districtID': updateProfile.districtID,
        'ward': updateProfile.ward,
        'localAddress': updateProfile.localAddress,
        'email': updateProfile.email,
        'contact': updateProfile.contact,
        'genderID': updateProfile.genderID,
        'entryDate': updateProfile.entryDate,
        'flag': updateProfile.flag,
        if(updateProfile.imagePhoto1 != null)
        'imagephoto1' : await MultipartFile.fromFile(
          updateProfile.imagePhoto1!.path,
          filename: basename(updateProfile.imagePhoto1!.path),
        )
      };

      FormData formData = FormData.fromMap(data);
      print(formData);

      final response = await dio.post(Api.patientUpdate,
      data: formData
      );

      if(response.statusCode == 200){
        return Right('Updated Successfully.');
      }
      else{
        return Left('${response.statusCode} : Something went wrong');
      }

    }on DioException catch(e){
      print(e);
      return Left('$e');
    }
  }

}