


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';

import '../../../../core/resources/value_manager.dart';
import 'add_a_prescription_plan.dart';

class Prescriptions extends StatelessWidget {
  const Prescriptions({super.key});



  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text('Prescriptions',style: getMediumStyle(color: ColorManager.black),),
        elevation: 1,
        backgroundColor: ColorManager.white,
        leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.chevron_left,color: Colors.black,)),
        centerTitle:true,
        actions:[
          IconButton(
              onPressed:(){
                scaffoldKey.currentState!.openEndDrawer();
              },
              icon: Icon(Icons.menu,color: ColorManager.black,))
        ]
        
      ),
      endDrawer: Drawer(
        elevation: 1,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 12.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h20,
              h20,
              Text('More Options',style: getMediumStyle(color: ColorManager.black),),
              h20,
              Container(
                color: ColorManager.dotGrey.withOpacity(0.3),
                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                child: Row(
                  children: [
                    FaIcon(CupertinoIcons.person_2_alt,),
                    w20,
                    Text('Contact a consultant',style: getRegularStyle(color: ColorManager.black,fontSize: 20),)
                  ],
                ),
              ),
              h10,
              Container(
                color: ColorManager.dotGrey.withOpacity(0.3),
                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.pills,),
                    w20,
                    Text('Medicine Details',style: getRegularStyle(color: ColorManager.black,fontSize: 20),)
                  ],
                ),
              ),
              h10,
              Container(
                color: ColorManager.dotGrey.withOpacity(0.3),
                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                child: Row(
                  children: [
                    FaIcon(Icons.history,),
                    w20,
                    Text('Medication History',style: getRegularStyle(color: ColorManager.black,fontSize: 20),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h20,
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        ColorManager.primaryDark.withOpacity(0.9),
                        ColorManager.primaryDark.withOpacity(0.9),
                        ColorManager.primaryDark.withOpacity(0.75),
                        ColorManager.primaryDark.withOpacity(0.75),
                        ColorManager.primaryDark.withOpacity(0.6)
                      ],
                      stops: [0.0,0.65,0.65, 0.85,0.85],
                      transform: GradientRotation(0),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      tileMode: TileMode.repeated
                  ),
                  borderRadius: BorderRadius.circular(20),

                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                height:160.h,
                width: 280.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:ColorManager.white.withOpacity(0.3),
                            ),

                            padding: EdgeInsets.symmetric(vertical: 5.w,horizontal: 10.w),
                            child: FaIcon(FontAwesomeIcons.pills,color: ColorManager.white,)),
                        w10,
                        Text('Overall Medications',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?24 :isNarrowScreen?18.sp:24.sp),)
                      ],
                    ),
                    h20,
                    Text('Current medications :',style: getRegularStyle(color: ColorManager.white,fontSize: isWideScreen?18:isNarrowScreen?16.sp:18.sp),),
                    h10,
                    Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?40:isNarrowScreen?30.sp:40.sp),),

                  ],
                ),

              ),
              h20,
              h20,
              Text('Today\'s prescriptions',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
              h20,
              Container(
                decoration: BoxDecoration(
                  color: ColorManager.dotGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ColorManager.black.withOpacity(0.5)
                  )
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: ColorManager.red.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ColorManager.red.withOpacity(0.5)
                          )
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                      child: FaIcon(FontAwesomeIcons.pills,color: ColorManager.red,),
                    ),
                    w20,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Medicine 1',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                        h10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('10:30 AM',style: getRegularStyle(color: ColorManager.subtitleGrey,fontSize: 16),),
                            w10,
                            Text('|',style: getRegularStyle(color: ColorManager.subtitleGrey,fontSize: 16),),
                            w10,
                            Text('Pending',style: getRegularStyle(color: ColorManager.subtitleGrey,fontSize: 16),)
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              h20,
              Container(
                decoration: BoxDecoration(
                    color: ColorManager.dotGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: ColorManager.black.withOpacity(0.5)
                    )
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: ColorManager.blue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ColorManager.blue.withOpacity(0.5)
                          )
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                      child: FaIcon(FontAwesomeIcons.pills,color: ColorManager.blue,),
                    ),
                    w20,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Medicine 1',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                        h10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('10:30 AM',style: getRegularStyle(color: ColorManager.subtitleGrey,fontSize: 16),),
                            w10,
                            Text('|',style: getRegularStyle(color: ColorManager.subtitleGrey,fontSize: 16),),
                            w10,
                            Text('Pending',style: getRegularStyle(color: ColorManager.subtitleGrey,fontSize: 16),)
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              h20,
              Container(
                decoration: BoxDecoration(
                    color: ColorManager.dotGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: ColorManager.black.withOpacity(0.5)
                    )
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: ColorManager.primary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ColorManager.primary.withOpacity(0.5)
                          )
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                      child: FaIcon(FontAwesomeIcons.pills,color: ColorManager.primary,),
                    ),
                    w20,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Medicine 1',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                        h10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('10:30 AM',style: getRegularStyle(color: ColorManager.subtitleGrey,fontSize: 16),),
                            w10,
                            Text('|',style: getRegularStyle(color: ColorManager.subtitleGrey,fontSize: 16),),
                            w10,
                            Text('Pending',style: getRegularStyle(color: ColorManager.subtitleGrey,fontSize: 16),)
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              h20,
              Container(
                decoration: BoxDecoration(
                    color: ColorManager.dotGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: ColorManager.black.withOpacity(0.5)
                    )
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: ColorManager.orange.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ColorManager.orange.withOpacity(0.5)
                          )
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                      child: FaIcon(FontAwesomeIcons.pills,color: ColorManager.orange,),
                    ),
                    w20,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Medicine 1',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                        h10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('10:30 AM',style: getRegularStyle(color: ColorManager.subtitleGrey,fontSize: 16),),
                            w10,
                            Text('|',style: getRegularStyle(color: ColorManager.subtitleGrey,fontSize: 16),),
                            w10,
                            Text('Pending',style: getRegularStyle(color: ColorManager.subtitleGrey,fontSize: 16),)
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              h20,
              Center(child: Text('See More',style: getRegularStyle(color: ColorManager.black),)),
              h20,
              h20,
              Text('All Medications',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
              h20,
              Container(
                child: GridView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWideScreen? 5:3,
                      childAspectRatio: 3/3,
                      crossAxisSpacing: isWideScreen?16 :16.w,
                      mainAxisSpacing: isWideScreen? 12: 12.h
                  ),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorManager.primaryDark.withOpacity(0.5)
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: ColorManager.primaryDark.withOpacity(0.2)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.pills),
                          h10,
                          Text('Medicine 1')
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorManager.orange.withOpacity(0.5)
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: ColorManager.orange.withOpacity(0.2)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.pills),
                          h10,
                          Text('Medicine 1')
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorManager.blue.withOpacity(0.5)
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: ColorManager.blue.withOpacity(0.2)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.pills),
                          h10,
                          Text('Medicine 1')
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorManager.accentPink.withOpacity(0.5)
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: ColorManager.accentPink.withOpacity(0.2)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.pills),
                          h10,
                          Text('Medicine 1')
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorManager.accentCream.withOpacity(0.5)
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: ColorManager.accentCream.withOpacity(0.2)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.pills),
                          h10,
                          Text('Medicine 1')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              h100,
              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primaryDark,
        onPressed: ()=>Get.to(()=>AddPrescriptionPlan()),
        child: FaIcon(Icons.add,color: ColorManager.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
  
  
}
