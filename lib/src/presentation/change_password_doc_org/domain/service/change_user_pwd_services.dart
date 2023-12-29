






import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:meroupachar/src/core/api.dart';

class ChangePwdUserService{

  final dio = Dio();






  Future<Either<String,dynamic>> changeUserPwd({
    required String userId,
    required String oldPwd,
    required String newPwd,

}) async {
    dio.options.headers['Authorization'] = Api.bearerToken;

    try{
      final response = await dio.post(Api.changePwdUser,
          data: {
            "userID" : userId,
            "password" : newPwd,
            "oldpassword": oldPwd,
            "key": "",
            "flag": ""
          },


      );
      print(response.data);

      if(response.statusCode == 200 && response.data['result']['userID'] == null){
        return Left('Old Password is incorrect');
      }
      else if(response.statusCode == 200 && response.data['result']['userID'] != null){
        return Right(response.data);
      }
      else{
        return Left('Something went wrong. Try again.');
      }
    } on DioException catch(e){
      print(e);
      return Left('Something went wrong');
    }




  }

}