
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/data/model/registered_patient_model.dart';
import 'package:meroupachar/src/data/services/user_services.dart';
import 'package:meroupachar/src/presentation/organization/charts_graphs/financial_charts.dart';
import '../../../../core/api.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';

import '../../../../data/provider/common_provider.dart';
import '../../../login/domain/model/user.dart';
import '../../../notices/presentation/notices.dart';
import '../../../notification/presentation/notification_page.dart';
import '../../charts_graphs/doctor_charts.dart';
import '../../charts_graphs/total_patients.dart';

class OrgHomePage extends ConsumerStatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  final bool noticeBool;
  final String code;
  OrgHomePage(this.isWideScreen,this.isNarrowScreen,this.noticeBool,this.code);

  @override
  ConsumerState<OrgHomePage> createState() => _OrgHomePageState();
}

class _OrgHomePageState extends ConsumerState<OrgHomePage> {




  bool? _geolocationStatus;
  LocationPermission? _locationPermission;
  geo.Position? _userPosition;

  List<User> doctors = [];
  List<RegisteredPatientModel> patients = [];
  bool _isExpanded = true;
  bool _isExpanded2 = true;
  bool _isExpanded3 = true;


  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   showAlertDialog(context,widget.code);
    // });


  }






  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   if(widget.noticeBool){
  //     print('showdialog');
  //     // Schedule the _showAlertDialog method to be called after the build is complete.
  //     Future.delayed(Duration.zero, () {
  //       showAlertDialog(context,widget.code);
  //     });
  //   }
  //
  // }



  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final userBox = Hive.box<User>('session').values.toList();
    String firstName = userBox[0].firstName!;

    // final profileImg = ref.watch(imageProvider);
    // ImageProvider<Object>? profileImage;
    //
    // if (profileImg != null) {
    //   profileImage = Image.file(File(profileImg.path)).image;
    // } else if (userBox[0].profileImage == null) {
    //   profileImage = AssetImage('assets/icons/user.png');
    // } else {
    //   profileImage = NetworkImage('${Api.baseUrl}/${userBox[0].profileImage}');
    // }


    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ColorManager.white,
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
                image: DecorationImage(image: AssetImage('assets/images/banner1111.png'),fit: BoxFit.fitWidth)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: ColorManager.white,
                  backgroundImage: userBox[0].profileImage == null ? null : NetworkImage('${Api.baseUrl}/${userBox[0].profileImage}'),
                  radius: 30,
                  child:userBox[0].profileImage != null ? null :FaIcon(FontAwesomeIcons.user,color: ColorManager.black,),
                ),
                w10,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text('Welcome,',style: getRegularStyle(color: ColorManager.white,fontSize: 14),),

                    Text(firstName.split(' ').length >= 3? '${firstName.split(' ')[0]} ${firstName.split(' ')[1]}': '$firstName',style: getMediumStyle(color: ColorManager.white,fontSize: 18.sp),),
                  ],
                ),
              ],
            ),
          )
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            buildBody(context)
          ],
        ),
      ),
      extendBody: true,
    );
  }


  Widget buildBody(BuildContext context) {



    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        h10,
        _overallStat(),
        h20,

        Container(

          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
          child: Container(
            decoration: BoxDecoration(
                color: ColorManager.primary,
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
                    _isExpanded3 = !_isExpanded3; // Toggle the expansion state
                  });
                },
                children:[
                  ExpansionPanel(
                    isExpanded: _isExpanded3,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(

                        onTap: (){
                          setState(() {
                            _isExpanded3 = !_isExpanded3; // Toggle the expansion state
                          });
                        },
                        title: Text('Total Doctors', style: getMediumStyle(color:ColorManager.black, fontSize: 20)),
                      ); // Empty header, handled above
                    },
                    body: Container(
                      width: double.infinity,
                      height: 500,
                      child: DoctorCharts(),
                    ),
                  ),

                ]



            ),
          ),
        ),

        Container(

          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
          child: Container(
            decoration: BoxDecoration(
                color: ColorManager.primary,
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
                children:[
                  ExpansionPanel(
                    isExpanded: _isExpanded,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(

                        onTap: (){
                          setState(() {
                            _isExpanded = !_isExpanded; // Toggle the expansion state
                          });
                        },
                        title: Text('Total Patients', style: getMediumStyle(color:ColorManager.black, fontSize: 20)),
                      ); // Empty header, handled above
                    },
                    body: Container(
                      width: double.infinity,
                      height: 450,
                      child: PatientChart(),
                    ),
                  ),

                ]



            ),
          ),
        ),

        Container(

          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
          child: Container(
            decoration: BoxDecoration(
                color: ColorManager.primary,
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
                    _isExpanded2 = !_isExpanded2; // Toggle the expansion state
                  });
                },
                children:[
                  ExpansionPanel(
                    isExpanded: _isExpanded2,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(

                        onTap: (){
                          setState(() {
                            _isExpanded2 = !_isExpanded2; // Toggle the expansion state
                          });
                        },
                        title: Text('Revenue', style: getMediumStyle(color:ColorManager.black, fontSize: 20)),
                      ); // Empty header, handled above
                    },
                    body: Container(
                      width: double.infinity,
                      height: 450,
                      child: FinancialCharts(),
                    ),
                  ),

                ]



            ),
          ),
        ),
        h100, h100, h100, h100

      ],
    );
  }


  Widget _overallStat() {



    return Container(
      height: widget.isWideScreen? 200:150,
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
                        child: FaIcon(CupertinoIcons.person_2_fill,color: ColorManager.white,)),
                    w10,
                    Text('Doctors',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?20.sp:24.sp),)
                  ],
                ),
                h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Doctors:',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),

                    Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
                  ],
                ),

              ],
            ),

          ),
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
            margin: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
            height:widget.isWideScreen?200:160.h,
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
                        child: FaIcon(CupertinoIcons.graph_square_fill,color: ColorManager.white,)),
                    w10,
                    Text('Patients',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
                  ],
                ),
                h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Patients :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),

                    Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
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
                        child: FaIcon(Icons.task_rounded,color: ColorManager.white,)),
                    w10,
                    Text('Appointments',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
                  ],
                ),
                h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Appointments :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),

                    Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
                  ],
                ),

              ],
            ),

          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    ColorManager.primary,
                    ColorManager.primary,
                    ColorManager.primary.withOpacity(0.8),
                    ColorManager.primary.withOpacity(0.8),
                    ColorManager.primary.withOpacity(0.7),
                    ColorManager.primary.withOpacity(0.7),
                    ColorManager.primary.withOpacity(0.6)
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
                        child: FaIcon(Icons.currency_exchange,color: ColorManager.white,size: 20,)),
                    w10,
                    Text('Revenue',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
                  ],
                ),
                h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Revenue :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),

                    Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
                  ],
                ),

              ],
            ),

          ),


        ],
      ),
    );
  }












}










