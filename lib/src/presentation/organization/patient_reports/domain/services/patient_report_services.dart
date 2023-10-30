




import 'package:dio/dio.dart';
import 'package:medical_app/src/core/api.dart';

import '../model/patient_report_model.dart';


class PatientReportServices{
  final dio = Dio();

  Future<List<PatientReportModel>> getReportList({
    required String fromDate,
    required String toDate,
    required String departmentId,
}) async {
    try{
      final response = await dio.post('${Api.getPatientReport}',
      data: {
        "fromdate": fromDate,
        "todate": toDate,
        "typeid": 0,
        "departmentId": departmentId,
        "userid": 0,
        "flag": "Report"
      }
      );

      final data = (response.data['result'] as List)
          .map((e) => PatientReportModel.fromJson(e))
          .toList();

      return data;

    }on DioException catch(e){
      (e);
      throw Exception('Something went wrong');
    }
  }


}