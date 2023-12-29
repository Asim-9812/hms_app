//
//
// import 'package:dio/dio.dart';
// import '../../../../core/api.dart';
// import '../model/cost_category_model.dart';
//
// class CostCategoryServices{
//
// final dio = Dio();
//
//   Future<List<CostCategoryModel>> getCostCategoryList () async{
//
//     try {
//       final response = await dio.get(Api.getCostCategory,);
//
//       final data = (response.data['result'] as List)
//           .map((e) => CostCategoryModel.fromJson(e))
//           .toList();
//       return data;
//     } on DioException catch (err) {
//       (err.response);
//       throw Exception('Unable to fetch data');
//     }
//
//   }
//
//
//
// }