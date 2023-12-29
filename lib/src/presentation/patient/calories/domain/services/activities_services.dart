


import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meroupachar/src/presentation/patient/calories/domain/model/calories_model.dart';

import '../../../../../core/api.dart';


final activitiesProvider = FutureProvider((ref) => ActivitiesService().getAllActivities());


class ActivitiesService{

  final dio = Dio();

  Future<List<String>> getAllActivities({
    String? query,
  }) async {
    dio.options.headers['x-api-key'] = '9JxBABXPeV9d+qiUUnO8ZA==m298f5seHUHhyPOy';

    try {
      final response = await dio.get(Api.baseActivitiesUrl);

      List<String> savedActivities = Hive.box<ActivitiesModel>('saved_activities_box').values.map((e) => e.name).toList();

      List<dynamic> data = response.data['activities'];

      List allData = [...savedActivities,...data];

      allData.sort();



      if (query == null) {
        List<String> activities = allData.map((e) => e.toString()).toList();
        return activities;
      } else {
        List<String> queryWords = query.toLowerCase().split(' ');

        List<String> activities = allData
            .map((e) => e.toString().toLowerCase())
            .where((element) =>
            queryWords.every((word) => element.contains(word)))
            .toList();
        return activities;
      }
    } on DioException catch (e) {
      throw (e);
    }
  }

  Future<List<String>> getQueryActivities({
    String? query
  }) async {

    dio.options.headers['x-api-key'] = '9JxBABXPeV9d+qiUUnO8ZA==m298f5seHUHhyPOy' ;

    try{


      final response = await dio.get(Api.baseActivitiesUrl);
      List<String> savedActivities = Hive.box<ActivitiesModel>('saved_activities_box').values.map((e) => e.name).toList();

      List<dynamic> data = response.data['activities'];

      List allData = [...savedActivities,...data];

      allData.sort();


      if(query == null){
        List<String> activities = allData.map((e) => e.toString()).toList();
        return activities;
      }
      else{
        List<String> activities = allData.map((e) => e.toString()).where((element) => element.toLowerCase()==query).toList();
        return activities;
      }


      // print(activities);



    }on DioException catch(e){

      throw(e);
    }

  }


  Future<ActivitiesModel> getActivitiesInfo({
    required String activity,
    required int weight,
    required int duration,
  }) async {

    dio.options.headers['x-api-key'] = '9JxBABXPeV9d+qiUUnO8ZA==m298f5seHUHhyPOy' ;

    try{
      // print(parameters);
      print('${Api.caloriesBurnInfo}activity=$activity&weight=$weight&duration=$duration');


      // final response = await dio.get('https://api.api-ninjas.com/v1/caloriesburned?activity=Cycling, mountain bike, bmx&weight=160&duration=90');
      final response = await dio.get('${Api.caloriesBurnInfo}activity=$activity&weight=$weight&duration=$duration');


      final data = (response.data as List).map((e) => ActivitiesModel.fromJson(e)).toList();


      return data[0];


      // print(activities);



    }on DioException catch(e){

      throw(e);
    }

  }

}