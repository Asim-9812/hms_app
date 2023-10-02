




import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_app/src/core/api.dart';

import '../model/notice_model.dart';


final getNoticeList = FutureProvider((ref) => NoticeServices().getNoticeList());


class NoticeServices{
  final dio = Dio();

  Future<List<NoticeModel>> getNoticeList() async {
    try{
      final response = await dio.get('${Api.getNoticeList}');

      final data = (response.data['result'] as List)
          .map((e) => NoticeModel.fromJson(e))
          .toList();

      return data;

    }on DioException catch(e){
      (e);
      throw Exception('Something went wrong');
    }
  }


}