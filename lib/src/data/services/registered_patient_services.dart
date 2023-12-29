




import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meroupachar/src/core/api.dart';
import 'package:meroupachar/src/data/model/registered_patient_model.dart';


final getPatientList = FutureProvider((ref) => RegisteredPatientService().getRegisteredPatients());


class RegisteredPatientService{
  final dio = Dio();

  Future<List<RegisteredPatientModel>> getRegisteredPatients() async {
    try{
      final response = await dio.get('${Api.getRegisteredPatients}');

      final data = (response.data['result'] as List)
          .map((e) => RegisteredPatientModel.fromJson(e))
          .toList();

      return data;

    }on DioException catch(e){
      (e);
      throw Exception('Something went wrong');
    }
  }


}