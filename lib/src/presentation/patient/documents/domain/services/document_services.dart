

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

import '../../../../../core/api.dart';
import '../../../../documents/domain/model/document_model.dart';
import '../model/document_model.dart';


final patientFolderProvider = FutureProvider.family((ref,String username)=>PatientDocumentServices().getFolderList(username: username));
final patientDocumentProvider = FutureProvider.family((ref,String username)=>PatientDocumentServices().getDocumentList(username: username));


class PatientDocumentServices {
  final dio = Dio();



  Future<List<DocumentTypeModel>> getDocumentTypeList() async{
    dio.options.headers['Authorization'] = Api.bearerToken;
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
    required String username
}) async{
    try{
      dio.options.headers['Authorization'] = Api.bearerToken;
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
    required String username
  }) async{
    try{
      dio.options.headers['Authorization'] = Api.bearerToken;
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
  }) async{
    try{
      dio.options.headers['Authorization'] = Api.bearerToken;
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
        "documentUrl": await MultipartFile.fromFile(
          documentUrl.path!,
          filename: basename(documentUrl.path!),

        ),
      };
      print(data);
      FormData formData = FormData.fromMap(data);
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
      print('$e');
      return Left('Something went wrong');
    }
  }


  Future<Either<String,String>> delDocument({
    required String documentId
  }) async{
    try{
      dio.options.headers['Authorization'] = Api.bearerToken;
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