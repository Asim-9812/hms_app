



import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api.dart';
import '../../presentation/login/domain/service/login_service.dart';
import '../model/country_model.dart';


final getMunicipality = FutureProvider.family((ref,String token) => CountryService().getAllMunicipality(token: token));
final getDistrict = FutureProvider.family((ref,String token) => CountryService().getAllDistrict(token: token));
final getCountries = FutureProvider.family((ref,String token) => CountryService().getCountry(token: token));




class CountryService{

  final dio = Dio();


  Future<List<Country>> getCountry({required String token}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get(Api.getCountry,);

      final data = (response.data['result'] as List)
          .map((e) => Country.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {
      (err.response);
      throw Exception('Unable to fetch data');
    }
  }


  Future<List<ProvinceModel>> getAllProvince({required String token}) async
  {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get('${Api.getAllProvince}',);

      final data = (response.data['result'] as List)
          .map((e) => ProvinceModel.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {
      (err.response);
      throw Exception('Unable to fetch data');
    }
  }


  Future<List<ProvinceModel>> getProvince({
    required int countryId,
    required String token
}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    ('$countryId');
    try {
      final response = await dio.get('${Api.getProvince}$countryId',);

      final data = (response.data['result'] as List)
          .map((e) => ProvinceModel.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {
      (err.response);
      throw Exception('Unable to fetch data');
    }
  }

  Future<List<DistrictModel>> getDistrict({
    required int provinceId,
    required String token
}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get('${Api.getDistrict}$provinceId',);

      final data = (response.data['result'] as List)
          .map((e) => DistrictModel.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {
      (err.response);
      throw Exception('Unable to fetch data');
    }
  }

  Future<List<DistrictModel>> getAllDistrict({required String token}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get(Api.getAllDistrict);

      final data = (response.data['result'] as List)
          .map((e) => DistrictModel.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {
      (err.response);
      throw Exception('Unable to fetch data');
    }
  }

  Future<List<MunicipalityModel>> getAllMunicipality({required String token}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get(Api.getAllMunicipality);

      final data = (response.data['result'] as List)
          .map((e) => MunicipalityModel.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {
      (err.response);
      throw Exception('Unable to fetch data');
    }
  }



  Future<List<MunicipalityModel>> getMunicipality({
    required int districtId,
    required String token
  }) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get('${Api.getMunicipality}$districtId');

      final data = (response.data['result'] as List)
          .map((e) => MunicipalityModel.fromJson(e))
          .toList();
      return data;
    } on DioException catch (err) {
      (err);
      throw Exception('Unable to fetch data');
    }
  }


}