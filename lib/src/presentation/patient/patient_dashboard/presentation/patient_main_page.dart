import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../../notification/presentation/notification_page.dart';
import '../../../settings/settings_global.dart';
import 'patient_home_page.dart';
import '../../scan/presentation/qr_scan.dart';
import '../../utilities/presentation/patient_utilities.dart';



class PatientMainPage extends StatefulWidget {
  const PatientMainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PatientMainPage> createState() => _AnimatedBarExampleState();
}

class _AnimatedBarExampleState extends State<PatientMainPage> {
  dynamic selected;
  PageController controller = PageController();


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

      //to avoid the floating action button overlapping behavior,
      // when a soft keyboard is displayed
      // resizeToAvoidBottomInset: false,

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
            icon:  FaIcon(Icons.grid_view_outlined,size: isWideScreen?24:24.sp,),
            // selectedIcon: const FaIcon(FontAwesomeIcons.folder),
            selectedColor: ColorManager.primary,
            // unSelectedColor: Colors.purple,
            // backgroundColor: Colors.orange,
            title:  Text('Utilities'),
          ),
          BottomBarItem(
            icon:  FaIcon(Icons.notifications,size: isWideScreen?24:24.sp,),
            // selectedIcon: const FaIcon(FontAwesomeIcons.folder),
            selectedColor: ColorManager.primary,
            // unSelectedColor: Colors.purple,
            // backgroundColor: Colors.orange,
            title:  Text('Notifications'),
          ),
          BottomBarItem(
            icon:  FaIcon(Icons.menu,size: isWideScreen?24:24.sp,),
            // selectedIcon: const FaIcon(FontAwesomeIcons.folder),
            selectedColor: ColorManager.primary,
            // unSelectedColor: Colors.purple,
            // backgroundColor: Colors.orange,
            title:  Text('Menu'),
          ),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: selected ?? 0,
        onTap: (index) {
          controller.jumpToPage(index);
          setState(() {
            selected = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>Get.to(()=>QRViewExample()),
        backgroundColor: ColorManager.primaryOpacity80,
        child: FaIcon(Icons.qr_code_2_outlined,size: isWideScreen?40: 40.sp,)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PageView(
        controller: controller,
        children: [
          PatientHomePage(isWideScreen,isNarrowScreen),
          PatientUtilitiesPage(isWideScreen,isNarrowScreen),
          NotificationPage(),
          Settings(isWideScreen,isNarrowScreen)
        ],
      ),
    );
  }
}
