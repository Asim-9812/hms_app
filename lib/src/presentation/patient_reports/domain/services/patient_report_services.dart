




import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meroupachar/src/core/api.dart';
import 'package:meroupachar/src/presentation/login/domain/model/user.dart';
import 'package:meroupachar/src/presentation/patient_reports/domain/model/patient_info_model.dart';

import '../model/patient_report_model.dart';


final getUsersDropDown = FutureProvider.family((ref, Tuple2<String, String> params) => PatientReportServices().getUsersList(code: params.value1,token: params.value2));
final getPatientProvider = FutureProvider.family((ref,Tuple2<String, String> params) => PatientReportServices().getPatientInfo(code: params.value1,token:params.value2 ));
final getPatientGroups = FutureProvider.family((ref,String token) => PatientReportServices().getPatientGroupList(token: token));

class PatientReportServices{
  final dio = Dio();

  Future<List<PatientReportModel>> getReportList({
    required String fromDate,
    required String toDate,
    required String departmentId,
    required String userId,
    required String consultantId,
    required String patientId,
    required int patientGroupId,
    required String code,
    required String token
}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try{
      Map<String,dynamic> data2 = {
        "fromdate": fromDate,
        "todate": toDate,
        "patientGroupId": patientGroupId,
        "departmentId": departmentId,
        "userid": userId,
        "consultantId":consultantId,
        "patientId":patientId,
        "code" : code,
        "flag": "Report"
      };

      final response = await dio.post('${Api.getPatientReport}',
      data: data2
      );

      final data = (response.data['result'] as List)
          .map((e) => PatientReportModel.fromJson(e))
          .toList();

      // print(response.data['result']);

      return data;

    }on DioException catch(e){

      throw Exception('Something went wrong');
    }
  }


  Future<List<UserListModel>> getUsersList({
    required String code,
    required String token
}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get('${Api.getDoctorsList}$code',);


      final data = (response.data['result'] as List)
          .map((e) => UserListModel.fromJson(e))
          .toList();
      // print('data length : ${data.length}');
      return data;
    } on DioException catch (err) {

      throw Exception('Unable to fetch data');
    }
  }

  Future<List<ConsultantModel>> getConsultantList({
    required String userId,
    required String token
  }) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get('${Api.getConsultantList}$userId',);


      final data = (response.data['result'] as List)
          .map((e) => ConsultantModel.fromJson(e))
          .toList();
      // print('data length : ${data.length}');
      return data;
    } on DioException catch (err) {

      throw Exception('Unable to fetch data');
    }
  }




  Future<List<PatientGroupModel>> getPatientGroupList({required String token}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get(Api.getPatientGroupList,);

      final data = (response.data['result'] as List)
          .map((e) => PatientGroupModel.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {

      throw Exception('Unable to fetch data');
    }
  }


  Future<PatientInfoModel> getPatientInfo({
    required String code,
    required String token
}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {

      final response = await dio.get('${Api.getPatientInfo}$code',);

      final data = PatientInfoModel.fromJson(response.data['result']);
      return data;
    } on DioException catch (err) {
      print(err);
      throw Exception('Unable to fetch data');
    }
  }


}



