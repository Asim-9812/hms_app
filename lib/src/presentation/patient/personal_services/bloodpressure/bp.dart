


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/presentation/doctor/patient_profile/presentation/medical_charts.dart';
import 'package:medical_app/src/presentation/patient/personal_services/sugar/sugar_graphs.dart';
import 'package:medical_app/src/presentation/patient/personal_services/sugar/sugar_test_details.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/resources/value_manager.dart';
import '../../../../dummy_datas/dummy_datas.dart';
import '../mri/mri_details.dart';
import 'bp_details.dart';

class BP extends StatefulWidget {
  const BP({super.key});

  @override
  State<BP> createState() => _BPState();
}

class _BPState extends State<BP> {

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {

    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    (screenSize);

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;

    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 1,
        title: Text('BP',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
        iconTheme: IconThemeData(
          color: ColorManager.black
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
                        ColorManager.primary,
                        ColorManager.primary,
                        ColorManager.primary.withOpacity(0.9),
                        ColorManager.primary.withOpacity(0.9),
                        ColorManager.primary.withOpacity(0.8),
                        ColorManager.primary.withOpacity(0.8),
                        ColorManager.primary.withOpacity(0.7)
                      ],
                      stops: [0.0,0.65,0.65,0.75,0.75, 0.85,0.85],
                      transform: GradientRotation(5),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      tileMode: TileMode.repeated
                  ),
                  borderRadius: BorderRadius.circular(20),

                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                height:200.h,
                width: double.infinity,
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
                            child: FaIcon(Icons.health_and_safety,color: ColorManager.white,)),
                        w10,
                        Text('Blood Pressure Levels',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?24 :isNarrowScreen?18.sp:24.sp),)
                      ],
                    ),
                    h20,
                    Text('Latest Record:',style: getRegularStyle(color: ColorManager.white,fontSize: isWideScreen?18:isNarrowScreen?16.sp:18.sp),),
                    h10,
                    Text('Systolic Blood Pressure (SBP): 130 mmHg',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?18:isNarrowScreen?16.sp:18.sp),),
                    h10,
                    Text('Diastolic Blood Pressure (DBP): 85 mmHg',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?18:isNarrowScreen?16.sp:18.sp),),
                    h20,

                    Text('Recorded date: 2080-09-15',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?18:isNarrowScreen?16.sp:18.sp),),
                    h10,

                  ],
                ),

              ),

              h20,

              Container(
                decoration: BoxDecoration(
                    color: ColorManager.primaryDark,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: ColorManager.black.withOpacity(0.5)
                    )
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: ExpansionPanelList(
                    expandIconColor: ColorManager.primaryDark,
                    elevation: 0,
                    expandedHeaderPadding: EdgeInsets.zero,
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _isExpanded = !_isExpanded; // Toggle the expansion state
                      });
                    },
                    children: [
                      ExpansionPanel(
                        isExpanded: _isExpanded,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            onTap: () {
                              setState(() {
                                _isExpanded =
                                !_isExpanded; // Toggle the expansion state
                              });
                            },
                            title: Text('BP Levels', style: getMediumStyle(
                                color: ColorManager.black, fontSize: 20)),
                          ); // Empty header, handled above
                        },
                        body: Container(
                            width: double.infinity,
                            height: 450,
                            child: BPChart()
                        ),
                      ),

                    ]


                ),
              ),
              
              h20,
              h20,
              h20,
              
              Row(
                children: [
                  FaIcon(Icons.history,color: ColorManager.black,),
                  w10,
                  Text('Test History',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
                ],
              ),
              h20,
              ListTile(
                onTap: ()=>Get.to(()=>BPDetails()),
                tileColor: ColorManager.dotGrey.withOpacity(0.2),
                title: Text('2023-08-09',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                trailing: FaIcon(Icons.chevron_right,color: ColorManager.black,),
              ),
              h10,
              ListTile(
                onTap: ()=>Get.to(()=>BPDetails()),
                tileColor: ColorManager.dotGrey.withOpacity(0.2),
                title: Text('2023-08-09',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                trailing: FaIcon(Icons.chevron_right,color: ColorManager.black,),
              ),
              h10,
              ListTile(
                onTap: ()=>Get.to(()=>BPDetails()),
                tileColor: ColorManager.dotGrey.withOpacity(0.2),
                title: Text('2023-08-09',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                trailing: FaIcon(Icons.chevron_right,color: ColorManager.black,),
              ),
              h10,
              ListTile(
                onTap: ()=>Get.to(()=>BPDetails()),
                tileColor: ColorManager.dotGrey.withOpacity(0.2),
                title: Text('2023-08-09',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                trailing: FaIcon(Icons.chevron_right,color: ColorManager.black,),
              ),
              h10,
              ListTile(
                onTap: ()=>Get.to(()=>BPDetails()),
                tileColor: ColorManager.dotGrey.withOpacity(0.2),
                title: Text('2023-08-09',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                trailing: FaIcon(Icons.chevron_right,color: ColorManager.black,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
