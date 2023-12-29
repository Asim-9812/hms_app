

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meroupachar/src/presentation/subscription-plan/domain/scheme_model.dart';

import '../../../core/api.dart';


final schemeProvider = FutureProvider<List<SchemePlaneModel>>(
        (ref) => SchemeService().getSchemeList());


class SchemeService {

  final dio = Dio();


  Future<List<SchemePlaneModel>> getSchemeList() async {

    try {
      dio.options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJiZjZhNTdmNC1iN2JmLTQzYmItODgzNy0yY2NiZDE4NDM5ODIiLCJ2YWxpZCI6IjEiLCJ1c2VyaWQiOiJET0MwMDAxIiwiZXhwIjoxNzIxMjc3NDc0LCJpc3MiOiJsb2NhbGhvc3QiLCJhdWQiOiJXZWxjb21lIn0.o7_teFlpwxmG7EOBO9eL46bfOwLySS6Qyc1Yj8ZgcyI';
      final response = await dio.get(Api.schemePlan);
      final data = (response.data['result'] as List)
          .map((e) => SchemePlaneModel.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {
      print('error here : ${err.response}');
      throw Exception('Unable to fetch data');
    }
  }


}