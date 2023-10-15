




import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/data/provider/common_provider.dart';
import 'package:medical_app/src/presentation/patient/reminders/data/reminder_db.dart';
import 'package:medical_app/src/presentation/patient/reminders/data/reminder_provider.dart';
import 'package:medical_app/src/presentation/patient/reminders/domain/model/reminder_model.dart';
import 'package:medical_app/src/presentation/patient/reminders/presentation/reminder_details.dart';
import 'package:medical_app/src/presentation/patient/reminders/widgets/create_reminder.dart';

import '../../../../core/resources/value_manager.dart';
import '../../../common/snackbar.dart';
import '../widgets/create_reminder_test.dart';

class Reminders extends ConsumerStatefulWidget {


  @override
  ConsumerState<Reminders> createState() => _ReminderState();
}

class _ReminderState extends ConsumerState<Reminders>with TickerProviderStateMixin {

  // NotificationServices notificationServices = NotificationServices();

  late Box<ReminderModel> reminderBox;
  late ValueListenable<Box<ReminderModel>> reminderBoxListenable;

  int page  = 0;
  PageController _pageController = PageController(initialPage: 0);




  @override
  void initState() {



    super.initState();
    // notificationServices.initializeNotifications();

    // Open the Hive box
    reminderBox = Hive.box<ReminderModel>('medicine_reminder');

    // Create a ValueListenable for the box
    reminderBoxListenable = reminderBox.listenable();

    // Add a listener to update the UI when the box changes
    reminderBoxListenable.addListener(_onHiveBoxChanged);
  }

  void _onHiveBoxChanged() {
    // This function will be called whenever the Hive box changes.
    // You can update your UI or refresh the data here.
    setState(() {
      // Update your data or UI as needed
    });
  }

  @override
  void dispose() {
    // Be sure to remove the listener when the widget is disposed.
    reminderBoxListenable.removeListener(_onHiveBoxChanged);
    super.dispose();
  }







  @override
  Widget build(BuildContext context) {
    final reminderList = Hive.box<ReminderModel>('medicine_reminder').values.toList();
    final isMenuOpen = ref.watch(itemProvider).isMenuOpen;
    //TabController _tabController = TabController(length: 2, vsync: this);
    return GestureDetector(
      onTap: (){

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
                      reminderList.isNotEmpty
                          ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(left: 18.w,right: 18.w,bottom: 150),
                        itemCount: reminderList.length,
                        itemBuilder: (context, index) {

                          final currentTime = DateFormat('hh:mm a').format(DateTime.now());
                          final intakeTimes = reminderList[index].intakeTime;


                          // Sort the intakeTimes list in ascending order (upcoming times)
                          intakeTimes.sort((a, b) =>
                              DateFormat('hh:mm a').parse(a).compareTo(DateFormat('hh:mm a').parse(b)));

                          // Find the first time in intakeTimes that is after the current time
                          String? firstAfterCurrentTime;
                          for (final time in intakeTimes) {
                            if (DateFormat('hh:mm a').parse(time).isAfter(
                                DateFormat('hh:mm a').parse(currentTime))) {
                              firstAfterCurrentTime = time;
                              break;
                            }
                          }

                          if (firstAfterCurrentTime == null) {
                            // If no time in intakeTimes is after the current time, use the first time
                            firstAfterCurrentTime = intakeTimes.first;
                          }

                          //
                          // final difference = DateFormat('hh:mm a').parse(firstAfterCurrentTime).difference(
                          //     DateFormat('hh:mm a').parse(currentTime));
                          // String formattedDifference;
                          // if (difference.inHours.abs() < 1) {
                          //   // Less than 1 hour, format in minutes
                          //   formattedDifference = 'in ${difference.inMinutes.abs()} minutes';
                          // } else if (difference.inHours.abs() < 24) {
                          //   // Less than 24 hours, format in hours
                          //   formattedDifference = 'in ${difference.inHours.abs()} hours';
                          // } else {
                          //   // More than 24 hours, format in days
                          //   final days = difference.inDays.abs();
                          //   formattedDifference = 'in $days day${days > 1 ? 's' : ''}';
                          // }
                          //
                          // if (difference.isNegative) {
                          //   // If the difference is negative, adjust it as if counting backward
                          //   formattedDifference = 'in ${24 - difference.inHours.abs()} hours';
                          // }



                          reminderList.sort((a, b) => a.startDate.compareTo(b.startDate));
                          //
                          // bool today;
                          //
                          // DateTime now = DateTime.now();
                          // DateTime futureTime = now.add(difference); // Calculate the future time based on the difference
                          //
                          // if (futureTime.isAfter(DateTime(now.year, now.month, now.day))) {
                          //   // If the future time is before the current date, set today to false
                          //   today = false;
                          // } else {
                          //   today = true;
                          // }


                          final reminder = reminderList[index];








                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorManager.white,
                            ),
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            child: ListTile(
                              onTap: (){
                                ref.read(itemProvider.notifier).updateMenu(false);
                                Get.to(()=>ReminderIndividual(reminderModel: reminder));
                              },
                              leading: CircleAvatar(
                                backgroundColor:reminder.startDate.difference(DateTime.now()) <= Duration(days: 0) ? ColorManager.primaryDark : ColorManager.dotGrey,
                                child: FaIcon(medicineType.firstWhere((element) => element.id == reminder.medicineType).icon,color: ColorManager.white.withOpacity(0.5),),
                              ),
                              title: Text(
                                '${reminder.medicineName}',
                                style: getMediumStyle(color: ColorManager.black, fontSize: 20),
                              ),
                              subtitle: Text('${reminder.strength} ${reminder.strengthUnitType} | ${reminder.medicineTime} ',
                                style: getRegularStyle(
                                    color: ColorManager.black.withOpacity(0.7), fontSize: 12),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  color: reminder.startDate.difference(DateTime.now()) <= Duration(days: 0) ? ColorManager.primary.withOpacity(0.8):ColorManager.dotGrey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.h),
                                child: Text(
                                  '$firstAfterCurrentTime',
                                  style: getRegularStyle(color: ColorManager.white, fontSize: 12),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                          : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.rotate(

                                angle: pi*(0.5/4),
                                child: FaIcon(FontAwesomeIcons.calendarXmark,color: ColorManager.white.withOpacity(0.5),size: 50.sp,)),
                            h20,
                            Text('No Reminders',style: getMediumStyle(color: ColorManager.white.withOpacity(0.5)),),

                          ],
                        ),
                      ),
                      Center(
                        child: Text('Coming Soon...',style: getMediumStyle(color: ColorManager.white.withOpacity(0.7))),
                      )
                    ],
                  ),
                ),
              ],
            ),
            if(isMenuOpen)
              Positioned(
                bottom: 110,
                right: 120.w,
                child: Column(
                    children: [
                      FadeInUp(
                        duration: Duration(milliseconds: 200),
                        child: InkWell(
                          splashColor: MaterialStateColor.resolveWith((states) => ColorManager.primaryDark),
                          onTap: (){

                            Get.to(()=>CreateReminder());
                            ref.read(itemProvider.notifier).updateMenu(false);

                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: ColorManager.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: ColorManager.primaryDark
                                  )
                              ),
                              padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 18.w),
                              child: Row(
                                children: [
                                  FaIcon(Icons.add_alarm,color: ColorManager.primaryDark,),
                                  w10,
                                  Text('Medicine Reminder',style: getRegularStyle(color: ColorManager.primaryDark),)
                                ],
                              )),
                        ),
                      ),
                      h20,
                      FadeInUp(
                        duration: Duration(milliseconds: 300),
                        child: InkWell(
                          splashColor: MaterialStateColor.resolveWith((states) => ColorManager.primaryDark),
                          onTap: (){
                            final scaffoldMessage = ScaffoldMessenger.of(context);
                            scaffoldMessage.showSnackBar(
                              SnackbarUtil.showComingSoonBar(
                                message: 'Coming soon',
                                duration: const Duration(milliseconds: 1400),
                              ),
                            );
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: ColorManager.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: ColorManager.primaryDark
                                  )
                              ),
                              padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 18.w),
                              child: Row(
                                children: [
                                  FaIcon(Icons.add_alert_outlined,color: ColorManager.primaryDark,),
                                  w10,
                                  Text('General Reminder',style: getRegularStyle(color: ColorManager.primaryDark),)
                                ],
                              )),
                        ),
                      ),
                      h10,

                    ]
                ),
              ),

          ],
        )





      ),
    );
  }
}
