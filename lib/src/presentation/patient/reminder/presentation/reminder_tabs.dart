





import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/data/provider/common_provider.dart';
import 'package:meroupachar/src/presentation/patient/reminder/presentation/general/general_list.dart';
import 'package:meroupachar/src/presentation/patient/reminder/presentation/medicine/widget/create_med_reminder.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../notification_controller/notification_controller.dart';
import 'general/widget/create_general_reminder.dart';
import 'medicine/medicine_list.dart';

class ReminderTabs extends ConsumerStatefulWidget {


  @override
  ConsumerState<ReminderTabs> createState() => _ReminderState();
}

class _ReminderState extends ConsumerState<ReminderTabs>with TickerProviderStateMixin {

  // NotificationServices notificationServices = NotificationServices();
  int page  = 0;
  PageController _pageController = PageController(initialPage: 0);




  @override
  Widget build(BuildContext context) {


    final isMenuOpen = ref.watch(itemProvider).isMenuOpen;
    //TabController _tabController = TabController(length: 2, vsync: this);
    return GestureDetector(
      onTap: () {

        ref.read(itemProvider.notifier).updateMenu(false);

      },
      child: Scaffold(

          backgroundColor: ColorManager.primaryDark,
          appBar: AppBar(
            backgroundColor: ColorManager.primaryDark,
            elevation: 0,
            toolbarHeight: 100,
            centerTitle: true,
            titleSpacing: 0,
            title: Container(
                width: double.infinity,
                height: 100,

                child: Stack(
                  children: [
                    Positioned(
                        top: 20,
                        right: 60,

                        child: Transform.rotate(
                            angle: 320 * 3.14159265358979323846 / 180,
                            child: ZoomIn(
                                duration: Duration(seconds: 1),
                                child: FaIcon(CupertinoIcons.alarm,color: ColorManager.white.withOpacity(0.3),size: 70,)))
                    ),
                    Positioned(
                        top: 20,
                        left: 40,
                        child: Transform.rotate(
                            angle: 30 * 3.14159265358979323846 / 180,
                            child: ZoomIn(
                                duration: Duration(seconds: 1),
                                child: FaIcon(FontAwesomeIcons.notesMedical,color: ColorManager.white.withOpacity(0.3),size: 80,)))
                    ),
                    Center(child: Text('Reminder',style: getHeadBoldStyle(color: ColorManager.white),)),
                  ],
                )),

          ),




          body: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 18.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                page =0;

                              });
                              _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);


                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color:page == 0?  ColorManager.white :ColorManager.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5)

                              ),
                              padding: EdgeInsets.symmetric(vertical: 24.h),
                              child:  Center(child: Text('Medicinal',style: getMediumStyle(color: page == 0?ColorManager.primary: ColorManager.white,fontSize: 20),)),
                            ),
                          ),
                        ),
                        w10,
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                page =1;

                              });
                              _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color:page == 1?  ColorManager.white :ColorManager.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              padding: EdgeInsets.symmetric(vertical: 24.h),
                              child:  Center(child: Text('General',style: getMediumStyle(color: page == 1? ColorManager.primary: ColorManager.white,fontSize: 20),)),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  h20,
                  Container(
                    height: 700.h,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (value){
                        setState(() {
                          page = value;
                        });
                      },
                      children: [
                        MedReminders(),
                        GeneralReminders()
                      ],
                    ),
                  ),
                ],
              ),


            ],
          )





      ),
    );
  }
}
