



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/presentation/organization/charts_graphs/doctor_charts.dart';
import 'package:meroupachar/src/presentation/organization/doctor_statistics/presentation/operation_tbl.dart';

import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';

class DoctorReportsPage extends StatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  DoctorReportsPage(this.isWideScreen,this.isNarrowScreen);

  @override
  State<DoctorReportsPage> createState() => _DoctorReportsPageState();
}

class _DoctorReportsPageState extends State<DoctorReportsPage> with TickerProviderStateMixin{
  
  bool _isExpanded = false;
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        centerTitle: true,
        title: Text('Doctors',style: getMediumStyle(color: ColorManager.white,fontSize: 24),),

      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


           _tabBar(),
            h100,
          ],
        ),
      )
    );
  }


  // Widget _overallStat() {
  //
  //   return Container(
  //     height: widget.isWideScreen? 220:200,
  //     width: double.infinity,
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       physics: BouncingScrollPhysics(),
  //       shrinkWrap: true,
  //       children: [
  //         widget.isNarrowScreen?w10:w18,
  //         Container(
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //                 colors: [
  //                   ColorManager.primary,
  //                   ColorManager.primary,
  //                   ColorManager.primary.withOpacity(0.9),
  //                   ColorManager.primary.withOpacity(0.9),
  //                   ColorManager.primary.withOpacity(0.8),
  //                   ColorManager.primary.withOpacity(0.8),
  //                   ColorManager.primary.withOpacity(0.7)
  //                 ],
  //                 stops: [0.0,0.65,0.65,0.75,0.75, 0.85,0.85],
  //                 transform: GradientRotation(5),
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //                 tileMode: TileMode.repeated
  //             ),
  //             borderRadius: BorderRadius.circular(20),
  //
  //           ),
  //           margin: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
  //           padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
  //           height:widget.isWideScreen?200:160.h,
  //           width: 280.w,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10),
  //                         color:ColorManager.white.withOpacity(0.3),
  //                       ),
  //
  //                       padding: EdgeInsets.symmetric(vertical: 5.w,horizontal: 10.w),
  //                       child: FaIcon(Icons.health_and_safety,color: ColorManager.white,)),
  //                   w10,
  //                   Text('Doctors',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
  //                 ],
  //               ),
  //               h20,
  //               Text('Available Doctors:',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
  //               h10,
  //               Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
  //               h10,
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   Text('Total Doctors :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
  //                   w10,
  //                   Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
  //                 ],
  //               ),
  //
  //             ],
  //           ),
  //
  //         ),
  //         Container(
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //                 colors: [
  //                   ColorManager.primary.withOpacity(0.8),
  //                   ColorManager.primary.withOpacity(0.8),
  //                   ColorManager.primary.withOpacity(0.7),
  //                   ColorManager.primary.withOpacity(0.7),
  //                   ColorManager.primary.withOpacity(0.6),
  //                   ColorManager.primary.withOpacity(0.6),
  //                   ColorManager.primary.withOpacity(0.5)
  //                 ],
  //                 stops: [0.0,0.6,0.6, 0.7,0.7,0.8,0.8],
  //                 transform: GradientRotation(6),
  //                 begin: Alignment.centerLeft,
  //                 end: Alignment.centerRight,
  //                 tileMode: TileMode.mirror
  //             ),
  //             borderRadius: BorderRadius.circular(20),
  //
  //           ),
  //           margin: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
  //           padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
  //           height:160.h,
  //           width: 280.w,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10),
  //                         color:ColorManager.white.withOpacity(0.3),
  //                       ),
  //
  //                       padding: EdgeInsets.symmetric(vertical: 5.w,horizontal: 10.w),
  //                       child: FaIcon(FontAwesomeIcons.notesMedical,color: ColorManager.white,)),
  //                   w10,
  //                   Text('Appointments',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
  //                 ],
  //               ),
  //               h20,
  //               Text('Appointments :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
  //               h10,
  //               Text('100',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
  //               h10,
  //               Text('Last 7 days',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
  //
  //             ],
  //           ),
  //
  //         ),
  //         Container(
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //                 colors: [
  //                   ColorManager.orange,
  //                   ColorManager.orange,
  //                   ColorManager.orange.withOpacity(0.8),
  //                   ColorManager.orange.withOpacity(0.8),
  //                   ColorManager.orange.withOpacity(0.7),
  //                   ColorManager.orange.withOpacity(0.7),
  //                   ColorManager.orange.withOpacity(0.6)
  //                 ],
  //                 stops: [0.0,0.65,0.65,0.75,0.75, 0.85,0.85],
  //                 transform: GradientRotation(1),
  //                 begin: Alignment.centerLeft,
  //                 end: Alignment.centerRight,
  //                 tileMode: TileMode.repeated
  //             ),
  //             borderRadius: BorderRadius.circular(20),
  //
  //           ),
  //           margin: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
  //           padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
  //           height:160.h,
  //           width: 280.w,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(10),
  //                         color:ColorManager.white.withOpacity(0.3),
  //                       ),
  //
  //                       padding: EdgeInsets.symmetric(vertical: 8.w,horizontal: 10.w),
  //                       child: FaIcon(FontAwesomeIcons.bedPulse,color: ColorManager.white,size: 20,)),
  //                   w10,
  //                   Text('Surgical Stats',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
  //                 ],
  //               ),
  //               h20,
  //               Text('Total Operations :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
  //               h10,
  //               Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
  //               h10,
  //               Text('Last 7 days',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
  //
  //             ],
  //           ),
  //
  //         ),
  //
  //
  //       ],
  //     ),
  //   );
  // }
  


  Widget _tabBar(){
    TabController _tabBarController = TabController(length: 2, vsync: this);
    return  Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            color: ColorManager.dotGrey.withOpacity(0.2),
            // borderRadius: BorderRadius.only(
            //   topRight: Radius.circular(10),
            //   topLeft: Radius.circular(10)
            // )

          ),
          child: TabBar(
            dividerColor: Colors.transparent,
              controller: _tabBarController,
              padding: EdgeInsets.symmetric(
                  vertical: 8.h, horizontal: 8.w),
              labelStyle: getMediumStyle(
                  color: ColorManager.white,
                  fontSize: 18
              ),
              unselectedLabelStyle: getMediumStyle(
                  color: ColorManager.textGrey,
                  fontSize: 18
              ),
              isScrollable: false,
              labelPadding: EdgeInsets.only(left: 15.w, right: 15.w),
              labelColor: ColorManager.white,

              unselectedLabelColor: ColorManager.textGrey,
              // indicatorColor: primary,
              indicator: BoxDecoration(
                  color: ColorManager.primary,
                  borderRadius: BorderRadius.circular(15)),
              tabs: [
                Container(
                  width: double.infinity,
                  child: Tab(
                    text: 'Appointments',
                  ),
                ),
                Container(
                    width: double.infinity,
                    child: Tab(text: 'Operations')),
              ]),
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabBarController,
            children: [
              OperationTable(),
              OperationTable(),

            ]
          ),
        )
      ],
    );
  }
  
}
