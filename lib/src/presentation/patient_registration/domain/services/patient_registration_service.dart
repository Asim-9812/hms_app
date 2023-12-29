//
//
//
// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../../../core/api.dart';
//
//
// final patientRegistrationProvider = StateProvider((ref) => PatientRegistration());
//
// class PatientRegistration{
//
//   final dio = Dio();
//
//
//   Future<Either<String,dynamic>> addRegistration({
//     required int id,
//     required int patientID,
//     required String firstName,
//     required String lastName,
//     required String DOB,
//     required int imagePhoto,
//     required int countryID,
//     required int provinceID,
//     required int districtID,
//     required int municipalityID,
//     required int ward,
//     required String localAddress,
//     required int genderID,
//     required int NID,
//     required int UHID,
//     required String entryDate,
//     required String flag,
//     required String consultDate,
//     required int patientVisitID,
//     required int costCategoryID,
//     required int departmentID,
//     required int referedByID,
//     required int TPID,
//     required int policyNo,
//     required int claimCode,
//     required int serviceCategoryID,
//     required int ledgerID,
//     required XFile imagePhotoUrl,
//     required String email,
//     required int contact,
//     required String entrydate1,
//     required int doctorID,
//     required String code
// }) async {
//     try{
//       Map<String, dynamic> data = {
//         'ID': id,
//         'patientID': patientID,
//         'firstName': firstName,
//         'lastName': lastName,
//         'DOB': DOB,
//         'imagePhoto': imagePhoto,
//         'countryID': countryID,
//         'provinceID': provinceID,
//         'districtID': districtID,
//         'municipalityID': municipalityID,
//         'ward': ward,
//         'localAddress': localAddress,
//         'genderID': genderID,
//         'NID': NID,
//         'UHID': UHID,
//         'entryDate': entryDate,
//         'flag': flag,
//         'consultDate': consultDate,
//         'patientVisitID': patientVisitID,
//         'costCategoryID': costCategoryID,
//         'departmentID': departmentID,
//         'referedByID':referedByID,
//         'TPID': TPID,
//         'policyNo':policyNo,
//         'claimCode':claimCode,
//         'serviceCategoryID': serviceCategoryID,
//         'ledgerID': ledgerID,
//         'imagePhotoUrl': await MultipartFile.fromFile(imagePhotoUrl.path),
//         'email': email,
//         'contact': contact,
//         'entrydate1': entrydate1,
//         'doctorID' : doctorID,
//         'code': code
//       };
//
//       FormData formData = FormData.fromMap(data);
//       final response = await dio.post('${Api.postPatientRegistration}',
//       data: formData
//       );
//       if(response.statusCode == 200){
//         return Right(response.data);
//       }
//       else {
//         (response);
//         return Left('Unable to register.');
//       }
//
//     }on DioException catch(e){
//       ('$e');
//       return Left('Something went wrong');
//     }
//   }
//
//
// }