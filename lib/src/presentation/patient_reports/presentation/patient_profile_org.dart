

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';

import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';


class PatientProfileOrg extends StatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  PatientProfileOrg(this.isWideScreen,this.isNarrowScreen);


  @override
  State<PatientProfileOrg> createState() => _PatientProfileOrgState();
}

class _PatientProfileOrgState extends State<PatientProfileOrg> {
  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.primaryDark.withOpacity(0.5),
          title: Text('Patient Profile',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),

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
                              Text('Details',style: getMediumStyle(color: ColorManager.black,fontSize:widget.isNarrowScreen?24.sp: 24),),
                              w10,
                              Container(
                                width: widget.isNarrowScreen? 220.w: 320.w,
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
                              Text('Medical Records',style: getMediumStyle(color: ColorManager.black,fontSize:widget.isNarrowScreen?24.sp: 24),),
                              w10,
                              Container(
                                width: widget.isNarrowScreen? 130.w: 240.w,
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
                      radius: widget.isNarrowScreen? 50.r:50,
                      child: CircleAvatar(
                        backgroundColor: ColorManager.black,
                        radius: widget.isNarrowScreen? 45.r:45,
                        child: FaIcon(FontAwesomeIcons.person,color: ColorManager.white,),
                      ),
                    ),
                  ),
                  w10,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen? 32.sp:32),),
                      h10,
                      Row(
                        children: [
                          Text('Gender',style: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?16.sp:16),),
                          w10,
                          Text('|',style: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?12.sp:12),),
                          w10,
                          Text('23 yrs',style: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?16.sp:16),),
                          w10,
                          Text('|',style: getRegularStyle(color: ColorManager.textGrey,fontSize:widget.isNarrowScreen?12.sp: 12),),
                          w10,
                          Text('Address',style: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?16.sp:16),),
                        ],
                      )
                    ],
                  )
                ],
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
      leading: FaIcon(icon,size: widget.isNarrowScreen?24.sp:24,),
      title: Text('$title',style:getRegularStyle(color: ColorManager.black,fontSize:widget.isNarrowScreen?20.sp:20 ),),
      subtitle: subtitle != null? Text('$subtitle',style:getRegularStyle(color: ColorManager.subtitleGrey,fontSize:widget.isNarrowScreen?16.sp:16 ),):null,
      trailing: trailing == true? Icon(Icons.chevron_right,color: ColorManager.iconGrey,):null ,
    );
  }
}
