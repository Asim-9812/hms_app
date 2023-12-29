




import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meroupachar/src/core/api.dart';
import 'package:meroupachar/src/presentation/patient/health_tips/domain/model/health_tips_model.dart';

import '../model/slider_model.dart';


final getSliders = FutureProvider((ref) => SliderServices().getSliderLists());


class SliderServices{
  final dio = Dio();

  Future<List<SlidersModel>> getSliderLists() async {
    try{
      dio.options.headers['Authorization'] = Api.bearerToken;
      final response = await dio.get('${Api.getSliderList}');

      final data = (response.data['result'] as List)
          .map((e) => SlidersModel.fromJson(e))
          .toList();
      final sortData = data.where((element) => DateTime.now().isBefore(element.toDate!) && DateTime.now().isAfter(element.fromDate!)).toList();

      return sortData;

    }on DioException catch(e){
      print(e);
      throw Exception('Something went wrong');
    }
  }


}