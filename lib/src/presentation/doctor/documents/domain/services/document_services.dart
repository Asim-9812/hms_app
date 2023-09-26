
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api.dart';
import '../model/document_model.dart';


final folderProvider = FutureProvider.family((ref,String docID)=>DoctorDocumentServices().getFolderList(docID: docID));
final documentProvider = FutureProvider.family((ref,String docID)=>DoctorDocumentServices().getDocumentList(docID: docID));


class DoctorDocumentServices {
  final dio = Dio();



  Future<List<DocumentTypeModel>> getDocumentTypeList() async{
    dio.options.headers['Authorization'] = Api.bearerToken;
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
    required String docID
}) async{
    try{
      final response = await dio.get('${Api.getFolders}$docID');

      final data = (response.data['result'] as List)
          .map((e) => DoctorFolderModel.fromJson(e))
          .toList();

      return data;
    } on DioException catch(e){
      throw Exception('Unable to fetch data');
    }

  }


  Future<List<DocumentModel>> getDocumentList({
    required String docID
  }) async{
    try{
      final response = await dio.get('${Api.getDocuments}$docID');

      final data = (response.data['result'] as List)
          .map((e) => DocumentModel.fromJson(e))
          .toList();

      return data;
    } on DioException catch(e){
      throw Exception('Unable to fetch data');
    }

  }
  Future<Either<String,dynamic>> addDocument({
    required String documentID,
    required String userID,
    required int documentTypeID,
    required String folderName,
    required int doctorAttachmentID,
    required String documentTitle,
    required String documentDescription,
    required int duration,
    required int durationType,
    required String completedDate,
    required File documentUrl,
  }) async{
    try{
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
        "flag": "Insert",
        "documentUrl": documentUrl
      };
      FormData formData = FormData.fromMap(data);
      final response = await dio.post('http://192.168.1.110:404/api/DoctorDocument/InsertDocument/documentUrl',
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
    required String documentId
  }) async{
    try{
      final response = await dio.delete('${Api.delDocuments}$documentId');
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