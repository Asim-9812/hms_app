


import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/api.dart';
import '../model/whereby_models.dart';

class MeetingServices{

  final dio = Dio();

  Future<Either<String, MeetingModel>> CreateMeeting({
    required CreateMeetingModel data
}) async {
    dio.options.headers['Authorization'] = 'Bearer ${Api.wherebyApiKey}';
    try{
      print(data.toJson());
      final response = await dio.post('${Api.createMeeting}',data:
        data.toJson()
      );
      if(response.statusCode == 201){
        return Right(MeetingModel.fromJson(response.data));
      } else{
        return Left('Something went wrong. Try again later.');
      }
      
    }on DioException catch(e){
      print(e);
      return Left(e.response?.data['error']??'Something went wrong');
      
      
    }
    
    
  }


  Future<Either<String,String>> DelMeeting({
    required MeetingModel data
}) async {
    dio.options.headers['Authorization'] = 'Bearer ${Api.wherebyApiKey}';
    try{
      final response = await dio.delete('${Api.deleteMeeting}${data.meetingId}');
      return Right('Meeting ended');
    } on DioException catch(e){
     return Left(e.response?.data['error'] ?? 'Something went wrong');
    }


  }


}