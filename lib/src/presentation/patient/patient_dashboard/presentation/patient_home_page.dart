import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:medical_app/src/presentation/patient/health_tips/data/tagList_provider.dart';
import 'package:medical_app/src/presentation/patient/health_tips/presentation/health_tips_list.dart';
import 'package:medical_app/src/presentation/patient/personal_services/lab_reports/lab_reports.dart';
import 'package:medical_app/src/presentation/patient/personal_services/mri/mri.dart';
import 'package:medical_app/src/presentation/patient/personal_services/sugar/sugar.dart';
import 'package:medical_app/src/presentation/patient/personal_services/usg/usg.dart';
import 'package:medical_app/src/presentation/patient/personal_services/xray/xray.dart';
import 'package:medical_app/src/presentation/patient_registration/domain/services/patient_registration_service.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../login/domain/model/user.dart';
import '../../../notification/presentation/notification_page.dart';
import '../../../patient_registration/presentation/patient_registration.dart';
import '../../health_tips/domain/model/health_tips_dummy_tags.dart';
import '../../health_tips/domain/model/health_tips_model.dart';
import '../../health_tips/domain/services/health_tips_services.dart';
import '../../health_tips/presentation/health_tips.dart';
import '../../personal_services/bloodpressure/bp.dart';
import '../../personal_services/ct_scan/ct_scan.dart';
import '../../personal_services/discharge_summary/discharge_summary.dart';
import '../../personal_services/prescription/prescription.dart';
import '../../profile/presentation/profile_page.dart';
import '../../search-near-by/presentation/search_for_page.dart';



class PatientHomePage extends ConsumerStatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  PatientHomePage(this.isWideScreen,this.isNarrowScreen);

  @override
  ConsumerState<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends ConsumerState<PatientHomePage> {

  bool? _geolocationStatus;
  LocationPermission? _locationPermission;
  Position? _userPosition;




  @override
  void initState() {
    super.initState();
    checkGeolocationStatus();
  }

  /// health tags...

  List<HealthTipsModel> selectedTags = [];

  void _showMultiSelect(BuildContext context) async {
    final tagList = await HealthTipServices().getHealthTips();
    Set<String> addedTypes = Set<String>();
    List<HealthTipsModel> uniqueTagList = [];

    for (var tag in tagList) {
      if (!addedTypes.contains(tag.type)) {
        uniqueTagList.add(tag);
        addedTypes.add(tag.type!);
      }
    }

    // Create a copy of selectedTags with the same reference as uniqueTagList
    List<HealthTipsModel> initialSelectedTags =
    selectedTags.map((tag) => uniqueTagList.firstWhere((t) => t.type == tag.type)).toList();

    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          title: Text('Choose Health Tips'),
          listType: MultiSelectListType.CHIP,
          selectedColor: ColorManager.primary,
          separateSelectedItems: true,
          selectedItemsTextStyle: getRegularStyle(color: ColorManager.white, fontSize: 16),
          itemsTextStyle: getRegularStyle(color: ColorManager.black, fontSize: 16),
          items: uniqueTagList
              .map((tag) => MultiSelectItem<HealthTipsModel>(tag, tag.type!))
              .toList(),
          initialValue: initialSelectedTags, // Use initialSelectedTags here
          onConfirm: (values) {
            setState(() {
              selectedTags = values.map((tag) => tag).toList(); // Store selected items
            });
            ref.read(tagListProvider.notifier).updateTagList(selectedTags);
            print(selectedTags);
          },
        );
      },
    );
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

      final _currentPosition= await Geolocator.getCurrentPosition();

      _userPosition = _currentPosition;
      (_userPosition);

    }
  }


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


    double getExpandedHeight(Size screenSize) {
      final double width = screenSize.width;
      final double height = screenSize.height;
      final double ratio = (width / height).toPrecision(2);

      if (ratio >= 0.3 && ratio <= 0.45) {
        // 3:8 ratio
        ("3:8 ratio: Width: $width, Height: $height, Ratio: $ratio");
        return 180.0;
      } else if (ratio <= 0.5 && ratio >0.45) {
        // 7:10 ratio
        ("7:10 ratio: Width: $width, Height: $height, Ratio: $ratio");
        return 200.0;
      } else if (ratio >= 0.6 && ratio < 0.7) {
        // 7:10 ratio
        ("7:10 ratio: Width: $width, Height: $height, Ratio: $ratio");
        return 270.0;
      } else if (ratio >= 0.7 && ratio <= 0.8) {
        // 7:10 ratio
        ("7:10 ratio: Width: $width, Height: $height, Ratio: $ratio");
        return 280.0;
      } else if (ratio > 1.49 && ratio < 1.51) {
        // 12:8 ratio
        ("12:8 ratio: Width: $width, Height: $height, Ratio: $ratio");
        return 270.0;
      } else if (ratio >= 1.6) {
        // 12:8 ratio
        ("12:8 ratio: Width: $width, Height: $height, Ratio: $ratio");
        return 280.0;
      }else {
        // Default value if none of the resolutions match
        ("Default: Width: $width, Height: $height, Ratio: $ratio");
        return 200.0;
      }
    }




    return FadeIn(
      duration: Duration(milliseconds: 700),
      child: Scaffold(
        key: scaffoldKey,
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              delegate: CustomSliverAppBarDelegate(widget.isWideScreen,widget.isNarrowScreen,expandedHeight:getExpandedHeight(MediaQuery.of(context).size), scaffoldKey: scaffoldKey),
              pinned: true,
            ),
            buildBody(context)
          ],
        ),
        extendBody: true,
      ),
    );
  }

  Widget buildBody(BuildContext context){
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInUp(
            duration: Duration(milliseconds: 500),
              child: FactCarousel(widget.isWideScreen)),
          h10,

          FadeInUp(
              duration: Duration(milliseconds: 800),
              child: buildQuickServices(widget.isWideScreen)),
          h10,
          FadeInUp(
              duration: Duration(milliseconds: 1000),
              child: _buildHealthTips(widget.isWideScreen)),
          h10,
          FadeInUp(
              duration: Duration(milliseconds: 1200),
              child: buildPersonalServices(widget.isWideScreen)),



          SizedBox(
            height: 300.h,
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
          Text('Quick Services',style: getMediumStyle(color: ColorManager.black,fontSize: isWideScreen == true ? 20: 20.sp),),

          h10,
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
                  onTap: ()=>Get.to(()=>PatientRegistrationForm(widget.isWideScreen,widget.isNarrowScreen)),
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10),
                        color: ColorManager.brightGreen
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
                                color: ColorManager.textGrey.withOpacity(0.7),
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
                  onTap: ()=>Get.to(()=>PatientRegistrationForm(widget.isWideScreen,widget.isNarrowScreen)),
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10),
                        color: ColorManager.yellowFellow
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
                              width: 120,
                              decoration: BoxDecoration(
                                color: ColorManager.textGrey.withOpacity(0.7),
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
                  onTap: (){},
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10),
                        color: ColorManager.blueContainer
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
                                color: ColorManager.textGrey.withOpacity(0.7),
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
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                      borderRadius:BorderRadius.circular(10),
                      color: ColorManager.brightPink
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
                              color: ColorManager.textGrey.withOpacity(0.7),
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
    required Color color,
    IconData? icon,
    String? img,
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
              color: ColorManager.black,
              width: 0.3
          )
      ),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        splashColor: ColorManager.primary.withOpacity(0.5),// Customize the splash color
        borderRadius: BorderRadius.circular(10),
        child: Container(

          decoration: BoxDecoration(
            color: color,
              borderRadius: BorderRadius.circular(10)
          ),
          padding: EdgeInsets.symmetric(horizontal: isWideScreen?5:5.w,vertical:isWideScreen?8: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon!=null?Center(child: FaIcon(icon,size:isWideScreen? 30: 24.sp,color: ColorManager.black.withOpacity(0.7),)): Image.asset('$img',width: isWideScreen?34:isNarrowScreen?20:28,height:isWideScreen?34:isNarrowScreen?20: 28,),
              h10,
              name.length<=12?Text('$name',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isWideScreen?12:12.sp,),):Text('$name',style: getRegularStyle(color: ColorManager.textGrey,fontSize:isWideScreen?10: 10.sp),textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPersonalServices(bool isWideScreen) {
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
                  onTap:()=>Get.to(()=>Prescriptions()),
                  name: 'Prescription',
                  icon: FontAwesomeIcons.filePrescription,
                  color: ColorManager.accentRed.withOpacity(0.2)
              ),
              _personalServices(
                  onTap: ()=>Get.to(()=>Discharge()),
                  name: 'Discharge Summary', icon: Icons.sticky_note_2_rounded,color: ColorManager.accentBlue.withOpacity(0.2)),
              _personalServices(
                  onTap: ()=>Get.to(()=>LabReports()),
                  name: 'Lab', icon: FontAwesomeIcons.microscope,color: ColorManager.accentYellow.withOpacity(0.2)),
              _personalServices(
                  onTap: ()=>Get.to(()=>Xray()),
                  name: 'X-Ray', icon: FontAwesomeIcons.xRay,color: ColorManager.accentLightGreen.withOpacity(0.2)),
              _personalServices(
                  onTap: ()=>Get.to(()=>USG()),
                  name: 'USG', img: 'assets/icons/ultrasound.png',color: ColorManager.accentCream.withOpacity(0.2)),
              _personalServices(
                  onTap: ()=>Get.to(()=>CTScan()),
                  name: 'CT Scan', img: 'assets/icons/tomography.png',color: ColorManager.accentOrange.withOpacity(0.2)),
              _personalServices(
                  onTap: ()=>Get.to(()=>MRI()),
                  name: 'MRI', img:'assets/icons/ct-scan.png',color: ColorManager.accentPurple.withOpacity(0.2)),
              _personalServices(
                  onTap: ()=>Get.to(()=>Sugar()),
                  name: 'Sugar', img:'assets/icons/sugar.png',color: ColorManager.accentGreen.withOpacity(0.2)),
              _personalServices(
                  onTap: ()=>Get.to(()=>BP()),
                  name: 'Blood Pressure', img:'assets/icons/bp.png',color: ColorManager.accentPink.withOpacity(0.2)),





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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Health Tips',style: getMediumStyle(color: ColorManager.black,fontSize:isWideScreen?20: 20.sp),),
              IconButton(onPressed: (){
                _showMultiSelect(context);
              }, icon: FaIcon(Icons.add,color: ColorManager.black,))
            ],
          ),
          h10,
          HealthTipsList(),

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
    final userBox = Hive.box<User>('session').values.toList();
    String firstName = 'User'; //userBox[0].username!;
    final deviceSize = MediaQuery.of(context).size;
    const size = 60;
    ('Shrink Offset: $shrinkOffset');

    return Stack(
      fit: StackFit.expand,
      children: [
        if(shrinkOffset<15)buildBackground(shrinkOffset, context, scaffoldKey,firstName),
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
          onTap: ()=>Get.to(()=>ProfilePage(),transition: Transition.fade),
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
                onTap: ()=>Get.to(()=>SearchNearByPage(isNarrowScreen,isWideScreen),transition: Transition.fadeIn),
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
      child: SingleChildScrollView(
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
                  onTap: ()=>Get.to(()=>ProfilePage(),transition: Transition.fade),
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
                    Text('$firstName',style: getMediumStyle(color: ColorManager.black,fontSize: isWideScreen?24:28.sp),),
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
              onTap: ()=>Get.to(()=>SearchNearByPage(isNarrowScreen,isWideScreen),transition: Transition.fadeIn),
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
    ),
  );





  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;



}

class FactCarousel extends StatelessWidget {
  final bool isWideScreen;
  FactCarousel(this.isWideScreen);
  final List<String> imageList = ['assets/images/containers/Tip-Container.png', 'assets/images/containers/Tip-Container 2.png', 'assets/images/containers/Tip-Container-3.png'];

  @override
  Widget build(BuildContext context) {

    final fontSize = isWideScreen ? 18.0 : 18.sp;
    final iconSize = isWideScreen ? 20.0 : 20.sp;
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
      items: imageList.map((image) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(image),fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 12.h),
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FaIcon(Icons.lightbulb,color: ColorManager.white,),
                    w10,
                    Text('Did you know?',style: getHeadBoldStyle(color: ColorManager.white,fontSize: isWideScreen == true ? 26:26.sp),),
                  ],
                ),
                h12,
                Text('In a day, an average human must drink upto 4L of water.',style: getRegularStyle(color: ColorManager.white,fontSize: fontSize),maxLines: 3,),
                h12,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.white,
                    elevation: 5
                  ),
                    onPressed: (){},
                    child: Text('Know More',style: getRegularStyle(color: ColorManager.black,fontSize: fontSize),)
                )

              ],
            ),
          ),
          
        );
      }).toList(),
    );
  }



}




