import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/app/app.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_tasks/domain/model/task_model.dart';
import 'package:meroupachar/src/presentation/login/domain/model/user.dart';
import 'package:meroupachar/src/presentation/notification_controller/notification_controller.dart';
import 'package:meroupachar/src/presentation/patient/calories/domain/model/calories_model.dart';
import 'package:meroupachar/src/presentation/patient/reminder/domain/model/general_reminder_model.dart';
import 'package:meroupachar/src/presentation/patient/reminder/domain/model/reminder_model.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:background_fetch/background_fetch.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:workmanager/workmanager.dart';



@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    try{
      final allDateList = inputData!['dateList'] as List<dynamic>;
      final todayList = allDateList.where((element) => (DateFormat('yyyy-MM-dd').format(DateTime.parse(element))).toString() == (DateFormat('yyyy-MM-dd').format(DateTime.now())).toString()).toList();
      // final body = inputData!['name'];
      print(todayList);
      return Future.value(true);
    } catch(e){
      print(e);
      return Future.value(false);
    }


    //final todayList = allDateList.where((element) => DateFormat('yyyy-MM-dd').format(DateTime.parse(element)) == DateFormat('yyyy-MM-dd').format(DateTime.now())).toList();
    //
    // // List to hold all the Future objects for notifications
    // List<Future<void>> notificationFutures = [];
    //
    // for(var dates in todayList){
    //   int i = 20;
    //   // Create notification and add the Future to the list
    //   notificationFutures.add(
    //       AwesomeNotifications().createNotification(
    //           content: NotificationContent(
    //             id: 234,
    //             channelKey: 'alerts',
    //             title: task,
    //             body: body,
    //             criticalAlert: true,
    //           ),
    //           schedule: NotificationInterval(interval: i)
    //       )
    //   );
    //   print(i);
    //   i += 20;
    // }
    //
    // // Wait for all notifications to be created
    // await Future.wait(notificationFutures);
    // print("Native called background task: $task");
    // print("Native called background task: $inputData");




  });
}

// final box = Provider<String?>((ref) => null);

final boxA = Provider<List<User>>((ref) => []);

late Box userBox2;

//
// void backgroundFetchHeadlessTask() async {
//   print('background execution');
//   await NotificationController.initializeLocalNotifications();
//   await NotificationController.initializeIsolateReceivePort();
//   await NotificationController.startListeningNotificationEvents();
// }



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // tz.initializeTimeZones();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);


  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();



  // BackgroundFetch.configure(
  //     BackgroundFetchConfig(
  //         minimumFetchInterval: 15, // minimum interval in minutes
  //         stopOnTerminate: false,
  //         enableHeadless: true
  //     ),
  //     backgroundFetchHeadlessTask
  // );





  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };




  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,

      )
  );


  await Hive.initFlutter();
  Hive.registerAdapter<User>(UserAdapter());
  Hive.registerAdapter<Reminder>(ReminderAdapter());
  Hive.registerAdapter<DateListModel>(DateListModelAdapter());
  Hive.registerAdapter<Frequency>(FrequencyAdapter());
  Hive.registerAdapter<ReminderPattern>(ReminderPatternAdapter());
  Hive.registerAdapter(GeneralReminderModelAdapter());
  Hive.registerAdapter(InitialReminderAdapter());
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(AddFoodModelAdapter());
  Hive.registerAdapter(ActivitiesModelAdapter());
  Hive.registerAdapter(ActivityTypeModelAdapter());
  Hive.registerAdapter(GoalTypeModelAdapter());
  Hive.registerAdapter(CaloriesIntakeModelAdapter());
  Hive.registerAdapter(CaloriesBurnedModelAdapter());
  Hive.registerAdapter(UserInfoCaloriesAdapter());
  Hive.registerAdapter(CaloriesTrackingModelAdapter());


  // final userBox = await Hive.openBox<String>('user1');
  await Hive.openBox<String>('tokenBox');
  final userSession = await Hive.openBox< User>('session');
  await Hive.openBox('user');
  await Hive.openBox<Reminder>('med_reminder');
  await Hive.openBox<GeneralReminderModel>('general_reminder_box');
  await Hive.openBox<TaskModel>('doc_tasks');
  await Hive.openBox<AddFoodModel>('food_box');
  await Hive.openBox<ActivitiesModel>('saved_activities_box');
  await Hive.openBox<UserInfoCalories>('saved_userInfo_box');
  await Hive.openBox<CaloriesTrackingModel>('saved_userCalories_box');




  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );



  runApp(ProviderScope(
      overrides: [
        // box.overrideWithValue(userBox.get('userData')),
        boxA.overrideWithValue(userSession.values.toList()),
      ],

      child: MyApp()
  ));
}

