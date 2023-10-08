




import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/data/provider/common_provider.dart';
import 'package:medical_app/src/presentation/patient/reminders/data/reminder_db.dart';
import 'package:medical_app/src/presentation/patient/reminders/data/reminder_provider.dart';
import 'package:medical_app/src/presentation/patient/reminders/domain/model/reminder_model.dart';
import 'package:medical_app/src/presentation/patient/reminders/presentation/reminder_details.dart';

import '../../../../core/resources/value_manager.dart';
import '../../../common/snackbar.dart';
import '../widgets/create_reminder_test.dart';

class Reminders extends ConsumerStatefulWidget {
  const Reminders({super.key});

  @override
  ConsumerState<Reminders> createState() => _ReminderState();
}

class _ReminderState extends ConsumerState<Reminders> {

  NotificationServices notificationServices = NotificationServices();

  late Box<ReminderModel> reminderBox;
  late ValueListenable<Box<ReminderModel>> reminderBoxListenable;

  @override
  void initState() {
    super.initState();
    notificationServices.initializeNotifications();

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

    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
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
                      left: 50,
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
        body:reminderList.isNotEmpty
        ? SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 18.w),
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

                  final reminder = reminderList[index];

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorManager.white,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    child: ListTile(
                      onTap: ()=>Get.to(()=>ReminderIndividual(reminderModel: reminder)),
                      leading: CircleAvatar(
                        backgroundColor: ColorManager.primaryDark,
                        child: FaIcon(medicineType.firstWhere((element) => element.id == reminder.medicineType).icon,color: ColorManager.white.withOpacity(0.5),),
                      ),
                      title: Text(
                        '${reminder.medicineName}',
                        style: getMediumStyle(color: ColorManager.black, fontSize: 20),
                      ),
                      subtitle: Text(
                        '${reminder.strength} ${reminder.strengthUnitType} | ${reminder.medicineTime} | in 2 hours',
                        style: getRegularStyle(
                            color: ColorManager.black.withOpacity(0.7), fontSize: 12),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: ColorManager.blueText.withOpacity(0.8),
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
              ),

              h100
            ],
          ),
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No Reminders',style: getMediumStyle(color: ColorManager.white.withOpacity(0.5)),)
            ],
          ),
        )

      ),
    );
  }
}
