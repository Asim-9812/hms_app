
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/value_manager.dart';
import 'package:meroupachar/src/presentation/patient/reminder/presentation/general/widget/create_general_reminder.dart';
import 'package:meroupachar/src/presentation/patient/reminder/presentation/medicine/widget/create_med_reminder.dart';
import 'package:meroupachar/src/presentation/patient/reminder/presentation/medicine/widget/create_med_reminder_copy.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../data/provider/common_provider.dart';
import '../../../login/domain/model/user.dart';
import '../../profile/presentation/profile_page.dart';
import '../../reminder/presentation/reminder_tabs.dart';
import '../../utilities/presentation/patient_utilities.dart';
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
    // _permission();


  }

  // Future<void> _permission() async {
  //   final request = await NotificationController.displayNotificationRationale();
  //   print(request);
  // }
  // Future<void> _permission() async {
  //   final request = await NotificationService().notificationsPlugin.resolvePlatformSpecificImplementation<
  //       AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  //   print(request);
  // }







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
    final userBox = Hive.box<User>('session').values.toList();

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
            onPressed: () async {
              if(selected == 1){



                {
                  await showModalBottomSheet(

                      backgroundColor: ColorManager.primary,
                      context: context,
                      builder: (context){
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10)
                            )
                          ),
                          height: 150,
                          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap : (){
                                      Navigator.pop(context);
                                      Get.to(()=>CreateMedReminderCopy());

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: ColorManager.white
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 30.h),
                                      child: Icon(FontAwesomeIcons.pills,color: ColorManager.primary,),
                                    ),
                                  ),
                                  h10,
                                  Text('Medical Reminder',style: getRegularStyle(color: ColorManager.white,fontSize: 16.sp),)
                                ],
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap:(){
                                      Navigator.pop(context);
                                      Get.to(()=>CreateGeneralReminder());

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                         color: ColorManager.white
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 30.h),
                                      child: Icon(Icons.alarm_add,color: ColorManager.primary,),
                                    ),
                                  ),
                                  h10,
                                  Text('General Reminder',style: getRegularStyle(color: ColorManager.white,fontSize: 16.sp),)
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                  );
                }

                //Get.to(()=>CreateReminder(),transition: Transition.fade,curve: Curves.easeIn)
              }
              else{


              // Get.to(()=>NoticesUI());
              Get.to(()=>QRViewExample());
              }
            },
            // shape: CircleBorder(),
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
            PatientHomePage(isWideScreen,isNarrowScreen,noticeBool,userBox[0].orgId!),

            // TestNotification(title: 'new notification',),
            ReminderTabs(),
            PatientUtilities(isWideScreen,isNarrowScreen,userBox[0]),
            ProfilePage(userBox[0])
          ],
        ),
      ),
    );
  }
}
