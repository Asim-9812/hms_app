




import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meroupachar/src/core/api.dart';

import '../model/notice_model.dart';


final getNoticeList = FutureProvider.family((ref,String code) => NoticeServices().getNoticeList(code: code));

class NoticeServices{
  final dio = Dio();

  Future<List<NoticeModel>> getNoticeList({
    required String code
}) async {
    try{
      final response = await dio.get('${Api.getNoticeList}/$code');

      final data = (response.data['result'] as List)
          .map((e) => NoticeModel.fromJson(e))
          .toList();
      print(data);

      final sortData = data.where((element) => DateTime.now().isBefore(element.toDate!) && DateTime.now().isAfter(element.validDate!)).toList();

      return sortData;

    }on DioException catch(e){
      print(e);
      throw Exception('Something went wrong');
    }
  }




}