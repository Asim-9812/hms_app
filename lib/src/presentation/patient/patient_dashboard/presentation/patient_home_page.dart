import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:medical_app/src/presentation/patient/health_tips/data/tagList_provider.dart';
import 'package:medical_app/src/presentation/patient/health_tips/presentation/health_tips_list.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../common/snackbar.dart';
import '../../../login/domain/model/user.dart';
import '../../../notices/presentation/notices.dart';
import '../../../notification/presentation/notification_page.dart';
import '../../health_tips/domain/model/health_tips_model.dart';
import '../../health_tips/domain/services/health_tips_services.dart';
import '../../search-near-by/presentation/search_for_page.dart';



class PatientHomePage extends ConsumerStatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  final bool noticeBool;
  PatientHomePage(this.isWideScreen,this.isNarrowScreen,this.noticeBool);

  @override
  ConsumerState<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends ConsumerState<PatientHomePage> {

  bool? _geolocationStatus;
  LocationPermission? _locationPermission;
  Position? _userPosition;
  late bool check;





  @override
  void initState() {
    super.initState();

    checkGeolocationStatus();
    // NotificationService().initNotification();






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

    final userBox = Hive.box<User>('session').values.toList();
    String firstName = userBox[0].firstName!;


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
          backgroundColor: ColorManager.primary,
          key: scaffoldKey,
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
                  onTap: (){},
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
                Container(
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
                  name: 'Discharge Summary',  img: 'assets/images/ps/discharge.png'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Health Tips',style: getMediumStyle(color: ColorManager.black,fontSize:isWideScreen?20: 20.sp),),
              IconButton(onPressed: (){
                _showMultiSelect(context);
              }, icon: FaIcon(FontAwesomeIcons.checkSquare,size: 20,color: ColorManager.orange.withOpacity(0.7),))
            ],
          ),
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
    String firstName = userBox[0].username!;
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
        leading: CircleAvatar(
          backgroundColor: ColorManager.black,
          radius: 20,
          child: FaIcon(FontAwesomeIcons.person,color: ColorManager.white,),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: ()=>Get.to(()=>SearchNearByPage(isNarrowScreen,isWideScreen),transition: Transition.fadeIn),
                child: Icon(Icons.search,color: ColorManager.orange.withOpacity(0.7))),
            w20,
            InkWell(
                onTap: ()=>Get.to(()=>NotificationPage()),
                child: Icon(Icons.notifications,color: ColorManager.orange.withOpacity(0.7),))
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
                leading: CircleAvatar(
                  backgroundColor: ColorManager.black,
                  radius: isWideScreen? 30:20.sp,
                  child: FaIcon(FontAwesomeIcons.person,color: ColorManager.white,),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        h20,
                        Text('Good Morning,',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isWideScreen? 16:16.sp),),
                        Text('$firstName',style: getMediumStyle(color: ColorManager.black,fontSize: isWideScreen?24:28.sp),),
                      ],
                    ),
                    InkWell(
                        onTap: ()=>Get.to(()=>NotificationPage()),
                        child: Icon(Icons.notifications,color: ColorManager.orange.withOpacity(0.7),))
                  ],
                ),

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
  final List<String> imageList = ['assets/images/containers/Tip-Container-3.png'];

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

                    backgroundColor: ColorManager.orange.withOpacity(0.8),
                    elevation: 0
                  ),
                    onPressed: (){},
                    child: Text('Know More',style: getRegularStyle(color: ColorManager.white,fontSize: fontSize),)
                )

              ],
            ),
          ),
          
        );
      }).toList(),
    );
  }



}




