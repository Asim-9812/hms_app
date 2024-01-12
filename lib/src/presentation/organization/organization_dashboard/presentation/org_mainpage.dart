
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/presentation/organization/org_profile/presentation/org_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/presentation/organization/doctor_statistics/presentation/doctor_stat_page.dart';
import 'package:meroupachar/src/presentation/organization/organization_dashboard/presentation/org_homepage.dart';
import 'package:meroupachar/src/presentation/video_chat/presentation/meeting_page.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../../core/update_service/update_service.dart';
import '../../../../core/update_service/update_service_impl.dart';
import '../../../../data/provider/common_provider.dart';
import '../../../login/domain/model/user.dart';
import '../../../patient_reports/presentation/patient_report.dart';


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

  final UpdateService _updateService = UpdateServiceImpl();


  void _onUpdateSuccess() {
    Widget alertDialogOkButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Ok")
    );
    AlertDialog alertDialog = AlertDialog(
      title: const Text("Update Successfully Installed"),
      content: const Text("MeroUpachar has been updated successfully! ✔ "),
      actions: [
        alertDialogOkButton
      ],
    );
    showDialog(context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }  );
  }

  void _onUpdateFailure(String error) {
    Widget alertDialogTryAgainButton = TextButton(
        onPressed: () {
          _updateService.checkForInAppUpdate(_onUpdateSuccess, _onUpdateFailure);
          Navigator.pop(context);
        },
        child: const Text("Try Again?")
    );
    Widget alertDialogCancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("Dismiss"),
    );
    AlertDialog alertDialog = AlertDialog(
      title: const Text("Update Failed To Install ❌"),
      content: Text("MeroUpachar has failed to update because: \n $error"),
      actions: [
        alertDialogTryAgainButton,
        alertDialogCancelButton
      ],
    );
    showDialog(context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }


  @override
  void initState() {
    super.initState();
    _updateService.checkForInAppUpdate(_onUpdateSuccess, _onUpdateFailure);
  }

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
    final noticeBool = ref.watch(itemProvider).noticeChange;

    final userBox = Hive.box<User>('session').values.toList();

    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;

    return Scaffold(
      extendBody: true, //to make floating action button notch transparent


      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: ColorManager.primary,
      //   onPressed: ()=>Get.to(()=>MeetingPage()),
      //   child: Icon(CupertinoIcons.video_camera_solid,color: ColorManager.white,),),
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
          OrgHomePage(isWideScreen,isNarrowScreen,noticeBool,userBox[0].code!),
          PatientReports(userCode : userBox[0].code!,userId: userBox[0].userID!,),
          DoctorReportsPage(isWideScreen, isNarrowScreen),
          OrgProfilePage(userBox[0]),
        ],
      ),
    );
  }
}
