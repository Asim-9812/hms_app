


import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';

import '../../../../core/resources/value_manager.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;
    return Scaffold(
      backgroundColor: ColorManager.white.withOpacity(0.99),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorManager.white,
        leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.chevron_left,color: Colors.black,)),
        title: Text('Profile',style: getMediumStyle(color: ColorManager.black,fontSize: isNarrowScreen? 24.sp:28),),


      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeIn(
              duration: Duration(milliseconds: 500),
              child: profileBanner(context)),
          Container(
            height: MediaQuery.of(context).size.height * 3/5,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: FadeInUp(
                duration: Duration(milliseconds: 700),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    h20,
                    _patientStat(context),
                    h16,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Details',style: getMediumStyle(color: ColorManager.black,fontSize:isNarrowScreen?24.sp: 24),),
                              w10,
                              Container(
                                width: isNarrowScreen? 220.w: 320.w,
                                child: Divider(
                                  thickness: 0.5,
                                  color: ColorManager.black,
                                ),

                              )
                            ],
                          ),
                          h10,
                          _profileItems(screenSize: screenSize,title: 'Phone Number', icon: FontAwesomeIcons.phone, onTap: (){},subtitle: '98XXXXXXXX'),
                          _profileItems(screenSize: screenSize,title: 'E-Mail', icon: Icons.email_outlined, onTap: (){},subtitle: 'user@gmail.com'),
                          _profileItems(screenSize: screenSize,title: 'Other Details', icon: FontAwesomeIcons.idCard, onTap: (){},trailing: true),
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
                          Row(
                            children: [
                              Text('Reminders',style: getMediumStyle(color: ColorManager.black,fontSize:isNarrowScreen?24.sp: 24),),
                              w10,
                              Container(
                                width: isNarrowScreen? 220.w: 280.w,
                                child: Divider(
                                  thickness: 0.5,
                                  color: ColorManager.black,
                                ),

                              )
                            ],
                          ),
                          h10,
                          _profileItems(screenSize: screenSize,title: 'Medicine', icon: FontAwesomeIcons.pills, onTap: (){},trailing: true),
                          _profileItems(screenSize: screenSize,title: 'Appointments', icon: Icons.assignment_turned_in_outlined, onTap: (){},trailing: true),
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
                          Row(
                            children: [
                              Text('Medical Records',style: getMediumStyle(color: ColorManager.black,fontSize:isNarrowScreen?24.sp: 24),),
                              w10,
                              Container(
                                width: isNarrowScreen? 130.w: 240.w,
                                child: Divider(
                                  thickness: 0.5,
                                  color: ColorManager.black,
                                ),

                              )
                            ],
                          ),
                          h10,
                          _profileItems(screenSize: screenSize,title: 'Medical History', icon: FontAwesomeIcons.history, onTap: (){},trailing: true),
                          _profileItems(screenSize: screenSize,title: 'Transaction History', icon: Icons.receipt_long, onTap: (){},trailing: true),
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
          ),
        ],
      ),
    );
  }

  _patientStat(BuildContext context){
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                    color: ColorManager.red.withOpacity(0.15)
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 18.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(FontAwesomeIcons.heartPulse,color: ColorManager.red.withOpacity(0.5),size: isNarrowScreen? 20.sp:24,),
                        w10,
                        Text('Heart Rate',style: getRegularStyle(color: ColorManager.black,fontSize: isNarrowScreen? 18.sp:20),)
                      ],
                    ),
                    h10,
                    Text('120 bpm',style: getMediumStyle(color: ColorManager.black,fontSize: isNarrowScreen? 20.sp:24),),
                    h20,
                    Text('2023-08-09',style: getRegularStyle(color: ColorManager.black,fontSize:  isNarrowScreen? 16.sp:16),)
                  ],

                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width*.45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                    color: ColorManager.primary.withOpacity(0.15)
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 18.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(FontAwesomeIcons.heartCircleBolt,color: ColorManager.primaryDark.withOpacity(0.5),size: isNarrowScreen? 20.sp:24,),
                        w10,
                        Text('Blood Pressure',style: getRegularStyle(color: ColorManager.black,fontSize: isNarrowScreen? 18.sp:20),)
                      ],
                    ),
                    h10,
                    Text('120/80 mmHg',style: getMediumStyle(color: ColorManager.black,fontSize: isNarrowScreen? 20.sp:24),),
                    h20,
                    Text('2023-08-09',style: getRegularStyle(color: ColorManager.black,fontSize: isNarrowScreen? 16.sp:16),)
                  ],

                ),
              ),
            ],
          ),
        ),
        h20,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*.45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                    color: ColorManager.blue.withOpacity(0.15)
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 18.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(CupertinoIcons.graph_circle_fill,color: ColorManager.blue.withOpacity(0.5),size: isNarrowScreen? 20.sp:24,),
                        w10,
                        Text('Cholesterol',style: getRegularStyle(color: ColorManager.black,fontSize: isNarrowScreen? 18.sp:20),)
                      ],
                    ),
                    h10,
                    Text('97 mg/dl',style: getMediumStyle(color: ColorManager.black,fontSize: isNarrowScreen? 20.sp:24),),
                    h20,
                    Text('2023-08-09',style: getRegularStyle(color: ColorManager.black,fontSize:  isNarrowScreen? 16.sp:16),)
                  ],

                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width*.45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                    color: ColorManager.orange.withOpacity(0.15)
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 18.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(FontAwesomeIcons.heartCircleCheck,color: ColorManager.orange.withOpacity(0.5),size: isNarrowScreen? 20.sp:24,),
                        w10,
                        Text('Sugar',style: getRegularStyle(color: ColorManager.black,fontSize: isNarrowScreen? 18.sp:20),)
                      ],
                    ),
                    h10,
                    Text('90 mg/dl',style: getMediumStyle(color: ColorManager.black,fontSize:isNarrowScreen? 20.sp:24),),
                    h20,
                    Text('2023-08-09',style: getRegularStyle(color: ColorManager.black,fontSize: isNarrowScreen? 16.sp:16),)
                  ],

                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  /// Profile...
  
  Widget profileBanner(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 420;





    return Card(
      elevation: 3,
      shadowColor: ColorManager.textGrey.withOpacity(0.4),
      child: Container(
        height: MediaQuery.of(context).size.height * 1/4,
        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical:12.h),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 120.h,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/containers/Tip-Container-3.png'),fit: BoxFit.cover),
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
                        backgroundColor: ColorManager.black,
                        radius: isNarrowScreen? 45.r:45,
                        child: FaIcon(FontAwesomeIcons.person,color: ColorManager.white,),
                      ),
                    ),
                  ),
                  w10,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User',style: getMediumStyle(color: ColorManager.black,fontSize: isNarrowScreen? 32.sp:32),),
                      h10,
                      Row(
                        children: [
                          Text('Gender',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isNarrowScreen?16.sp:16),),
                          w10,
                          Text('|',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isNarrowScreen?12.sp:12),),
                          w10,
                          Text('23 yrs',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isNarrowScreen?16.sp:16),),
                          w10,
                          Text('|',style: getRegularStyle(color: ColorManager.textGrey,fontSize:isNarrowScreen?12.sp: 12),),
                          w10,
                          Text('Address',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isNarrowScreen?16.sp:16),),
                        ],
                      )
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
                    onTap: (){},
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
      onTap: onTap,
      splashColor: ColorManager.textGrey.withOpacity(0.2),
      leading: FaIcon(icon,size: isNarrowScreen?24.sp:24,),
      title: Text('$title',style:getRegularStyle(color: ColorManager.black,fontSize:isNarrowScreen?20.sp:20 ),),
      subtitle: subtitle != null? Text('$subtitle',style:getRegularStyle(color: ColorManager.subtitleGrey,fontSize:isNarrowScreen?16.sp:16 ),):null,
      trailing: trailing == true? Icon(Icons.chevron_right,color: ColorManager.iconGrey,):null ,
    );
  }
  
}
