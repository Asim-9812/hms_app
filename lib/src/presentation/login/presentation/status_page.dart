import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_dashboard/presentation/doctor_main_page.dart';
import 'package:meroupachar/src/presentation/login/presentation/login_page.dart';
import 'package:meroupachar/src/presentation/organization/organization_dashboard/presentation/org_mainpage.dart';
import '../../patient/patient_dashboard/presentation/patient_main_page.dart';
import '../domain/service/login_service.dart';
import 'login_page.dart';

class StatusPage extends ConsumerWidget {

  final int accountId;
  StatusPage({required this.accountId});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(userProvider);
    if(auth.isNotEmpty){
      if((auth[0].typeID == 1 || auth[0].typeID == 2)  && (accountId == 1 || accountId == 2)){
        return const OrgMainPage();
      }
      else if(auth[0].typeID == 3 && accountId == 3){
        return DoctorMainPage();
      }
      else if(auth[0].typeID == 4 && accountId == 4){
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
