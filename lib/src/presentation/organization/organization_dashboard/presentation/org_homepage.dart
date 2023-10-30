
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:medical_app/src/data/model/registered_patient_model.dart';
import 'package:medical_app/src/data/services/user_services.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';

import '../../../login/domain/model/user.dart';
import '../../../notices/presentation/notices.dart';
import '../../../notification/presentation/notification_page.dart';

class OrgHomePage extends StatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  final bool noticeBool;
  OrgHomePage(this.isWideScreen,this.isNarrowScreen,this.noticeBool);

  @override
  State<OrgHomePage> createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {




  bool? _geolocationStatus;
  LocationPermission? _locationPermission;
  geo.Position? _userPosition;

  List<User> doctors = [];
  List<RegisteredPatientModel> patients = [];


  @override
  void initState() {
    super.initState();
    checkGeolocationStatus();
    _getDoctorsList();

  }


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





  Future<void> _refreshData() async {
    // Implement the logic to refresh the data here
    _getDoctorsList();
    // You can add more functions to update other data if needed
  }


  ///geolocator settings...

  Future<void> checkGeolocationStatus() async {
    _geolocationStatus = await Geolocator.isLocationServiceEnabled();
    if (_geolocationStatus == LocationPermission.denied) {
      setState(() {
        _geolocationStatus = false;
      });
    } else {
      checkLocationPermission();
    }
  }

  Future<void> checkLocationPermission() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      ('permission denied');
    } else if (_locationPermission == LocationPermission.deniedForever) {
      ('permission denied');
    } else if (_locationPermission == LocationPermission.always ||
        _locationPermission == LocationPermission.whileInUse) {
      ('permission given');

      final _currentPosition = await Geolocator.getCurrentPosition();

      _userPosition = _currentPosition;
      (_userPosition);
    }
  }

  void _getDoctorsList() async {
    final List<User> doctorList = await UserService().getDoctors();
    setState(() {
      doctors = doctorList;
    });
  }





  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final userBox = Hive.box<User>('session').values.toList();
    String firstName = userBox[0].firstName!;



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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              buildBody(context)
            ],
          ),
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
        _notices(),
        h100,
        h100, h100, h100, h100

      ],
    );
  }


  Widget _overallStat() {



    return Container(
      height: widget.isWideScreen? 220:180,
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
                    Text('Overall Patients Stat',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?16.sp:20.sp),)
                  ],
                ),
                h20,
                Text('Total Patients Registered :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
                h10,
                Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
                h10,
                Text('Last 7 days',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),

              ],
            ),

          ),
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
                    Text('General',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
                  ],
                ),
                h20,
                Text('General Ward :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
                h10,
                Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
                h10,
                Text('Last 7 days',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),

              ],
            ),

          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    ColorManager.red.withOpacity(0.8),
                    ColorManager.red.withOpacity(0.8),
                    ColorManager.red.withOpacity(0.7),
                    ColorManager.red.withOpacity(0.7),
                    ColorManager.red.withOpacity(0.6),
                    ColorManager.red.withOpacity(0.6),
                    ColorManager.red.withOpacity(0.5)
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
                        child: FaIcon(Icons.emergency,color: ColorManager.white,)),
                    w10,
                    Text('Emergency',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
                  ],
                ),
                h20,
                Text('Emergency cases :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
                h10,
                Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
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
                        child: FaIcon(FontAwesomeIcons.bedPulse,color: ColorManager.white,size: 20,)),
                    w10,
                    Text('Surgical Stats',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
                  ],
                ),
                h20,
                Text('Total Operations :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),
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




  Widget _notices(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notices & Updates',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
          h20,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
            color: ColorManager.dotGrey.withOpacity(0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Drink water everyday.', style: getMediumStyle(color: Colors.black,fontSize: 16)),
                h10,
                Text(
                  'Drink water everyday for everytime you get dehydrated there will be mny problems to suffer through. If you read it this point click it to know more about more health tips.',
                  style: getRegularStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          ),
          h10,

        ],
      ),
    );
  }






}





class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isWideScreen;
  final bool isNarrowScreen;


  const CustomSliverAppBarDelegate( this.isWideScreen, this.isNarrowScreen,{
    required this.expandedHeight,
    required this.scaffoldKey
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent,) {
    // final userBox = Hive.box<User>('session').values.toList();
    // String firstName = userBox[0].firstName!;
    final deviceSize = MediaQuery.of(context).size;
    const size = 60;
    ('Shrink Offset: $shrinkOffset');

    return Stack(
      fit: StackFit.expand,
      children: [
        if(shrinkOffset<15)buildBackground(shrinkOffset, context, scaffoldKey,'User'),
        if(shrinkOffset >= 160.0)buildAppBar(shrinkOffset,context),

      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;



  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;


  Widget buildAppBar(double shrinkOffset,BuildContext context) => Opacity(
      opacity: appear(shrinkOffset),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        // height: 40.h,
        color: ColorManager.white,
        child: ListTile(
          leading: InkWell(
            // onTap: ()=>Get.to(()=>ProfilePage(),transition: Transition.fade),
            child: CircleAvatar(
              backgroundColor: ColorManager.black,
              radius: 20,
              child: FaIcon(FontAwesomeIcons.person,color: ColorManager.white,),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                  // onTap: ()=>Get.to(()=>SearchNearByPage(isNarrowScreen,isWideScreen),transition: Transition.fadeIn),
                  child: Icon(Icons.search,color: ColorManager.black,size: 20,)),
              w20,
              InkWell(
                  onTap: ()=>Get.to(()=>NotificationPage()),
                  child: Icon(Icons.notifications_none_outlined,color: ColorManager.black,size: 20,)),
            ],
          ),
        ),
      )

  );

  Widget buildBackground(double shrinkOffset, BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, String firstName) => Opacity(
    opacity: disappear(shrinkOffset),
    child: Container(
      height: isWideScreen == true? MediaQuery.of(context).size.height*0.5/5:100.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      padding: EdgeInsets.symmetric(horizontal: isWideScreen?18: 18.w,vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          h20,
          Container(

            child: AppBar(
              toolbarHeight: isWideScreen? 100:70.h,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: InkWell(
                // onTap: ()=>Get.to(()=>ProfilePage(),transition: Transition.fade),
                child: CircleAvatar(
                  backgroundColor: ColorManager.black,
                  radius: isWideScreen? 30:20.sp,
                  child: FaIcon(FontAwesomeIcons.person,color: ColorManager.white,),
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  h20,
                  Text('Good Morning,',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isWideScreen? 16:16.sp),),
                  Text('User',style: getMediumStyle(color: ColorManager.black,fontSize: isWideScreen?24:28.sp),),
                ],
              ),
              actions: [
                InkWell(
                    onTap:()=>Get.to(()=>NotificationPage()),
                    child: Icon(Icons.notifications_none_outlined,color: ColorManager.black,size: isWideScreen? 30:28.sp,))
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            // onTap: ()=>Get.to(()=>SearchNearByPage(isNarrowScreen,isWideScreen),transition: Transition.fadeIn),
            splashColor: ColorManager.primary.withOpacity(0.4),
            child: Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                decoration: BoxDecoration(
                    color: ColorManager.searchColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:ColorManager.searchColor,
                        width: 1
                    )
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.search,color: ColorManager.iconGrey,),
                        w10,
                        Text('Search for nearby...',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isWideScreen?15:15.sp),),
                      ],
                    ),
                    SizedBox()
                  ],
                )
            ),
          ),
        ],
      ),
    ),
  );





  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;



}

class LinearProgressBar extends StatelessWidget {
  final int maxSteps;
  final int currentStep;
  final Color progressColor;
  final Color backgroundColor;

  LinearProgressBar({
    required this.maxSteps,
    required this.currentStep,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    double progress = currentStep.toDouble() / maxSteps.toDouble();
    Color targetColor = ColorManager.brightRed; // Change the target color to red

    // Calculate the interpolated color based on progress
    Color currentColor = Color.lerp(progressColor, targetColor, progress) ??
        Colors.transparent; // If lerp returns null, fallback to transparent

    return LinearProgressIndicator(

      value: progress,
      valueColor: AlwaysStoppedAnimation<Color>(currentColor),
      backgroundColor: backgroundColor,
    );
  }
}






