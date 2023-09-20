

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/core/resources/value_manager.dart';
import 'package:medical_app/src/presentation/patient/personal_services/ct_scan/ct_scan_details.dart';
import 'package:medical_app/src/presentation/patient/personal_services/discharge_summary/discharge_details.dart';
import 'package:medical_app/src/presentation/patient/personal_services/mri/mri_details.dart';
import 'package:medical_app/src/presentation/patient/personal_services/mri/mri_details.dart';
import 'package:medical_app/src/presentation/patient/personal_services/mri/mri_details.dart';
import 'package:medical_app/src/presentation/patient/personal_services/mri/mri_details.dart';
import 'package:medical_app/src/presentation/patient/personal_services/mri/mri_details.dart';
import 'package:medical_app/src/presentation/patient/personal_services/usg/usg_details.dart';
import 'package:medical_app/src/presentation/patient/personal_services/xray/xray_details.dart';
import 'package:medical_app/src/presentation/patient/personal_services/xray/xray_details.dart';
import 'package:medical_app/src/presentation/patient/personal_services/xray/xray_details.dart';
import 'package:medical_app/src/presentation/patient/personal_services/xray/xray_details.dart';
import 'package:medical_app/src/presentation/patient/personal_services/xray/xray_details.dart';



class MRI extends StatelessWidget {
  const MRI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text('MRI',style: getMediumStyle(color: ColorManager.black),),
        elevation: 1,
        backgroundColor: ColorManager.white,
       leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.chevron_left,color: Colors.black,)),
centerTitle:true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
        shrinkWrap: true,
        children: [
          ListTile(
            onTap: ()=>Get.to(()=>MRIDetails()),
            tileColor: ColorManager.dotGrey.withOpacity(0.2),
            title: Text('2023-08-09',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
            trailing: FaIcon(Icons.chevron_right,color: ColorManager.black,),
          ),
          h10,
          ListTile(
            onTap: ()=>Get.to(()=>MRIDetails()),
            tileColor: ColorManager.dotGrey.withOpacity(0.2),
            title: Text('2023-08-09',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
            trailing: FaIcon(Icons.chevron_right,color: ColorManager.black,),
          ),
          h10,
          ListTile(
            onTap: ()=>Get.to(()=>MRIDetails()),
            tileColor: ColorManager.dotGrey.withOpacity(0.2),
            title: Text('2023-08-09',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
            trailing: FaIcon(Icons.chevron_right,color: ColorManager.black,),
          ),
          h10,
          ListTile(
            onTap: ()=>Get.to(()=>MRIDetails()),
            tileColor: ColorManager.dotGrey.withOpacity(0.2),
            title: Text('2023-08-09',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
            trailing: FaIcon(Icons.chevron_right,color: ColorManager.black,),
          ),
          h10,
          ListTile(
            onTap: ()=>Get.to(()=>MRIDetails()),
            tileColor: ColorManager.dotGrey.withOpacity(0.2),
            title: Text('2023-08-09',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
            trailing: FaIcon(Icons.chevron_right,color: ColorManager.black,),
          ),
          h10,
        ],
      ),
    );
  }
}
