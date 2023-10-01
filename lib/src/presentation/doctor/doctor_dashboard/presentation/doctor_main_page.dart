import 'package:carousel_slider/carousel_slider.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/presentation/doctor/doctor_dashboard/presentation/doctor_home_page.dart';
import 'package:medical_app/src/presentation/doctor/doctor_utilities/presentation/doctor_utilities.dart';
import 'package:medical_app/src/presentation/patient_registration/presentation/patient_registration.dart';

import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../../data/provider/common_provider.dart';
import '../../../../dummy_datas/dummy_datas.dart';
import '../../../common/snackbar.dart';
import '../../../notices/presentation/notices.dart';
import '../../../settings/settings_global.dart';
import '../../documents/presentation/document_page.dart';
import '../../patient_reports/presentation/report_page_doctor.dart';




class DoctorMainPage extends ConsumerStatefulWidget {
   DoctorMainPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<DoctorMainPage> createState() => _AnimatedBarExampleState();
}

class _AnimatedBarExampleState extends ConsumerState<DoctorMainPage> with SingleTickerProviderStateMixin {
  dynamic selected;
  PageController controller = PageController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // late Animation<double> _animation;
  // late AnimationController _animationController;
  // bool set = false;

  // @override
  // void initState(){
  //
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: Duration(milliseconds: 260),
  //   );
  //
  //   final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
  //   _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  //
  //
  //   super.initState();
  //
  //
  // }
  //


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final check = ref.watch(itemProvider).noticeChange;
    if(check == true){
      // Schedule the _showAlertDialog method to be called after the build is complete.
      Future.delayed(Duration.zero, () {
        showAlertDialog(context);
      });
    }

  }



  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 420;
    return WillPopScope(
      onWillPop: ()async{
        if(selected == 0){
          return true;
        }
        else{
          setState(() {
            selected =0;
            controller.jumpToPage(selected);
          });
          return false;
        }


      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true, //to make floating action button notch transparent

        //to avoid the floating action button overlapping behavior,
        // when a soft keyboard is displayed
        // resizeToAvoidBottomInset: false,

        bottomNavigationBar: StylishBottomBar(
          elevation: 10,
          option: AnimatedBarOptions(
            // iconSize: 32,
            barAnimation: BarAnimation.fade,
            iconStyle: IconStyle.animated,
            // opacity: 0.3,
          ),
          items: [
            BottomBarItem(
              icon:  FaIcon(CupertinoIcons.home,size: isWideScreen?24:24.sp,),
              // selectedIcon:  Icon(CupertinoIcons.home,size: isWideScreen?24:24.sp,),
              selectedColor: ColorManager.primary,
              // unSelectedColor: Colors.purple,
              // backgroundColor: Colors.orange,
              title:  Text('Home'),
            ),
            BottomBarItem(
              icon:  FaIcon(Icons.file_copy,size: isWideScreen?24:24.sp,),
              // selectedIcon:  FaIcon(FontAwesomeIcons.folder),
              selectedColor: ColorManager.primary,
              // unSelectedColor: Colors.purple,
              // backgroundColor: Colors.orange,
              title:  Text('Documents'),
            ),
            BottomBarItem(
              icon:  FaIcon(CupertinoIcons.doc_chart,size: isWideScreen?24:24.sp,),
              // selectedIcon:  FaIcon(FontAwesomeIcons.folder),
              selectedColor: ColorManager.primary,
              // unSelectedColor: Colors.purple,
              // backgroundColor: Colors.orange,
              title:  Text('Reports'),
            ),
            BottomBarItem(
              icon:  FaIcon(Icons.grid_view_outlined,size: isWideScreen?24:24.sp,),
              // selectedIcon:  FaIcon(FontAwesomeIcons.folder),
              selectedColor: ColorManager.primary,
              // unSelectedColor: Colors.purple,
              // backgroundColor: Colors.orange,
              title:  Text('Utilities'),
            ),
            BottomBarItem(
              icon:  FaIcon(Icons.settings,size: isWideScreen?24:24.sp,),
              // selectedIcon:  FaIcon(FontAwesomeIcons.folder),
              selectedColor: ColorManager.primary,
              // unSelectedColor: Colors.purple,
              // backgroundColor: Colors.orange,
              title:  Text('Settings'),
            ),

          ],
          hasNotch: false,
          currentIndex: selected ?? 0,
          onTap: (index) {
            controller.jumpToPage(index);
            setState(() {
              selected = index;
            });

          },
        ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

          //Init Floating Action Bubble
          floatingActionButton: FloatingActionButton(
              onPressed: (){
                final scaffoldMessage = ScaffoldMessenger.of(context);
                scaffoldMessage.showSnackBar(
                    SnackbarUtil.showSuccessSnackbar(
                        message: 'Coming Soon',
                        duration: const Duration(milliseconds: 1200)
                    )
                );
              },
            backgroundColor: ColorManager.primary,
            child: FaIcon(CupertinoIcons.chat_bubble_2_fill,color: ColorManager.white,),

              ),
        body: PageView(
          onPageChanged: (value){
            setState(() {
              selected = value;
            });
          },
          controller: controller,
          children: [
            DoctorHomePage(isWideScreen,isNarrowScreen),
            DocumentPage(isWideScreen,isNarrowScreen),
            PatientReportPageDoctor(),
            DoctorUtilityPage(),
            Settings(isWideScreen, isNarrowScreen)
          ],
        ),
      ),
    );
  }
}
