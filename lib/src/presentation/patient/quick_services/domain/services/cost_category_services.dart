


import 'package:dio/dio.dart';
import 'package:medical_app/src/presentation/patient/quick_services/domain/model/cost_category_model.dart';

import '../../../../../core/api.dart';

class CostCategoryServices{

final dio = Dio();

  Future<List<CostCategoryModel>> getCostCategoryList () async{

    try {
      final response = await dio.get(Api.getCostCategory,);

      final data = (response.data['result'] as List)
          .map((e) => CostCategoryModel.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {
      (err.response);
      throw Exception('Unable to fetch data');
    }

  }



}