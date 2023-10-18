import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/dummy_datas/dummy_datas.dart';
import 'package:medical_app/src/presentation/patient/reminder/notifications/notification_services.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../../data/provider/common_provider.dart';
import '../../../../test.dart';
import '../../../notices/presentation/notices.dart';
import '../../../notification/presentation/notification_page.dart';
import '../../../settings/settings_global.dart';
import '../../profile/presentation/profile_page.dart';
import '../../reminder/presentation/reminder_tabs.dart';
import '../../utilities/presentation/patient_utilities_test.dart';
import 'patient_home_page.dart';
import '../../scan/presentation/qr_scan.dart';



class PatientMainPage extends ConsumerStatefulWidget {
  const PatientMainPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PatientMainPage> createState() => _AnimatedBarExampleState();
}

class _AnimatedBarExampleState extends ConsumerState<PatientMainPage> {
  dynamic selected;

  PageController controller = PageController();



  bool _isMenuOpen = false;





  @override
  void initState(){
    super.initState();
    _permission();


  }

  Future<void> _permission() async {
    final request = await NotificationService().notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    print(request);
  }







  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    final isMenuOpen = ref.watch(itemProvider).isMenuOpen;
    final scaffoldMessage = ScaffoldMessenger.of(context);
    final noticeBool = ref.watch(itemProvider).noticeChange;
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;

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
              icon:  FaIcon(Icons.calendar_month,size: isWideScreen?24:24.sp,),
              // selectedIcon: const FaIcon(FontAwesomeIcons.folder),
              selectedColor: ColorManager.primary,
              // unSelectedColor: Colors.purple,
              // backgroundColor: Colors.orange,
              title:  Text('Reminder'),
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
              icon:  Container(
                // color: ColorManager.red,
                  width: isWideScreen?30:30.sp,

                  child: Stack(
                    children: [
                      Center(child: Padding(

                        padding:  EdgeInsets.only(top: 2),
                        child: FaIcon(Icons.person,size: isWideScreen?24:24.sp,),
                      )),
                      Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 6.sp,
                          backgroundColor: ColorManager.red.withOpacity(0.7),
                        ),
                      )
                    ],
                  )),
              // selectedIcon: const FaIcon(FontAwesomeIcons.folder),
              selectedColor: ColorManager.primary,
              // unSelectedColor: Colors.purple,
              // backgroundColor: Colors.orange,
              title:  Text('Profile'),
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
            onPressed: () {
              if(selected == 1){



                ref.read(itemProvider.notifier).updateMenu(!isMenuOpen);

                //Get.to(()=>CreateReminder(),transition: Transition.fade,curve: Curves.easeIn)
              }
              else{


              // Get.to(()=>NoticesUI());
              Get.to(()=>QRViewExample());
              }
            },
            backgroundColor: selected == 1? ColorManager.white:ColorManager.primaryOpacity80,
            child: FaIcon(selected == 1? !isMenuOpen ? Icons.add_alarm:CupertinoIcons.xmark:Icons.qr_code_2_outlined,size: isWideScreen?40: 40.sp,color: selected == 1? ColorManager.primaryOpacity80:ColorManager.white,)
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: PageView(
          onPageChanged: (value){
            setState(() {
              selected = value;
            });
            ref.read(itemProvider.notifier).updateMenu(false);
          },
          controller: controller,
          children: [
            PatientHomePage(isWideScreen,isNarrowScreen,noticeBool),

            // TestNotification(title: 'new notification',),
            ReminderTabs(),
            PatientUtilities(isWideScreen,isNarrowScreen),
            ProfilePage()
          ],
        ),
      ),
    );
  }
}
