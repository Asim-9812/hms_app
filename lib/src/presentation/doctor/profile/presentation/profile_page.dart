


import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/data/services/user_services.dart';
import 'package:medical_app/src/presentation/common/shimmers.dart';
import 'package:medical_app/src/presentation/doctor/profile/presentation/widgets/update_profile.dart';

import '../../../../core/api.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../login/domain/model/user.dart';

class DocProfilePage extends ConsumerWidget {

  @override
  Widget build(BuildContext context,ref) {
    final userBox = Hive.box<User>('session').values.toList();
    final user = userBox[0];
    final userInfo = ref.watch(userInfoProvider(user.userID!));

    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;
    return userInfo.when(
        data: (data){
          (data.liscenceNo);
         return  Scaffold(
             backgroundColor: ColorManager.white.withOpacity(0.99),
             appBar: AppBar(
               elevation: 1,
               backgroundColor: ColorManager.white,
               leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.chevron_left,color: Colors.black,)),
               title: Text('Profile',style: getMediumStyle(color: ColorManager.black,fontSize: isNarrowScreen? 20.sp:24),),
               centerTitle: true,


             ),
             body: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 profileBanner(context,data),
                 Container(
                   height: MediaQuery.of(context).size.height * 3.3/5,
                   child: SingleChildScrollView(
                     physics: BouncingScrollPhysics(),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [

                         h16,
                         Container(
                           padding: EdgeInsets.symmetric(horizontal: 12.w),
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Details',style: getMediumStyle(color: ColorManager.black,fontSize:isNarrowScreen?18.sp: 18),),
                               h10,
                               _profileItems(screenSize: screenSize,title: 'Phone Number', icon: FontAwesomeIcons.phone, onTap: (){},subtitle: '${data.contactNo}'),
                               _profileItems(screenSize: screenSize,title: 'E-Mail', icon: Icons.email_outlined, onTap: (){},subtitle: '${data.email}'),
                               _profileItems(screenSize: screenSize,title: 'License No.', icon: FontAwesomeIcons.idCard, onTap: (){},subtitle: '${data.liscenceNo}'),
                             ],
                           ),
                         ),
                         h20,
                         Container(
                           padding: EdgeInsets.symmetric(horizontal: 12.w),
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Education',style: getMediumStyle(color: ColorManager.black,fontSize:isNarrowScreen?18.sp: 18),),
                               h10,
                               _profileItems(screenSize: screenSize,title: 'MD, University of Medical Sciences', icon: Icons.school, onTap: (){},subtitle: '20XX'),
                               _profileItems(screenSize: screenSize,title: 'Residency in Pediatrics, Children\'s Hospital', icon: Icons.school, onTap: (){},subtitle: '20XX'),
                             ],
                           ),
                         ),
                         h20,
                         Container(
                           padding: EdgeInsets.symmetric(horizontal: 12.w),
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Experience',style: getMediumStyle(color: ColorManager.black,fontSize:isNarrowScreen?18.sp: 18),),
                               h10,
                               _profileItems(screenSize: screenSize,title: 'Pediatrician, Sunshine Pediatrics Clinic', icon: CupertinoIcons.rectangle_3_offgrid_fill, onTap: (){},subtitle: '20XX-present'),
                               _profileItems(screenSize: screenSize,title: 'Pediatric Resident, Children\'s Hospital', icon: CupertinoIcons.rectangle_3_offgrid_fill, onTap: (){},subtitle: '20XX'),
                             ],
                           ),
                         ),
                         h20,
                         Container(
                           padding: EdgeInsets.symmetric(horizontal: 12.w),
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Certifications',style: getMediumStyle(color: ColorManager.black,fontSize:isNarrowScreen?18.sp: 18),),
                               h10,
                               _profileItems(screenSize: screenSize,title: 'Board Certified Pediatrician', icon: FontAwesomeIcons.certificate, onTap: (){},subtitle: '20XX'),
                               _profileItems(screenSize: screenSize,title: 'Advanced Pediatric Life Support (APLS)', icon: FontAwesomeIcons.certificate, onTap: (){},subtitle: '20XX'),
                             ],
                           ),
                         ),
                         h20,
                         Container(
                           padding: EdgeInsets.symmetric(horizontal: 12.w),
                           child: Column(
                             mainAxisSize: MainAxisSize.min,
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Patient Reviews (152)',style: getMediumStyle(color: ColorManager.black,fontSize:isNarrowScreen?18.sp: 18),),
                               h10,
                               Container(
                                 padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                                 decoration: BoxDecoration(
                                   color: ColorManager.dotGrey.withOpacity(0.2)
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     CircleAvatar(
                                       radius: 20.r,
                                       backgroundColor: ColorManager.black,
                                       child: Icon(Icons.person,color: ColorManager.white,),
                                     ),
                                     w20,
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Row(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             for(int i = 0; i < 5;i++)
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   FaIcon(i>3?Icons.star_border:Icons.star,color: ColorManager.black,size: 16,)
                                                 ],
                                               ),
                                           ],
                                         ),
                                         h10,
                                         Text('John Doe',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                                         h10,
                                         Text('Lorem epsum whtevr i can dooo yo ',style: getRegularStyle(color: ColorManager.black,fontSize: 16),maxLines: null,overflow: TextOverflow.fade,),
                                       ],
                                     )
                                   ],
                                 ),
                               ),
                               h10,
                               Container(
                                 padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                                 decoration: BoxDecoration(
                                     color: ColorManager.dotGrey.withOpacity(0.2)
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     CircleAvatar(
                                       radius: 20.r,
                                       backgroundColor: ColorManager.black,
                                       child: Icon(Icons.person,color: ColorManager.white,),
                                     ),
                                     w20,
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Row(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             for(int i = 0; i < 5;i++)
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   FaIcon(i>3?Icons.star_border:Icons.star,color: ColorManager.black,size: 16,)
                                                 ],
                                               ),
                                           ],
                                         ),
                                         h10,
                                         Text('John Doe',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                                         h10,
                                         Text('Lorem epsum whtevr i can dooo yo ',style: getRegularStyle(color: ColorManager.black,fontSize: 16),maxLines: null,overflow: TextOverflow.fade,),
                                       ],
                                     )
                                   ],
                                 ),
                               ),
                               h10,
                               Container(
                                 padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                                 decoration: BoxDecoration(
                                     color: ColorManager.dotGrey.withOpacity(0.2)
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     CircleAvatar(
                                       radius: 20.r,
                                       backgroundColor: ColorManager.black,
                                       child: Icon(Icons.person,color: ColorManager.white,),
                                     ),
                                     w20,
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Row(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             for(int i = 0; i < 5;i++)
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   FaIcon(i>3?Icons.star_border:Icons.star,color: ColorManager.black,size: 16,)
                                                 ],
                                               ),
                                           ],
                                         ),
                                         h10,
                                         Text('John Doe',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                                         h10,
                                         Text('Lorem epsum whtevr i can dooo yo ',style: getRegularStyle(color: ColorManager.black,fontSize: 16),maxLines: null,overflow: TextOverflow.fade,),
                                       ],
                                     )
                                   ],
                                 ),
                               ),
                               h10,
                               Container(
                                 padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                                 decoration: BoxDecoration(
                                     color: ColorManager.dotGrey.withOpacity(0.2)
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     CircleAvatar(
                                       radius: 20.r,
                                       backgroundColor: ColorManager.black,
                                       child: Icon(Icons.person,color: ColorManager.white,),
                                     ),
                                     w20,
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Row(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             for(int i = 0; i < 5;i++)
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   FaIcon(i>3?Icons.star_border:Icons.star,color: ColorManager.black,size: 16,)
                                                 ],
                                               ),
                                           ],
                                         ),
                                         h10,
                                         Text('John Doe',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                                         h10,
                                         Text('Lorem epsum whtevr i can dooo yo ',style: getRegularStyle(color: ColorManager.black,fontSize: 16),maxLines: null,overflow: TextOverflow.fade,),
                                       ],
                                     )
                                   ],
                                 ),
                               ),
                               h10,

                             ],
                           ),
                         ),

                         h20,
                         h20,
                         h20,




                       ],
                     ),
                   ),
                 ),
               ],
             )


         );
        },
        error: (error,stack)=>Center(child: Text('$error')),
        loading: ()=>ProfileShimmer()
    );

  }

  /// Profile...

  Widget profileBanner(BuildContext context,User user) {
    final screenSize = MediaQuery.of(context).size;
    String? userGender;

    ImageProvider<Object>? profileImage;
    if (user.profileImage == null) {
      profileImage = AssetImage('assets/icons/user.png');
    } else {
      profileImage = NetworkImage('${Api.baseUrl}/${user.profileImage}');
    }

    if(user.genderID != null ){
      if(user.genderID == 1){
        userGender = 'Male';
      } else if(user.genderID == 2){
        userGender = 'Female';
      } else{
        userGender ='Others';
      }
    } else{
      userGender = 'Others';
    }


    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 420;
    return Card(
      elevation: 3,
      shadowColor: ColorManager.textGrey.withOpacity(0.4),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9/4,
        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical:12.h),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 120.h,
                decoration: BoxDecoration(
                    image: DecorationImage(image:AssetImage('assets/images/containers/Tip-Container-3.png'),fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)
                    )
                ),
              ) ,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Card(
                    shape: CircleBorder(),
                    elevation: 5,
                    child: CircleAvatar(
                      backgroundColor: ColorManager.white,
                      radius: isNarrowScreen? 50.r:50,
                      child: CircleAvatar(
                        backgroundImage: profileImage,
                        backgroundColor: ColorManager.white,
                        radius: isNarrowScreen? 45.r:45,
                      ),
                    ),
                  ),
                  w10,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${user.firstName} ${user.lastName}',style: getMediumStyle(color: ColorManager.black,fontSize: isNarrowScreen? 32.sp:32),),
                      h10,
                      Text('Specialization',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isNarrowScreen?18.sp:18),),
                    ],
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child:  Padding(
                padding:EdgeInsets.only(bottom: 20),
                child: InkWell(
                    onTap: ()=>Get.to(()=>UpdateDocProfile(isWideScreen, isNarrowScreen,user )),
                    child: FaIcon(FontAwesomeIcons.penToSquare,color: ColorManager.primary,)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Profile items func & ui ...

  Widget _profileItems({
    VoidCallback? onTap,
    required String title,
    required IconData icon,
    String? subtitle,
    bool? trailing,
    required Size screenSize

  }) {

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 420;
    if(trailing == null){
      trailing = false;
    }
    return ListTile(
      tileColor: ColorManager.dotGrey.withOpacity(0.2),
      onTap: onTap,
      splashColor: ColorManager.textGrey.withOpacity(0.2),
      leading: FaIcon(icon,size: isNarrowScreen?24.sp:24,),
      title: Text('$title',style:getRegularStyle(color: ColorManager.black,fontSize:isNarrowScreen?20.sp:20 ),),
      subtitle: subtitle != null? Text('$subtitle',style:getRegularStyle(color: ColorManager.subtitleGrey,fontSize:isNarrowScreen?16.sp:16 ),):null,
      trailing: trailing == true? Icon(Icons.chevron_right,color: ColorManager.iconGrey,):null ,
    );
  }

}
