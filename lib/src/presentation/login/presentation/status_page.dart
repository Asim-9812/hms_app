import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_app/src/presentation/doctor/doctor_dashboard/presentation/doctor_main_page.dart';
import 'package:medical_app/src/presentation/login/presentation/login_page.dart';
import 'package:medical_app/src/presentation/organization/organization_dashboard/presentation/org_mainpage.dart';
import '../../patient/patient_dashboard/presentation/patient_main_page.dart';
import '../domain/service/login_service.dart';

class StatusPage extends ConsumerWidget {

  final int accountId;
  StatusPage({required this.accountId});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(userProvider);
    if(auth.isNotEmpty){
      if(auth[0].typeID == 1 && accountId == 1){
        print('merchant');
        return const OrgMainPage();
      }
      else if(auth[0].typeID == 2 && accountId == 2){
        print('org');
        return const OrgMainPage();
      }
      else if(auth[0].typeID == 3 && accountId == 3){
        print('doctor');
        return DoctorMainPage();
      }
      else if(auth[0].typeID == 4 && accountId == 4){
        print('patient');
        return const PatientMainPage();
      }
      else{
        return LoginPage();
      }
    }
    else{
      return LoginPage();
    }



  }
}
