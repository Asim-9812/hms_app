

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dioFile;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../../../../../core/api.dart';
import '../../../../documents/domain/model/document_model.dart';
import '../../../../login/domain/service/login_service.dart';
import '../model/document_model.dart';


final patientFolderProvider = FutureProvider.family((ref,String usernameToken)=>PatientDocumentServices().getFolderList(username: usernameToken.split('&').first,token: usernameToken.split('&').last));
final patientDocumentProvider = FutureProvider.family((ref,String usernameToken)=>PatientDocumentServices().getDocumentList(username: usernameToken.split('&').first,token: usernameToken.split('&').last));


class PatientDocumentServices {
  final dio = Dio();



  Future<List<DocumentTypeModel>> getDocumentTypeList({required String token}) async{

    dio.options.headers['Authorization'] = 'Bearer $token';
    try{
      final response = await dio.get(Api.getDocumentType);

      final data = (response.data['result'] as List)
          .map((e) => DocumentTypeModel.fromJson(e))
          .toList();


      data.removeWhere((element) => element.documentType == 'Link');


      return data;
    } on DioException catch(e){
      print(e);
      throw Exception(e);
    }

  }

  Future<List<String>> getFolderList({
    required String username,
    required String token
}) async{
    try{
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('${Api.getPatientDocuments}$username');

      final data = (response.data['result'] as List)
          .map((e) => PatientDocumentModel.fromJson(e))
          .toList();


      List<String> folderNames = [];

      for (var item in data) {
        String folderName = item.folderName!;
        if (!folderNames.contains(folderName)) {
          folderNames.add(folderName);
        }
      }




      return folderNames;
    } on DioException catch(e){
      print(e);
      throw Exception('Unable to fetch data');
    }

  }



  Future<List<PatientDocumentModel>> getDocumentList({
    required String username,
    required String token
  }) async{
    dio.options.headers['Authorization'] = 'Bearer $token';
    try{
      final response = await dio.get('${Api.getPatientDocuments}$username');

      final data = (response.data['result'] as List)
          .map((e) => PatientDocumentModel.fromJson(e))
          .toList();


      return data;
    } on DioException {
      throw Exception('Unable to fetch data');
    }

  }
  Future<Either<String,dynamic>> addPatientDocuments({
    required int documentID,
    required String userID,
    required int documentTypeID,
    required String folderName,
    required int doctorAttachmentID,
    required String documentTitle,
    required String documentDescription,
    required String completedDate,
    required PlatformFile documentUrl,
    required String token
  }) async{
    dio.options.headers['Authorization'] = 'Bearer $token';
    try{

      Map<String,dynamic> data = {
        "documentID": documentID,
        "userID": userID,
        "documentTypeID": documentTypeID,
        "folderName": folderName,
        "doctorAttachmentID": doctorAttachmentID,
        "documentTitle": documentTitle,
        "documentDescription": documentDescription,
        "completedDate": completedDate,
        "flag": "Insert",
        "documentUrl": await dioFile.MultipartFile.fromFile(
          documentUrl.path!,
          filename: basename(documentUrl.path!),

        ),
      };
      print(data);
      dioFile.FormData formData = dioFile.FormData.fromMap(data);
      final response = await dio.post('${Api.addPatientDocuments}',
      data: formData
      );
      if(response.statusCode == 200){
        return Right(response.data);
      }
      else{
        return Left('Unsuccessful');
      }

    } on DioException catch(e){
      print(e.response?.data);
      return Left('Something went wrong');
    }
  }


  Future<Either<String,String>> delDocument({
    required String documentId,
    required String token
  }) async{
    dio.options.headers['Authorization'] = 'Bearer $token';
    try{

      final response = await dio.get('${Api.delPatientDocuments}$documentId');
      if(response.statusCode == 200){
        return Right('File deleted');
      }
      else{
        return Left('Unsuccessful');
      }

    } on DioException catch(e){
      if(e.response?.statusCode == 500){
        return Right('File deleted');
      }
      return Left('Something went wrong');
    }
  }




}