




import 'package:dio/dio.dart';
import 'package:medical_app/src/core/api.dart';

import '../model/patient_report_model.dart';


class PatientReportServices{
  final dio = Dio();

  Future<List<PatientReportModel>> getReportList({
    required String fromDate,
    required String toDate,
    required String departmentId,
    required String userId,
}) async {
    try{
      Map<String,dynamic> data2 = {
        "fromdate": fromDate,
        "todate": toDate,
        "typeid": 0,
        "departmentId": departmentId,
        "userid": userId,
        "flag": "Report"
      };
      print(data2);
      final response = await dio.post('${Api.getPatientReport}',
      data: data2
      );

      final data = (response.data['result'] as List)
          .map((e) => PatientReportModel.fromJson(e))
          .toList();

      // print(response.data['result']);

      return data;

    }on DioException catch(e){
      (e);
      throw Exception('Something went wrong');
    }
  }


}