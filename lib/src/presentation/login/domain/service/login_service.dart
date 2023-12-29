import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../../main.dart';
import '../../../../core/api.dart';
import '../model/user.dart';

final userLoginProvider = StateProvider((ref) => LoginProvider());
final userProvider = StateNotifierProvider<UserProvider, List<User>>((ref) => UserProvider(ref.watch(boxA)));


class LoginProvider{
  final dio = Dio();



  Future<Either<String,Map<String,dynamic>>> userLogin({required int accountId,required String email, required String password,required String code}) async{
    var connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      try{

        if(accountId ==0){
          return Left('Please select an account type');
        }
        else{
          if(accountId == 4){
            final response = await dio.post(Api.patientLogin, data:
            {
              "username": email,
              "password": password,
            }
            );

            if(response.statusCode == 200 && response.data["result"]["id"] != 0){
              print(response.data['result']['contact']);

                response.data["result"]["typeID"] = 4;

                response.data["result"]["contactNo"] = response.data['result']['contact'];
                  final token = response.data["result"]["token"];
                  Box tokenBox = Hive.box<String>('tokenBox');
                  tokenBox.put('accessToken', token);

                  return Right(response.data);




              }
            else{
              return Left('Invalid Credential');
            }



          }
          else{
            final response = await dio.post(Api.userLogin, data:
            {
              "key": "wL65|[R7+VGB7-m",
              "code":code,
              "email": email,
              "password": password,
              "flag": "Login"
            }
            );



            if(response.statusCode == 200 && response.data["result"]["userID"] != null){

              if (response.data["result"]["typeID"] == 2 && accountId ==1){
                final token = response.data["result"]["token"];
                Box tokenBox = Hive.box<String>('tokenBox');
                tokenBox.put('accessToken', token);
                (response.data);
                return Right(response.data);
              }
              else if(response.data["result"]["typeID"] == accountId){
                final token = response.data["result"]["token"];
                Box tokenBox = Hive.box<String>('tokenBox');
                tokenBox.put('accessToken', token);
                (response.data);
                return Right(response.data);
              }else{
                return Left('Account Type doesn\'t match');
              }

            }else{
              (response.data);
              return Left('Invalid Credential');
            }
          }
          }


      } on DioException catch(err){
        print(err);
        return Left('${err.response!.data['message']}');
      }
    }else{
      return Left('No internet connection');
    }

  }
}


class UserProvider extends StateNotifier<List<User>>{
  UserProvider(super._state);

  Future<String> getUserInfo({required Map<String,dynamic> response}) async{
    ('User provider: $response');
    final newUser = User.fromJson(response["result"]);
    if(newUser.typeID == 4){
      newUser.localAddress = response['result']['patientFullAddress'];
      newUser.profileImage = response['result']['patientPhoto'];
      newUser.genderID = response['result']['gender'];


    if(Hive.box<User>('session').isEmpty){
      Hive.box<User>('session').add(newUser);
      state = [newUser];
    }else{
      Hive.box<User>('session').putAt(0, newUser);
      state = [newUser];
    }
    }
    else{

      if(Hive.box<User>('session').isEmpty){
        Hive.box<User>('session').add(newUser);
        state = [newUser];
      }else{
        Hive.box<User>('session').putAt(0, newUser);
        state = [newUser];
      }
    }
    return 'success';
  }

  void userLogout() async{
    Hive.box<String>('tokenBox').clear();
    Hive.box<User>('session').clear();
    state = [];
  }
}