





import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/presentation/common/url_launcher.dart';
import 'package:meroupachar/src/presentation/notification/presentation/notification_page.dart';
import 'package:meroupachar/src/presentation/patient_reports/domain/model/patient_info_model.dart';
import 'package:meroupachar/src/presentation/patient_reports/domain/services/patient_report_services.dart';

import '../../../core/api.dart';
import '../../../core/resources/value_manager.dart';
import '../../../data/provider/common_provider.dart';
import '../../common/snackbar.dart';
import '../../login/domain/model/user.dart';
import '../domain/model/patient_report_model.dart';


class ViewProfile extends ConsumerWidget {
  final String patientCode;
  final String colorCode;
  final String patientAddress;
  ViewProfile({required this.patientCode,required this.colorCode,required this.patientAddress});

  @override
  Widget build(BuildContext context,ref) {

    final patientInfo = ref.watch(getPatientProvider(patientCode));
    return Scaffold(
      backgroundColor: ColorManager.white.withOpacity(0.99),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorManager.primaryDark,
        automaticallyImplyLeading: false,
        title: Text('Patient Profile',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),
        centerTitle: true,
        leading:  IconButton(
            onPressed:()=>Get.back(),
            icon: FaIcon(Icons.chevron_left,color: ColorManager.white,)),


      ),
      body: patientInfo.when(
          data: (patientData){
            return  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeIn(
                    duration: Duration(milliseconds: 500),
                    child: profileBanner(context,ref,patientData)),
                Container(
                  height: MediaQuery.of(context).size.height * 3.5/5,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              h10,
                              InkWell(
                                onTap: patientData.contact == null ? null : (){

                                  UrlLauncher(
                                      phoneNumber: int.parse(patientData.contact!)
                                  ).launchUrl();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // border: Border.all(
                                      //   color: ColorManager.black.withOpacity(0.2)
                                      // ),
                                      color: ColorManager.textGrey.withOpacity(0.05)
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 20.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.phone,color: ColorManager.primaryDark,),
                                      w20,
                                      Text(patientData.contact??'-',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),

                                    ],
                                  ),
                                ),
                              ),
                              h10,
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // border: Border.all(
                                    //   color: ColorManager.black.withOpacity(0.2)
                                    // ),
                                    color: ColorManager.textGrey.withOpacity(0.05)
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 20.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(Icons.pin_drop_rounded,color: ColorManager.primaryDark,),
                                    w20,
                                    Text(patientAddress??'-',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),

                                  ],
                                ),
                              ),

                              _profileItems2(title: 'History & Records', icon: Icons.history, onTap: (){
                                final scaffoldMessage = ScaffoldMessenger.of(context);
                                scaffoldMessage.showSnackBar(
                                  SnackbarUtil.showComingSoonBar(
                                    message: 'Coming soon !',
                                    duration: const Duration(milliseconds: 1400),
                                  ),
                                );
                              },trailing: true),

                            ],
                          ),
                        ),
                        h100,
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          error: (error,stack) => Center(child: Text('${error}',style: getMediumStyle(color: ColorManager.black),),),
          loading: ()=>Center(child: SpinKitDualRing(color: ColorManager.primary,),)
      )


    );
  }




  /// Profile...

  Widget profileBanner(BuildContext context,ref,PatientInfoModel user) {
    final screenSize = MediaQuery.of(context).size;

    bool isNarrowScreen = screenSize.width < 420;


    String age = '${user.years} yrs';

    String gender = user.genderID == 1 ? 'Male' : user.genderID == 2 ? 'Female' : 'Others' ;



    final profileImg = ref.watch(imageProvider);
    ImageProvider<Object>? profileImage;

    if (profileImg != null) {
      profileImage = Image.file(File(profileImg.path)).image;
    } else if (user.imagePhoto == '' || user.imagePhoto == 'N/A') {
      profileImage = AssetImage('assets/icons/user.png');
    } else {
      profileImage = NetworkImage('${Api.baseUrl}/${user.imagePhoto}');
    }







    return Card(
      elevation: 1,
      color: ColorManager.white,
      shadowColor: ColorManager.textGrey.withOpacity(0.4),
      child: Container(

        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical:12.h),
        child:  Row(
          children: [
            Card(
              shape: CircleBorder(
                side: BorderSide(
                  color: HexColor.fromHex("${colorCode}"),
                  width: 1
                )
              ),
              elevation: 5,
              child: CircleAvatar(
                backgroundColor: ColorManager.white,
                radius: isNarrowScreen? 45.r:45,
                backgroundImage: profileImage,
              ),
            ),
            w10,
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${user.firstName}',style: getMediumStyle(color: ColorManager.black,fontSize: isNarrowScreen? 32.sp:32),),
                h10,
                Text('${gender} | ${age}',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isNarrowScreen?20.sp:20),),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Profile items func & ui ...
//
//   Widget _profileItems({
//     VoidCallback? onTap,
//     required String title,
//     required IconData icon,
//     String? subtitle,
//     bool? trailing,
//     required Size screenSize
//
// }) {
//
//     // Check if width is greater than height
//     bool isWideScreen = screenSize.width > 500;
//     bool isNarrowScreen = screenSize.width < 420;
//     if(trailing == null){
//      trailing = false;
//     }
//     return ListTile(
//       onTap: onTap,
//       splashColor: ColorManager.textGrey.withOpacity(0.2),
//       leading: FaIcon(icon,size: isNarrowScreen?24.sp:24,),
//       title: Text('$title',style:getRegularStyle(color: ColorManager.black,fontSize:isNarrowScreen?20.sp:20 ),),
//       subtitle: subtitle != null? Text('$subtitle',style:getRegularStyle(color: ColorManager.subtitleGrey,fontSize:isNarrowScreen?16.sp:16 ),):null,
//       trailing: trailing == true? Icon(Icons.chevron_right,color: ColorManager.iconGrey,):null ,
//     );
//   }


  Widget _profileItems2({
    VoidCallback? onTap,
    required String title,
    required IconData icon,
    String? subtitle,
    bool? trailing,
  }) {
    if (trailing == null) {
      trailing = false;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        ),
        onTap: onTap, // Pass the onTap callback here
        splashColor: ColorManager.textGrey.withOpacity(0.2),
        tileColor: ColorManager.textGrey.withOpacity(0.05),
        leading: FaIcon(icon, size: 20,color: ColorManager.primaryDark,),
        title: Text('$title', style: getRegularStyle(color: ColorManager.black, fontSize: 18),),
        subtitle: subtitle != null ? Text('$subtitle', style: getRegularStyle(color: ColorManager.subtitleGrey, fontSize: 14),) : null,
        trailing: trailing == true ? Icon(Icons.chevron_right, color: ColorManager.iconGrey,) : null,
      ),
    );
  }



}
