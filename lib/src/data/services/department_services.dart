



import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meroupachar/src/data/model/department_model.dart';

import '../../core/api.dart';


final getDepartmentList = FutureProvider((ref) => DepartmentServices().getDepartmentList());

class DepartmentServices{

  final dio = Dio();

  Future<List<Department>> getDoctorDepartments() async {
    dio.options.headers['Authorization'] = Api.bearerToken;
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

  Future<List<Department>> getDepartmentList() async {
    dio.options.headers['Authorization'] = Api.bearerToken;
    try {
      final response = await dio.get(Api.getDepartmentList,);

      final data = (response.data['result'] as List)
          .map((e) => Department.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {
      (err);
      throw Exception('Unable to fetch data');
    }
  }


}