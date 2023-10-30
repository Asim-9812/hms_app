




import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_app/src/core/api.dart';
import 'package:medical_app/src/presentation/patient/health_tips/domain/model/health_tips_model.dart';


final getHealthTipsList = FutureProvider((ref) => HealthTipServices().getHealthTips());


class HealthTipServices{
  final dio = Dio();

  Future<List<HealthTipsModel>> getHealthTips() async {
    try{
      final response = await dio.get('${Api.getHealthTipsList}');

      final data = (response.data['result'] as List)
          .map((e) => HealthTipsModel.fromJson(e))
          .toList();

      return data;

    }on DioException catch(e){
      (e);
      throw Exception('Something went wrong');
    }
  }


}