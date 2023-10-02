
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/presentation/organization/doctor_statistics/presentation/doctor_stat_page.dart';
import 'package:medical_app/src/presentation/organization/organization_dashboard/presentation/org_homepage.dart';
import 'package:medical_app/src/presentation/organization/patient_reports/presentation/patients_lists.dart';
import 'package:medical_app/src/presentation/patient_registration/presentation/patient_registration.dart';
import 'package:medical_app/src/presentation/settings/settings_global.dart';

import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../../data/provider/common_provider.dart';
import '../../../../dummy_datas/dummy_datas.dart';
import '../../../notices/presentation/notices.dart';




class OrgMainPage extends ConsumerStatefulWidget {
  const OrgMainPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<OrgMainPage> createState() => _AnimatedBarExampleState();
}

class _AnimatedBarExampleState extends ConsumerState<OrgMainPage> {
  dynamic selected;
  PageController controller = PageController();


  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final check = ref.watch(itemProvider).noticeChange;
  //   if(check == true){
  //     // Schedule the _showAlertDialog method to be called after the build is complete.
  //     Future.delayed(Duration.zero, () {
  //       showAlertDialog(context);
  //     });
  //   }
  //
  // }



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
    bool isNarrowScreen = screenSize.width < 380;

    return Scaffold(
      extendBody: true, //to make floating action button notch transparent


      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          // iconSize: 32,
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
          // opacity: 0.3,
        ),
        items: [
          BottomBarItem(

            icon:  FaIcon(CupertinoIcons.home,size: isWideScreen?24:24.sp,),
            // selectedIcon: const Icon(CupertinoIcons.home,size: isWideScreen?24:24.sp,),
            selectedColor: ColorManager.primary,
            // unSelectedColor: Colors.purple,
            // backgroundColor: Colors.orange,
            title:  Text('Home'),
          ),

          BottomBarItem(
            icon:  FaIcon(CupertinoIcons.doc_chart,size: isWideScreen?24:24.sp,),
            // selectedIcon: const FaIcon(FontAwesomeIcons.folder),
            selectedColor: ColorManager.primary,
            // unSelectedColor: Colors.purple,
            // backgroundColor: Colors.orange,
            title:  Text('Reports'),
          ),
          BottomBarItem(
            icon:  FaIcon(Icons.people_alt_outlined,size: isWideScreen?24:24.sp,),
            // selectedIcon: const FaIcon(FontAwesomeIcons.folder),
            selectedColor: ColorManager.primary,
            // unSelectedColor: Colors.purple,
            // backgroundColor: Colors.orange,
            title:  Text('Doctors'),
          ),
          BottomBarItem(
            icon:  FaIcon(Icons.settings,size: isWideScreen?24:24.sp,),
            // selectedIcon: const FaIcon(FontAwesomeIcons.folder),
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
      body: PageView(
        onPageChanged: (value){
          setState(() {
            selected = value;
          });
        },
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          OrgHomePage(isWideScreen,isNarrowScreen),
          OrgPatientReports(),
          DoctorReportsPage(isWideScreen, isNarrowScreen),
          Settings(isWideScreen,isNarrowScreen),
        ],
      ),
    );
  }
}
