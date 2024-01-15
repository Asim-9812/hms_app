import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/presentation/patient/health_tips/data/tagList_provider.dart';
import 'package:meroupachar/src/presentation/patient/health_tips/presentation/health_tips_list.dart';
import 'package:meroupachar/src/presentation/patient/sliders/domain/services/slider_service.dart';
import 'package:meroupachar/src/presentation/video_chat/presentation/meeting_page.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../../core/api.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../../data/provider/common_provider.dart';
import '../../../common/snackbar.dart';
import '../../../login/domain/model/user.dart';
import '../../../notices/presentation/notices.dart';
import '../../../notification/presentation/notification_page.dart';

import 'package:meroupachar/src/presentation/patient/health_tips/domain/model/health_tips_model.dart';
import '../../../video_chat/presentation/whereby_join_page.dart';
import '../../../video_chat/presentation/whereby_meeting_page.dart';
import '../../health_tips/domain/services/health_tips_services.dart';
import '../../search-near-by/presentation/search_for_page.dart';



class PatientHomePage extends ConsumerStatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  final bool noticeBool;
  final String code;
  PatientHomePage(this.isWideScreen,this.isNarrowScreen,this.noticeBool,this.code);

  @override
  ConsumerState<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends ConsumerState<PatientHomePage> {

  bool? _geolocationStatus;
  LocationPermission? _locationPermission;
  Position? _userPosition;
  late bool check;

  final _roomController = TextEditingController();





  @override
  void initState() {
    super.initState();

    // checkGeolocationStatus();
    // NotificationService().initNotification();

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   if(widget.noticeBool){
    //     showAlertDialog2(context,widget.code,ref);
    //   }
    //
    // });





  }

  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   if(widget.noticeBool){
  //     // Schedule the _showAlertDialog method to be called after the build is complete.
  //     Future.delayed(Duration.zero, () {
  //
  //     });
  //   }
  //
  // }



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

      print('permission denied');

    } else if (_locationPermission == LocationPermission.deniedForever) {
      print('permission denied');


    } else if (_locationPermission == LocationPermission.always ||
        _locationPermission == LocationPermission.whileInUse) {

      print('permission given');

      final _currentPosition= await Geolocator.getCurrentPosition();

      _userPosition = _currentPosition;
      // (_userPosition);

    }
  }










  @override
  Widget build(BuildContext context) {


    //final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final userBox = Hive.box<User>('session').values.toList();
    String firstName = userBox[0].firstName!;
    final profileImg = ref.watch(imageProvider);
    ImageProvider<Object>? profileImage;

    if (profileImg != null) {
      profileImage = Image.file(File(profileImg.path)).image;
    } else if (userBox[0].profileImage == null) {
      profileImage = AssetImage('assets/icons/user.png');
    } else {
      profileImage = NetworkImage('${Api.baseUrl}/${userBox[0].profileImage}');
    }






      return FadeIn(
        duration: Duration(milliseconds: 700),
        child: Scaffold(
          backgroundColor: ColorManager.primary,
          // key: scaffoldKey,
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
                      radius:30,
                      backgroundImage: profileImage,
                    ),
                    w10,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('Welcome,',style: getRegularStyle(color: ColorManager.white,fontSize: 16),),

                        Text('$firstName',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),
                      ],
                    ),
                  ],
                ),
              )
            ),
          body: Container(

              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
                ),
                color: ColorManager.white,
              ),
              child: buildBody(context))

          // CustomScrollView(
          //   physics: BouncingScrollPhysics(),
          //   slivers: [
          //     // SliverPersistentHeader(
          //     //   delegate: CustomSliverAppBarDelegate(widget.isWideScreen,widget.isNarrowScreen,expandedHeight:getExpandedHeight(MediaQuery.of(context).size), scaffoldKey: scaffoldKey),
          //     //   pinned: true,
          //     // ),
          //     buildBody(context)
          //   ],
          // ),
          // extendBody: true,
        ),
      );




  }

  Widget buildBody(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          h20,
          FactCarousel(widget.isWideScreen),
          h10,

          buildQuickServices(widget.isWideScreen),

          _buildHealthTips(widget.isWideScreen),
          h10,
          buildPersonalServices(widget.isWideScreen),



          SizedBox(
            height: 100.h,
          )



        ],
      ),
    );
  }

  /// Quick Services...
  Widget buildQuickServices(bool isWideScreen) {

    final fontSize = isWideScreen ? 16.0 : 16.sp;
    final iconSize = isWideScreen ? 20.0 : 20.sp;
    final height = isWideScreen ? 120.0 : 120.h;
    final width = isWideScreen ? 200.0 : 200.w;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWideScreen ? 18:12.w,vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text('Quick Services',style: getMediumStyle(color: ColorManager.black,fontSize: isWideScreen == true ? 20: 20.sp),),
          //
          // h10,
          Container(
            height: 150.h,
            width: double.infinity,
            color: ColorManager.white,
            child: ListView(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [

                InkWell(
                  onTap: (){
                    final scaffoldMessage = ScaffoldMessenger.of(context);
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming Soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  },
                      //()=>Get.to(()=>PatientRegistrationForm(widget.isWideScreen,widget.isNarrowScreen)),
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10),
                        color: ColorManager.primary.withOpacity(0.5)
                    ),
                    child: Stack(
                      children: [
                        Center(child: Image.asset('assets/images/eticket.png')),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Container(
                              height: 25,
                              width: 90,
                              decoration: BoxDecoration(
                                color: ColorManager.orange.withOpacity(0.8),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)
                                ),
                              ),
                              child: Center(
                                child: Text('E-Ticket',style: getMediumStyle(color: ColorManager.white,fontSize: fontSize),),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                w10,
                InkWell(
                  onTap: () {
                    final scaffoldMessage = ScaffoldMessenger.of(context);
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming Soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                    // Get.to(()=>WhereByJoinMeetingPage());
                  },
                      //()=>Get.to(()=>PatientRegistrationForm(widget.isWideScreen,widget.isNarrowScreen)),
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10),
                        color: ColorManager.primary.withOpacity(0.5)
                    ),
                    child: Stack(
                      children: [
                        Center(child: Image.asset('assets/images/call.png')),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Container(
                              height: 25,
                              width: 140,
                              decoration: BoxDecoration(
                                color: ColorManager.orange.withOpacity(0.8),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)
                                ),
                              ),
                              child: Center(
                                child: Text('Online Consultation',style: getMediumStyle(color: ColorManager.white,fontSize: fontSize),),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                w10,
                InkWell(
                  onTap: (){
                    final scaffoldMessage = ScaffoldMessenger.of(context);
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming Soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  },
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10),
                        color: ColorManager.primary.withOpacity(0.5)
                    ),
                    child: Stack(
                      children: [
                        Center(child: Image.asset('assets/images/tele.png')),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Container(
                              height: 25,
                              width: 120,
                              decoration: BoxDecoration(
                                color: ColorManager.orange.withOpacity(0.8),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)
                                ),
                              ),
                              child: Center(
                                child: Text('Second Opinion',style: getMediumStyle(color: ColorManager.white,fontSize: fontSize),),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                w10,
                InkWell(
                  onTap: (){
                    final scaffoldMessage = ScaffoldMessenger.of(context);
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming Soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  },
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10),
                        color: ColorManager.primary.withOpacity(0.5)
                    ),
                    child: Stack(
                      children: [
                        Center(child: Image.asset('assets/images/pharmacy.png')),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Container(
                              height: 25,
                              width: 90,
                              decoration: BoxDecoration(
                                color: ColorManager.orange.withOpacity(0.8),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)
                                ),
                              ),
                              child: Center(
                                child: Text('Pharmacy',style: getMediumStyle(color: ColorManager.white,fontSize: fontSize),),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Personal Services...
  Widget _personalServices({
    required String name,

    required String img,
    VoidCallback? onTap,
}) {


    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 500;
    return Card(
      
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: ColorManager.dotGrey.withOpacity(0.2),
          )
      ),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        splashColor: ColorManager.primary.withOpacity(0.5),// Customize the splash color
        borderRadius: BorderRadius.circular(10),
        child: Container(

          decoration: BoxDecoration(
            color: ColorManager.white,
              borderRadius: BorderRadius.circular(10)
          ),
          padding: EdgeInsets.symmetric(horizontal: isWideScreen?5:5.w,vertical:isWideScreen?8: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('$img',width: 30,height: 30,),
              h10,
              name.length<=12?Text('$name',style: getMediumStyle(color: ColorManager.primaryDark,fontSize: isWideScreen?12:12.sp,),):Text('$name',style: getMediumStyle(color: ColorManager.primaryDark,fontSize:isWideScreen?10: 10.sp),textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPersonalServices(bool isWideScreen) {
    final scaffoldMessage = ScaffoldMessenger.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWideScreen?18:12.w,vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal Services',style: getMediumStyle(color: ColorManager.black,fontSize:isWideScreen?20: 20.sp),),

          h10,
          GridView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWideScreen? 6:4,
                childAspectRatio: 3/3,
                crossAxisSpacing: isWideScreen?16 :16.w,
                mainAxisSpacing: isWideScreen? 12: 12.h
            ),
            children: [
              _personalServices(
                  onTap:(){
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  },
                  name: 'Prescription', img: 'assets/images/ps/prescribe.png'
              ),
              _personalServices(
                  onTap:(){
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  },
                  name: 'Discharge',  img: 'assets/images/ps/discharge.png'),
              _personalServices(
                  onTap:(){
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  },
                  name: 'Lab', img: 'assets/images/ps/lab.png'),
              _personalServices(
                  onTap:(){
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  },
                  name: 'X-Ray', img: 'assets/images/ps/xray.png'),
              _personalServices(
                  onTap:(){
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  },
                  name: 'USG',  img: 'assets/images/ps/usg.png'),
              _personalServices(
                  onTap:(){
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  },
                  name: 'CT Scan', img: 'assets/images/ps/ct.png'),
              _personalServices(
                  onTap:(){
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  },
                  name: 'MRI', img:'assets/images/ps/mri.png'),
              _personalServices(
                  onTap:(){
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  },
                  name: 'Sugar', img:'assets/images/ps/sugar.png'),
              _personalServices(
                  onTap:(){
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showComingSoonBar(
                        message: 'Coming soon !',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                  },
                  name: 'Blood Pressure', img:'assets/images/ps/bp.png'),





            ],
          )
        ],
      ),
    );
  }

  Widget _buildHealthTips(bool isWideScreen){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          HealthTipsList(),

        ],
      ),
    );
  }


}


class FactCarousel extends ConsumerWidget {
  final bool isWideScreen;
  FactCarousel(this.isWideScreen);
  final List<String> imageList = ['assets/images/containers/Tip-Container-3.png'];

  @override
  Widget build(BuildContext context,ref) {

    final fontSize = isWideScreen ? 18.0 : 18.sp;
    final iconSize = isWideScreen ? 20.0 : 20.sp;

    final sliderData = ref.watch(getSliders);

    return sliderData.when(
        data: (data){
          return CarouselSlider(
            options: CarouselOptions(
              height: isWideScreen? 200 :180.sp,
              enlargeCenterPage: true,

              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
            items: data.map((image) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage('${Api.baseUrl}/${image.imagePath}'),fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 12.h),
                width: MediaQuery.of(context).size.width,

              );
            }).toList(),
          );
        },
        error: (error,stack) => SizedBox(),
        loading: ()=>SpinKitDualRing(color: ColorManager.primary)
    );



  }



}




