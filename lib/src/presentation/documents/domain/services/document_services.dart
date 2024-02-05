

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

import '../../../../core/api.dart';
import '../model/document_model.dart';


final folderProvider = FutureProvider.family((ref,Tuple2<String, String> params)=>DoctorDocumentServices().getFolderList(docID: params.value1, token: params.value2));
final allDocumentProvider = FutureProvider.family((ref,Tuple2<String, String> params)=>DoctorDocumentServices().getAllDocumentList(docID: params.value1, token: params.value2));
final documentProvider = FutureProvider.family((ref,Tuple2<String, String> params)=>DoctorDocumentServices().getDocumentList(docID: params.value1, token: params.value2));
final linkProvider = FutureProvider.family((ref,Tuple2<String, String> params)=>DoctorDocumentServices().getLinkList(docID: params.value1, token: params.value2));


class DoctorDocumentServices {
  final dio = Dio();





  Future<List<DocumentTypeModel>> getDocumentTypeList({required String token}) async{
    dio.options.headers['Authorization'] = 'Bearer $token';
    try{
      final response = await dio.get(Api.getDocumentType);

      final data = (response.data['result'] as List)
          .map((e) => DocumentTypeModel.fromJson(e))
          .toList();

      return data;
    } on DioException catch(e){
      throw Exception(e);
    }

  }

  Future<List<DoctorFolderModel>> getFolderList({
    required String docID,
    required String token
}) async{
    dio.options.headers['Authorization'] = 'Bearer $token';
    try{
      final response = await dio.get('${Api.getFolders}$docID');

      final data = (response.data['result'] as List)
          .map((e) => DoctorFolderModel.fromJson(e))
          .toList();



      data.removeWhere((element) => element.folderName == '');

      return data;
    } on DioException catch(e){
      print(e);
      throw Exception('Unable to fetch data');
    }

  }

  Future<List<DocumentModel>> getAllDocumentList({
    required String docID,
    required String token
  }) async{
    dio.options.headers['Authorization'] = 'Bearer $token';
    try{
      final response = await dio.get('${Api.getDocuments}$docID');

      final data = (response.data['result'] as List)
          .map((e) => DocumentModel.fromJson(e))
          .toList();

      return data;
    } on DioException {
      throw Exception('Unable to fetch data');
    }

  }


  Future<List<DocumentModel>> getDocumentList({
    required String docID,
    required String token
  }) async{
    dio.options.headers['Authorization'] = 'Bearer $token';
    try{
      final response = await dio.get('${Api.getDocuments}$docID');

      final data = (response.data['result'] as List)
          .map((e) => DocumentModel.fromJson(e))
          .toList();

      data.removeWhere((element) => element.folderName == '');

      return data;
    } on DioException catch(e) {
      print(e);
      throw Exception('Unable to fetch data');
    }

  }


  Future<List<DocumentModel>> getLinkList({
    required String docID,
    required String token
  }) async{
    dio.options.headers['Authorization'] = 'Bearer $token';
    try{
      final response = await dio.get('${Api.getDocuments}$docID');

      final data = (response.data['result'] as List)
          .map((e) => DocumentModel.fromJson(e))
          .toList();

      data.removeWhere((element) => element.folderName != '');

      return data;
    } on DioException {
      throw Exception('Unable to fetch data');
    }

  }


  Future<Either<String,dynamic>> addDocument({
    required int documentID,
    required String userID,
    required int documentTypeID,
    required String folderName,
    required int doctorAttachmentID,
    required String documentTitle,
    required String documentDescription,
    required int duration,
    required String durationType,
    required String completedDate,
    required String flag,
    required PlatformFile? documentUrl,
    required String token
  }) async{
    try{
      dio.options.headers['Authorization'] = 'Bearer $token';
      Map<String,dynamic> data = {
        "documentID": documentID,
        "userID": userID,
        "documentTypeID": documentTypeID,
        "folderName": folderName,
        "doctorAttachmentID": doctorAttachmentID,
        "documentTitle": documentTitle,
        "documentDescription": documentDescription,
        "duration":duration,
        "durationType": durationType,
        "completedDate": completedDate,
        "flag": flag,
        if(flag == 'Insert')
        "documentUrl": await MultipartFile.fromFile(
          documentUrl!.path!,
          filename: basename(documentUrl.path!),
        )
      };
      print(data);
      FormData formData = FormData.fromMap(data);
      final response = await dio.post('${Api.addDocuments}',
      data: formData
      );
      if(response.statusCode == 200){
        return Right(response.data);
      }
      else{
        return Left('Unsuccessful');
      }

    } on DioException catch(e){
      print('$e');
      return Left('Something went wrong');
    }
  }


  Future<Either<String,String>> delDocument({
    required String documentId,
    required String token
  }) async{
    dio.options.headers['Authorization'] = 'Bearer $token';
    try{
      final response = await dio.get('${Api.delDocuments}$documentId');
      if(response.statusCode == 200){
        return Right('File deleted');
      }
      else{
        return Left('Unsuccessful');
      }

    } on DioException catch(e){
      print('$e');
      return Left('Something went wrong');
    }
  }




}