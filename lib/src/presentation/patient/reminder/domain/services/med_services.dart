



import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meroupachar/src/core/api.dart';
import 'package:meroupachar/src/presentation/patient/reminder/data/reminder_db.dart';

import '../../../../login/domain/service/login_service.dart';



final unitProvider = FutureProvider.family((ref,String token) => MedServices().getMedicineUnits(token: token));
final frequencyProvider = FutureProvider.family((ref,String token) => MedServices().getFrequency(token: token));
final routeProvider = FutureProvider.family((ref,String token) => MedServices().getRoute(token: token));

class MedServices{

  final dio = Dio();


  Future<List<String>> getMedicineUnits({required String token}) async{
    dio.options.headers['Authorization'] = 'Bearer $token';


    try{

      final response = await dio.get('${Api.getMedUnit}');

      List<String> newData = [];

      if(response.statusCode == 200){
        List data = response.data['result'].toList();
        for(int i=0; i<data.length;i++){
          String unit = data[i]['units'];
          newData.add(unit);
        }
        return newData;
      } else{
        return [];
      }

    }on DioException catch(e){
      return [];
    }

  }

  Future<List<FrequencyModel>> getFrequency({required String token}) async {

    dio.options.headers['Authorization'] = 'Bearer $token';
    try{

      final response = await dio.get('${Api.getFrequencyRoutes}');
      if(response.statusCode == 200){
        List frequencyList = response.data["item1"];
        List<FrequencyModel> newData = [];

        for(int i = 0; i < frequencyList.length ; i++){
          int frequencyUnit = 0;
          RegExp regex = RegExp(r'\((\d+)\)');
          RegExpMatch? match = regex.firstMatch(frequencyList[i]['shortName']);

          if (match != null) {
            String? numbersInBrackets = match.group(1);
            final value = FrequencyModel(
                id: frequencyList[i]['id'],
                frequencyName: frequencyList[i]['shortName'],
                frequencyInterval: numbersInBrackets!
            );
            newData.add(value);
          }

        }

        // return newData;

        /// from reminder_db.dart.... patient/reminder/data/
        return frequencyType;

      }
      else{
        return [];
      }

    }on DioException catch(e){

      return [];
    }

  }


  Future<List<MedicineTypeModel>> getRoute({required String token}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try{

      final response = await dio.get('${Api.getFrequencyRoutes}');
      List<MedicineTypeModel> newData =[];
      if(response.statusCode == 200){
        List data = response.data["item2"].toList();
        for(int i=0; i<data.length;i++){
          MedicineTypeModel route = MedicineTypeModel(
              id: data[i]['id'],
              name: data[i]['route'],
              icon: FontAwesomeIcons.capsules
          );
          // String unit = data[i]['route'];
          newData.add(route);
        }
        return newData;

      }
      else{
        return [];
      }

    }on DioException catch(e){

      return [];
    }

  }

}