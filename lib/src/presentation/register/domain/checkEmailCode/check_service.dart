





import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api.dart';



final checkProvider = StateProvider((ref) => CheckService());

class CheckService{
  final dio = Dio();

  Future<Either<String,dynamic>> checkEmail({
    required email
}) async {
    try{
      final response = await dio.post('${Api.checkEmailOrCode}',
      data: {
          "doctorEmail": "$email",
          "code" : "",
          "flag": "checkemail"
      }
      );
      if(response.data['result']['doctorEmail'] == null){
        return Right(response.data);
      }
      else{
        return Left('Email already exist');
      }
    }on DioException catch(e){
      throw Exception('${e.message}');
    }
  }

  Future<Either<String,dynamic>> checkCode({
    required code
  }) async {
    try{
      final response = await dio.post('${Api.checkEmailOrCode}',
          data: {

              "doctorEmail": "",
              "code" : "$code",
              "flag": "checkcode"
          }
      );
      if(response.data['result']['code'] == null){
        return Right(response.data);
      }
      else{
        return Left('Code already exist');
      }
    }on DioException catch(e){
      throw Exception('${e.message}');
    }
  }



}