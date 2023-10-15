

import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/dummy_datas/dummy_datas.dart';
import 'package:medical_app/src/presentation/doctor/profile/presentation/profile_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/resources/value_manager.dart';
import '../../../login/domain/model/user.dart';
import '../../../notices/presentation/notices.dart';
import '../../../notification/presentation/notification_page.dart';
import '../../patient_profile/presentation/doctor_patient_profile_page.dart';


class DoctorHomePage extends StatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  final bool noticeBool;
  DoctorHomePage(this.isWideScreen,this.isNarrowScreen,this.noticeBool);

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> myCircle = [{
    "name": "Add a member",
    "specializeIn": "",
  },...closeCircle];

  List<Map<String, dynamic>> myPatients = patientList;

  int currentPage = 0;
  final int rowsPerPage = 5;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(widget.noticeBool){
      // Schedule the _showAlertDialog method to be called after the build is complete.
      Future.delayed(Duration.zero, () {
        showAlertDialog(context);
      });
    }

  }




  @override
  Widget build(BuildContext context) {

    final userBox = Hive.box<User>('session').values.toList();
    String firstName = userBox[0].firstName!;
    return FadeIn(
      delay: Duration(milliseconds: 200),
      duration: Duration(milliseconds: 500),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: ColorManager.white,
          endDrawerEnableOpenDragGesture: false,

          appBar: AppBar(
              backgroundColor: ColorManager.primaryDark,
              elevation: 0,
              toolbarHeight: 120,
              centerTitle: true,
              titleSpacing: 0,
              title: Container(
                width: double.infinity,
                height: 120,
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/ban2.png'),fit: BoxFit.fitWidth)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorManager.black,
                      radius:30,
                      child: FaIcon(FontAwesomeIcons.person,color: ColorManager.white,),
                    ),
                    w10,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('Welcome,',style: getRegularStyle(color: ColorManager.white,fontSize: 16),),

                        Text('$firstName',style: getMediumStyle(color: ColorManager.white,fontSize: 28),),
                      ],
                    ),
                  ],
                ),
              )
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // InkWell(
                //   // onTap: ()=>Get.to(()=>SearchNearByPage(),transition: Transition.fadeIn),
                //   splashColor: ColorManager.primary.withOpacity(0.4),
                //   child: Center(
                //     child: Container(
                //         height: 50.h,
                //         width: 390.w,
                //         padding: EdgeInsets.symmetric(horizontal: 18.w),
                //         decoration: BoxDecoration(
                //             color: ColorManager.searchColor.withOpacity(0.15),
                //             borderRadius: BorderRadius.circular(20),
                //             border: Border.all(
                //                 color:ColorManager.searchColor,
                //                 width: 1
                //             )
                //         ),
                //         child: Row(
                //           mainAxisSize: MainAxisSize.max,
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Row(
                //               children: [
                //                 Icon(Icons.search,color: ColorManager.iconGrey,),
                //                 w10,
                //                 Text('Search medical...',style: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?15.sp:15),),
                //               ],
                //             ),
                //             SizedBox()
                //           ],
                //         )
                //     ),
                //   ),
                // ),
                h20,
                _overallStat(),
                h20,
                _patientGraph(),

                h20,
                _myTasks(),

                h20,
                _myAppointments(),

                h20,
                h20,
                _myCircle(),
                h20,
                h20,

                h100,
              ],

            ),
          )
      ),
    );
  }


  Widget _overallStat() {

    return Container(
      height: widget.isWideScreen? 240:180,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          widget.isNarrowScreen?w10:w18,
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    ColorManager.blue,
                    ColorManager.blue,
                    ColorManager.blue.withOpacity(0.9),
                    ColorManager.blue.withOpacity(0.9),
                    ColorManager.blue.withOpacity(0.8),
                    ColorManager.blue.withOpacity(0.8),
                    ColorManager.blue.withOpacity(0.7)
                  ],
                  stops: [0.0,0.65,0.65,0.75,0.75, 0.85,0.85],
                  transform: GradientRotation(5),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.repeated
              ),
              borderRadius: BorderRadius.circular(20),

            ),
            margin: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
            height:widget.isWideScreen?240:160.h,
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
                        child: FaIcon(Icons.person,color: ColorManager.white,)),
                    w10,
                    Text('Patients',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
                  ],
                ),
                h20,
                Text('Total Patients:',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
                h10,
                Text('100',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
                h10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('New Patients :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
                        w10,
                        Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?30:widget.isNarrowScreen?20.sp:30.sp),),
                      ],
                    ),
                    h10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Follow ups :',style: getRegularStyle(color: ColorManager.white,fontSize:widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
                        w10,
                        Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?30:widget.isNarrowScreen?20.sp:30.sp),),
                      ],
                    ),
                  ],
                ),

              ],
            ),

          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    ColorManager.primary.withOpacity(0.8),
                    ColorManager.primary.withOpacity(0.8),
                    ColorManager.primary.withOpacity(0.7),
                    ColorManager.primary.withOpacity(0.7),
                    ColorManager.primary.withOpacity(0.6),
                    ColorManager.primary.withOpacity(0.6),
                    ColorManager.primary.withOpacity(0.5)
                  ],
                  stops: [0.0,0.6,0.6, 0.7,0.7,0.8,0.8],
                  transform: GradientRotation(6),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  tileMode: TileMode.mirror
              ),
              borderRadius: BorderRadius.circular(20),

            ),
            margin: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
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
                        child: FaIcon(FontAwesomeIcons.notesMedical,color: ColorManager.white,)),
                    w10,
                    Text('Appointments',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
                  ],
                ),
                h20,
                Text('Appointments :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
                h10,
                Text('100',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
                h10,
                Text('Last 7 days',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),

              ],
            ),

          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    ColorManager.orange,
                    ColorManager.orange,
                    ColorManager.orange.withOpacity(0.8),
                    ColorManager.orange.withOpacity(0.8),
                    ColorManager.orange.withOpacity(0.7),
                    ColorManager.orange.withOpacity(0.7),
                    ColorManager.orange.withOpacity(0.6)
                  ],
                  stops: [0.0,0.65,0.65,0.75,0.75, 0.85,0.85],
                  transform: GradientRotation(1),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  tileMode: TileMode.repeated
              ),
              borderRadius: BorderRadius.circular(20),

            ),
            margin: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
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

                        padding: EdgeInsets.symmetric(vertical: 8.w,horizontal: 10.w),
                        child: FaIcon(FontAwesomeIcons.globe,color: ColorManager.white,size: 20,)),
                    w10,
                    Text('Online Stats',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
                  ],
                ),
                h20,
                Text('Online Consultation :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
                h10,
                Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
                h10,
                Text('Last 7 days',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),

              ],
            ),

          ),


        ],
      ),
    );
  }


  Widget _myCircle(){
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8),
            width: double.infinity,
            decoration: BoxDecoration(
                // color: ColorManager.orange.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                // border:Border.all(
                //     color: ColorManager.black.withOpacity(0.4)
                // )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('My Circle',style: getMediumStyle(color: ColorManager.black,fontSize: 18),),
                InkWell(
                  onTap: (){},
                  child: Text('See more',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                ),
              ],
            ),

          ),
          Container(
              height: 180,
              width: double.infinity,
              child: ListView.builder(
                itemCount:7,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemBuilder: (context , i){
                  return InkWell(
                    onTap: (){},
                        //()=>Get.to(()=>DocProfilePage()),
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorManager.dotGrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: i==0?Colors.transparent: ColorManager.black,
                            radius: 30.r,
                            child: i ==0? Icon(Icons.person_add,color: Colors.grey,size: 40,):Icon(Icons.person,color: ColorManager.white,),
                          ),
                          h20,
                          Text('${myCircle[i]['name']}',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                          h10,
                          Text('${myCircle[i]['specializeIn']}',style: getRegularStyle(color: ColorManager.black,fontSize: 12),)

                        ],
                      ),
                    ),
                  );
                },
              )

          ),

        ],
      ),
    );
  }


  Widget _patientGraph(){
    return Container(
      height: 300.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorManager.black.withOpacity(0.5)
        )
      ),
      child: SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          zoomMode: ZoomMode.xy,
        ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.top
        ),
        title: ChartTitle(text: 'Patient Stats',alignment:ChartAlignment.near ),
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          LineSeries<Map<String, dynamic>, String>(
            dataSource: newPatientsData,
            xValueMapper: (Map<String, dynamic> data, _) => data['date']!,
            yValueMapper: (Map<String, dynamic> data, _) => double.parse(data['total']!.toString()),
            name: 'New Patients',
          ),
          LineSeries<Map<String, dynamic>, String>(
            dataSource: followUpsData,
            xValueMapper: (Map<String, dynamic> data, _) => data['date']!,
            yValueMapper: (Map<String, dynamic> data, _) => double.parse(data['total']!.toString()),
            name: 'Follow-ups',
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }


  Widget _myTasks(){
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 8),
            width: double.infinity,
            decoration: BoxDecoration(
                color: ColorManager.primary.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('My Tasks',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                FaIcon(Icons.add,color: ColorManager.white,),
              ],
            ),

          ),
          Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for(int i = 0; i < 3; i++)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                      decoration:BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: ColorManager.black.withOpacity(0.5),
                                width: 0.5
                            ),
                            right: BorderSide(
                                color: ColorManager.black.withOpacity(0.5),
                                width: 0.5
                            ),
                            left: BorderSide(
                                color: ColorManager.black.withOpacity(0.5),
                                width: 0.5
                            ),
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('${i+1}.',style: getRegularStyle(color: ColorManager.black),),
                              w10,
                              Container(
                                  width: widget.isNarrowScreen?150: widget.isWideScreen? 275:200,
                                  child: Text('${dummyTasks[i]}',style: getRegularStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?16.sp:16),)),
                              w10,
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: i%2==0?ColorManager.red.withOpacity(0.4):ColorManager.primary.withOpacity(0.4),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h),
                                  child: Text(i%2==0?'High':'Low',style: getRegularStyle(color: ColorManager.black,fontSize:  widget.isNarrowScreen?16.sp:16))),
                            ],
                          ),
                          Text('2080-08-09',style: getRegularStyle(color: ColorManager.black,fontSize: 12),),


                        ],
                      ),
                    )
                ],
              )

          ),
          InkWell(
            onTap: (){},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                border: Border.all(
                  color: ColorManager.black.withOpacity(0.5),

                ),
              ),
              child: Center(
                child: Text('See more', style: getMediumStyle(color: ColorManager.black, fontSize: 16)),
              ),
            )

          ),
        ],
      ),
    );
  }


  Widget _myAppointments(){
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isExtraWide = screenSize.width > 1000;
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
                color: ColorManager.blue.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
            ),
            child: Text('My Appointments',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),

          ),
          Container(
              decoration: BoxDecoration(
                  border: Border.symmetric(
                      vertical: BorderSide(
                          color: ColorManager.black.withOpacity(0.4)
                      )
                  )
              ),
              width: double.infinity,
              child: Column(
                children: [
                  for(int i = 0; i< 5;i++)
                    Column(
                      children: [
                        Container(
                          color: ColorManager.dotGrey.withOpacity(0.1),
                          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                          height: 120.h,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration:BoxDecoration(
                                    color: ColorManager.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: ColorManager.black.withOpacity(0.5),
                                        width: 0.5
                                    )
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 8.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('25',style: getMediumStyle(color: ColorManager.black,fontSize: isExtraWide?18:widget.isNarrowScreen?18.sp:24),),
                                    h10,
                                    Text('wed',style: getMediumStyle(color: ColorManager.black,fontSize: isExtraWide?14:widget.isNarrowScreen?14.sp:18),)
                                  ],
                                ),
                              ),
                              w10,
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: ColorManager.blue.withOpacity(0.4),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h),
                                            child: Text('10:${40+(i*2)} am',style: getRegularStyle(color: ColorManager.blueText,fontSize: isExtraWide?12:widget.isNarrowScreen?14.sp:16),)),
                                        h16,
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${appointments[i]['appointmentTitle']}',style: getMediumStyle(color: ColorManager.black,fontSize: isExtraWide?16:widget.isNarrowScreen?18.sp:20),),
                                            h10,
                                            Text('${appointments[i]['patientName']}',style: getRegularStyle(color: ColorManager.black,fontSize: isExtraWide?12:widget.isNarrowScreen?16.sp:18),),
                                          ],
                                        ),

                                      ],
                                    ),
                                    FaIcon(Icons.more_vert,color: ColorManager.black,size: isExtraWide?20:widget.isNarrowScreen?20.sp:24,)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: ColorManager.black.withOpacity(0.4),
                        ),
                      ],
                    ),

                ],
              )

          ),
          InkWell(
            onTap: (){},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                border: Border.all(
                  color: ColorManager.black.withOpacity(0.5)
                )
              ),
              child: Center(
                  child: Text('See more',style: getMediumStyle(color: ColorManager.black,fontSize: 16),)),

            ),
          ),
        ],
      ),
    );
  }

}

