

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meroupachar/src/presentation/login/domain/model/user.dart';

import '../../core/api.dart';




final userInfoProvider = FutureProvider.family<User, String>((ref, userId) {
  return UserService().getUser(userId: userId);
});



class UserService{

  final dio = Dio();


  Future<User> getUser({
    required String userId,
  }) async {
    dio.options.headers['Authorization'] = Api.bearerToken;
    try {
      final response = await dio.get('${Api.getUserById}$userId');


      return User.fromJson(response.data['result']);
    } on DioException catch (err) {
      (err);
      throw Exception('Unable to fetch data');
    }
  }


  Future<List<User>> getDoctors() async {
    dio.options.headers['Authorization'] = Api.bearerToken;
    try {
      final response = await dio.get('${Api.getUsers}',);

        final data = (response.data['result'] as List)
            .map((e) => User.fromJson(e))
            .where((element) => element.typeID == 3)
            .toList();
        return data;

    } on DioException catch (err) {
      (err);
      throw Exception('Unable to fetch data');
    }
  }


}