


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/presentation/patient/reminder_test/presentation/create_test.dart';
import 'package:medical_app/src/presentation/patient/reminder_test/presentation/test_detail.dart';

class TestRemind extends StatefulWidget {
  const TestRemind({super.key});

  @override
  State<TestRemind> createState() => _TestRemindState();
}

class _TestRemindState extends State<TestRemind> {



  late Box<Map<String,dynamic>> reminderBox;
  late ValueListenable<Box<Map<String,dynamic>>> reminderBoxListenable;

  int page  = 0;
  PageController _pageController = PageController(initialPage: 0);




  @override
  void initState() {



    super.initState();
    // notificationServices.initializeNotifications();

    // Open the Hive box
    reminderBox = Hive.box<Map<String,dynamic>>('test_reminder');

    // Create a ValueListenable for the box
    reminderBoxListenable = reminderBox.listenable();

    // Add a listener to update the UI when the box changes
    reminderBoxListenable.addListener(onHiveBoxChanged);
  }

  void onHiveBoxChanged() {
    // This function will be called whenever the Hive box changes.
    // You can update your UI or refresh the data here.
    setState(() {
      // Update your data or UI as needed
    });
  }

  @override
  void dispose() {
    // Be sure to remove the listener when the widget is disposed.
    reminderBoxListenable.removeListener(onHiveBoxChanged);
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {

    if(reminderBox.isEmpty){
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Text('NO REMINDERS'),

            ElevatedButton(onPressed: ()=>Get.to(()=>TestCreate()), child: Text('ADD'))

          ],
        ),
      );
    }

    else{
      final reminderList = reminderBox.values.toList();
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...reminderList.map((e) {
              List<String> timeStrings = e['scheduleTime'];
              List<TimeOfDay> times = timeStrings
                  .map((timeString) {
                final parsedTime = DateFormat('HH:mm').parse(timeString); // Use 'HH:mm' for 24-hour format
                return TimeOfDay.fromDateTime(parsedTime);
              })
                  .toList();

              final now = TimeOfDay.now();
              TimeOfDay targetTime = TimeOfDay(hour: now.hour, minute: now.minute); // The TimeOfDay you want to find the closest value to

              TimeOfDay closestTime = times[0]; // Initialize with the first time in the list
              Duration minDifference = Duration(
                hours: (times[0].hour - targetTime.hour).abs(),
                minutes: (times[0].minute - targetTime.minute).abs(),
              ); // Initialize with the time difference to the first time

              for (int i = 1; i < times.length; i++) {
                final difference = Duration(
                  hours: (times[i].hour - targetTime.hour).abs(),
                  minutes: (times[i].minute - targetTime.minute).abs(),
                );

                if (difference < minDifference) {
                  minDifference = difference;
                  closestTime = times[i];
                }
              }

              print("The closest time to $targetTime is $closestTime");




              return InkWell(
                onTap: ()=>Get.to(()=>TestDetails(e)),
                child: Container(
                  color:Colors.black,
                  padding: EdgeInsets.all(12.0),
                  margin: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${e['medicineName']}',style: TextStyle(color: Colors.white),),
                      Text('${closestTime.hour}:${closestTime.minute} ${closestTime.period.name}',style: TextStyle(color: Colors.white),),
                      Text('${e['frequency']['frequencyName']}',style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
              ) ;

            }).toList(),

            ElevatedButton(onPressed: ()=>Get.to(()=>TestCreate()), child: Text('ADD'))

          ],
        ),
      );
    }


  }
}
