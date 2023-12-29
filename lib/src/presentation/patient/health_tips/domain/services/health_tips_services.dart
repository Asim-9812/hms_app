




import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meroupachar/src/core/api.dart';
import 'package:meroupachar/src/presentation/patient/health_tips/domain/model/health_tips_model.dart';


final getHealthTipsList = FutureProvider((ref) => HealthTipServices().getHealthTips());


class HealthTipServices{
  final dio = Dio();

  Future<List<HealthTipsModel>> getHealthTips() async {
    try{
      final response = await dio.get('${Api.getHealthTipsList}');

      final data = (response.data['result'] as List)
          .map((e) => HealthTipsModel.fromJson(e))
          .toList();
      print(data);
      final sortData = data.where((element) => DateTime.now().isBefore(element.toDate!) && DateTime.now().isAfter(element.validDate!)).toList();


      return sortData;

    }on DioException catch(e){
      print(e);
      throw Exception('Something went wrong');
    }
  }


}