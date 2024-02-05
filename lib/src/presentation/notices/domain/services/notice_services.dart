




import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meroupachar/src/core/api.dart';

import '../model/notice_model.dart';


final getNoticeList = FutureProvider.family((ref,Tuple2<String, String> params) => NoticeServices().getNoticeList(code: params.value1,token: params.value2));

class NoticeServices{
  final dio = Dio();

  Future<List<NoticeModel>> getNoticeList({
    required String code,
    required String token
}) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    try{
      final response = await dio.get('${Api.getNoticeList}/$code');

      // NoticeModel noticeModel = NoticeModel(
      //   isActive: true,
      //   description: "bida",
      //   createdBy: "naya",
      //   type: "naya",
      //   code: "org0001",
      //   noticeID: 1,
      //   noticeType: 1,
      //   entryDate: "2023-01-12",
      //   toDate: DateTime(2023,01,24),
      //   validDate: DateTime(2023,01,12),
      //   userID: "org0001",
      //
      // );

      final data = (response.data['result'] as List)
          .map((e) => NoticeModel.fromJson(e))
          .toList();


      // final sortData = data.toList();
      final sortData = data.where((element) => element.toDate!.isBefore(DateTime.now()) && element.validDate!.isAfter(DateTime.now().subtract(Duration(days: 1)))).toList();

      print(sortData);
      return sortData;

    }on DioException catch(e){
      print(e);
      throw Exception('Something went wrong');
    }
  }




}