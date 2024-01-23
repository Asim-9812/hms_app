




import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/api.dart';
import '../model/patient_update_model.dart';

class PatientUpdateService{

  final dio = Dio();

  Future<Either<String,String>> updateProfile({
    required UpdateProfileModel updateProfile
}) async {
    dio.options.headers['Authorization'] = Api.bearerToken;
    try{
      final data = updateProfile.toJson();

      // FormData formData = FormData.fromMap(data);

      final response = await dio.post(Api.patientUpdate,
      data: data
      );

      if(response.statusCode == 200){
        return Right('Updated Successfully.');
      }
      else{
        return Left('${response.statusCode} : Something went wrong');
      }

    }on DioException catch(e){
      return Left('$e');
    }
  }

}