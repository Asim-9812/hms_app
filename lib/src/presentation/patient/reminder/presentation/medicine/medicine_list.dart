


import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/presentation/patient/reminder/presentation/medicine/medDetails.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/style_manager.dart';
import '../../../../../core/resources/value_manager.dart';
import '../../../../../data/provider/common_provider.dart';
import '../../../../login/domain/model/user.dart';
import '../../domain/model/reminder_model.dart';



class MedReminders extends ConsumerStatefulWidget {


  @override
  ConsumerState<MedReminders> createState() => _MedRemindersState();
}

class _MedRemindersState extends ConsumerState<MedReminders> {



  late Box<Reminder> reminderBox;
  late ValueListenable<Box<Reminder>> reminderBoxListenable;

  @override
  void initState() {



    super.initState();
    // notificationServices.initializeNotifications();

    // Open the Hive box
    reminderBox = Hive.box<Reminder>('med_reminder');

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
    final userBox = Hive.box<User>('session').values.toList();

    final reminderList = Hive.box<Reminder>('med_reminder').values.where((element) => element.userId == userBox[0].username).toList();


    // String findClosestIntakeTime(List<String> intakeTimes) {
    //   final now = DateTime.now();
    //   DateTime? closestTime;
    //
    //   for (final intakeTime in intakeTimes) {
    //     try {
    //       final time = DateFormat('hh:mm a').parse(intakeTime);
    //
    //       if (time.isAfter(now) && (closestTime == null || time.isBefore(closestTime))) {
    //         closestTime = time;
    //       }
    //     } catch (e) {
    //       // Handle the case where parsing fails, e.g., due to a wrong format
    //       print('Error parsing time: $intakeTime');
    //     }
    //   }
    //
    //   if (closestTime != null) {
    //     return DateFormat('hh:mm a').format(closestTime);
    //   } else {
    //     // If no intake time is found, return the first intake time of the day
    //     return intakeTimes.isNotEmpty ? intakeTimes[0] : 'No Time Available';
    //   }
    // }


    if (reminderList.isNotEmpty) {
      return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 18.w,right: 18.w,bottom: 150),
      itemCount: reminderList.length,
      itemBuilder: (context, index) {

        // final closestIntakeTime = findClosestIntakeTime(reminderList[index].scheduleTime);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorManager.white,
          ),
          margin: EdgeInsets.symmetric(vertical: 8.h),
          child: ListTile(
            onTap: ()async{
              // NotificationService().scheduleNotification();
              ref.read(itemProvider.notifier).updateMenu(false);
              Get.to(()=>MedDetails(reminderList[index]));
            },
            // leading: CircleAvatar(
            //   backgroundColor:reminder.startDate.difference(DateTime.now()) <= Duration(days: 0) ? ColorManager.primaryDark : ColorManager.dotGrey,
            //   child: FaIcon(medicineType.firstWhere((element) => element.id == reminder.medicineType).icon,color: ColorManager.white.withOpacity(0.5),),
            // ),
            title: Text(
              '${reminderList[index].medicineName}',
              style: getMediumStyle(color: ColorManager.black, fontSize: 20),
            ),
            subtitle: Text('${reminderList[index].strength} ${reminderList[index].unit} | ${reminderList[index].meal}',
              style: getRegularStyle(
                  color: ColorManager.black.withOpacity(0.7), fontSize: 12),
            ),
            trailing: Container(
              decoration: BoxDecoration(
                color: reminderList[index].startDate.difference(DateTime.now()) <= Duration(days: 0) ? ColorManager.primary.withOpacity(0.8):ColorManager.dotGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.h),
              child: Text(
                reminderList[index].scheduleTime.first,
                style: getRegularStyle(color: ColorManager.white, fontSize: 12),
              ),
            ),
          ),
        );
      },
    );
    } else {
      return Center(
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
    );
    }
  }
}
