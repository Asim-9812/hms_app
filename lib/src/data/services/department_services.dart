



import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meroupachar/src/data/model/department_model.dart';

import '../../core/api.dart';


final getDepartmentList = FutureProvider.family((ref,String token) => DepartmentServices().getDepartmentList(token: token));

class DepartmentServices{

  final dio = Dio();

  Future<List<Department>> getDoctorDepartments({required String token}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get(Api.getDoctorDepartment,);

      final data = (response.data['result'] as List)
          .map((e) => Department.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {
      (err);
      throw Exception('Unable to fetch data');
    }
  }

  Future<List<Department>> getDepartmentList({required String token}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get(Api.getDepartmentList,);

      final data = (response.data['result'] as List)
          .map((e) => Department.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {
      print(err);
      throw Exception('Unable to fetch data');
    }
  }


}