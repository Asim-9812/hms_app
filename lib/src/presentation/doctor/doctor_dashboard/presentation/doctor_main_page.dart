import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_dashboard/presentation/doctor_home_page.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_utilities/presentation/doctor_utilities.dart';
import 'package:meroupachar/src/presentation/video_chat/presentation/meeting_page.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../core/update_service/update_service.dart';
import '../../../../core/update_service/update_service_impl.dart';
import '../../../../data/provider/common_provider.dart';
import '../../../common/snackbar.dart';
import '../../../documents/presentation/document_page.dart';
import 'package:meroupachar/src/presentation/login/domain/model/user.dart';
import '../../../patient_reports/presentation/patient_report.dart';
import '../../profile/presentation/profile_page.dart';
import 'package:qrscan/qrscan.dart' as scanner;



class DoctorMainPage extends ConsumerStatefulWidget {
   DoctorMainPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<DoctorMainPage> createState() => _AnimatedBarExampleState();
}

class _AnimatedBarExampleState extends ConsumerState<DoctorMainPage> with SingleTickerProviderStateMixin {


  final UpdateService _updateService = UpdateServiceImpl();

  dynamic selected;
  PageController controller = PageController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController outputController = TextEditingController();


  late Animation<double> _animation;
  late AnimationController _animationController;




  void _onUpdateSuccess() {
    Widget alertDialogOkButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Ok")
    );
    AlertDialog alertDialog = AlertDialog(
      title: const Text("Update Successfully Installed"),
      content: const Text("Khata System has been updated successfully! ✔ "),
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
      content: Text("Khata System has failed to update because: \n $error"),
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
  void initState(){

    super.initState();

    _updateService.checkForInAppUpdate(_onUpdateSuccess, _onUpdateFailure);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);





  }

  //
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
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    final userBox = Hive.box<User>('session').values.toList();

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
          // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          //
          // //Init Floating Action Bubble
          // floatingActionButton: FloatingActionButton(
          //     onPressed: (){
          //       // Get.to(()=>TestPage());
          //       final scaffoldMessage = ScaffoldMessenger.of(context);
          //       scaffoldMessage.showSnackBar(
          //           SnackbarUtil.showSuccessSnackbar(
          //               message: 'Coming Soon',
          //               duration: const Duration(milliseconds: 1200)
          //           )
          //       );
          //     },
          //   backgroundColor: ColorManager.primary,
          //   child: FaIcon(CupertinoIcons.chat_bubble_2_fill,color: ColorManager.white,),
          //
          //     ),

          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

          //Init Floating Action Bubble
          floatingActionButton: FloatingActionBubble(
            // Menu items
            items: <Bubble>[

              // Floating action menu item
              Bubble(
                title:"Video call",
                iconColor :ColorManager.white,
                bubbleColor : ColorManager.primary,
                icon:CupertinoIcons.video_camera_solid,
                titleStyle:TextStyle(fontSize: 16 , color: ColorManager.white),
                onPress: () {
                  _animationController.reverse();
                  Get.to(()=>MeetingPage());
                },
              ),
              // Floating action menu item
              Bubble(
                title:"Chat",
                iconColor :ColorManager.white,
                bubbleColor : ColorManager.primary,
                icon:CupertinoIcons.chat_bubble_2_fill,
                titleStyle:TextStyle(fontSize: 16 , color: ColorManager.white),
                onPress: () {
                  _animationController.reverse();
                  final scaffoldMessage = ScaffoldMessenger.of(context);
                  scaffoldMessage.showSnackBar(
                      SnackbarUtil.showSuccessSnackbar(
                          message: 'Coming Soon',
                          duration: const Duration(milliseconds: 1200)
                      )
                  );
                },
              ),
              Bubble(
                title:"Scan",
                iconColor :ColorManager.white,
                bubbleColor : ColorManager.primary,
                icon:CupertinoIcons.qrcode_viewfinder,
                titleStyle:TextStyle(fontSize: 16 , color: ColorManager.white),
                onPress: () {
                  _animationController.reverse();
                  _scan();
                },
              ),

            ],

            // animation controller
            animation: _animation,

            // On pressed change animation state
            onPress: () => _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward(),

            // Floating Action button Icon color
            iconColor: ColorManager.white,

            // Floating Action button Icon
            iconData: CupertinoIcons.group_solid,
            backGroundColor: ColorManager.primary,

          ),

          body: PageView(
          onPageChanged: (value){
            setState(() {
              selected = value;
            });
          },
          controller: controller,
          children: [
            DoctorHomePage(isWideScreen,isNarrowScreen,noticeBool,userBox[0].code!),
            DocumentPage(isWideScreen,isNarrowScreen,false),
            PatientReports(userCode : userBox[0].code!,userId: userBox[0].userID!,),
            DoctorUtilityPage(),
            DocProfilePage(userBox[0])
          ],
        ),
      ),
    );
  }


  Future _scan() async {
    await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      // print(barcode);
      // this.outputController.text = barcode;
      redirectUrl(barcode);
    }
  }

  void redirectUrl(String url) {
    if (url.startsWith('https://')) {
      // url = url.replaceFirst('https://', '');
      UrlLauncher.openUrl(url);
    } else if (url.startsWith('http://')) {
      url = url.replaceFirst('http://', '');
      UrlLauncher.openUrl(url);
    } else{
      UrlLauncher.openUrl(url);
    }
  }


}


class UrlLauncher {
  UrlLauncher._();

  static Future<void> openUrl(String code) async {
    // final Uri uri = Uri(
    //     path: code,
    //     scheme: 'https'
    // );
    launchUrlString(code,mode: LaunchMode.externalApplication);
  }
}