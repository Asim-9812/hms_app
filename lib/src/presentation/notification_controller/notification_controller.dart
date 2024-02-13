import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_tasks/domain/model/task_model.dart';
import 'package:meroupachar/src/presentation/login/presentation/status_page.dart';
import 'package:meroupachar/src/presentation/patient/reminder/domain/model/general_reminder_model.dart';
import 'package:meroupachar/src/presentation/patient/reminder/domain/model/reminder_model.dart';
import 'package:meroupachar/src/presentation/patient/reminder/presentation/general/generalDetails.dart';
import 'package:meroupachar/src/presentation/patient/reminder/presentation/medicine/medDetails.dart';
import '../../app/app.dart';
import '../login/domain/model/user.dart';








///  *********************************************
///     NOTIFICATION CONTROLLER
///  *********************************************

class NotificationController {


  static ReceivedAction? initialAction;
  static bool isPostAlarmExecuted = false;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification for meroUpachar',
              playSound: true,
              onlyAlertOnce: true,
              criticalAlerts: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple
          ),
          NotificationChannel(
              channelKey: 'general_alerts',
              channelName: 'General_Alerts',
              channelDescription: 'Notification for meroUpachar',
              playSound: true,
              onlyAlertOnce: true,
              criticalAlerts: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple
          )
        ],

        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static ReceivePort? receivePort;

  @pragma('vm:entry-point')
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
              (silentData){
                print('this is the silent data : $silentData');
              });

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(
        receivePort!.sendPort, 'notification_action_port');
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(
      // onNotificationDisplayedMethod: onDisplayedAction,
      onActionReceivedMethod: onActionReceivedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  // @pragma('vm:entry-point')
  // static Future<void> onDisplayedAction(
  //     ReceivedNotification receivedAction) async {
  //
  //   print('notification displayed');
  //   await initializeLocalNotifications();
  //   await initializeIsolateReceivePort();
  //   await startListeningNotificationEvents();
  // }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {


    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.DismissAction) {
      // For background actions, you must hold the execution until the end
      if(receivedAction.buttonKeyPressed == 'SNOOZE'){
        // final SnackBar snackBar = SnackBar(content: Text("Snoozed for 5 minutes"));
        // snackBarKey.currentState?.showSnackBar(snackBar);
        await snoozeMedNotification(receivedAction);

      }
      else if(receivedAction.buttonKeyPressed == 'DISMISSED'){
        print('dismissed action received');
        await onDismissActionReceivedMethod(receivedAction);
      }
    }

    else {
      // this process is only necessary when you need to redirect the user
      // to a new page or use a valid context, since parallel isolates do not
      // have valid context, so you need redirect the execution to main isolate
      if (receivePort == null) {


        print(
            'onActionReceivedMethod was called inside a parallel dart isolate.');
        SendPort? sendPort =
        IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          print('Redirecting the execution to main isolate process.');
          sendPort.send(receivedAction);
          return;
        }
      }
      return onActionReceivedImplementationMethod(receivedAction);
    }
  }


  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {

        if (receivedAction.buttonKeyPressed != 'DISMISSED' && !isPostAlarmExecuted) {
          await postAlarmNotification(receivedAction);
          isPostAlarmExecuted = true;
          print('executed');
        }





  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {

    // onDismissActionReceivedMethod(receivedAction);
    final payload = receivedAction.payload;
    final userBox = Hive.box<User>('session').values.toList();

    if(payload != null && payload['reminderTypeId'] == '1'){

      final allReminderBox = Hive.box<Reminder>('med_reminder');
      final reminderBox = Hive.box<Reminder>('med_reminder').values.toList();
      final reminderIndex = reminderBox.indexWhere((element) => element.medicineName == receivedAction.title);
      final reminder = reminderBox.firstWhere((element) => element.medicineName == receivedAction.title);
      Get.to(()=>MedDetails(reminder,userBox[0]));
    }

    else if(payload != null && payload['reminderTypeId'] == '2'){

      final allReminderBox = Hive.box<GeneralReminderModel>('general_reminder_box');
      final reminderBox = Hive.box<GeneralReminderModel>('general_reminder_box').values.toList();
      final reminderIndex = reminderBox.indexWhere((element) => element.title == receivedAction.title);
      final reminder = reminderBox.firstWhere((element) => element.title == receivedAction.title);
      Get.to(()=>GeneralDetails(reminder));
    }

    else{
      final userBox =await Hive.box<User>('session').values.toList();
      int? accId = userBox.first.typeID;
      Get.to(()=>StatusPage(accountId: accId ?? 0));
    }


    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //     '/notification-page',
    //         (route) =>
    //     (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);


  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************

  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }




  @pragma('vm:entry-point')
  static Future<void> scheduleTaskNotification(BuildContext context,{required TaskModel reminder}) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;
    await myNotifyTaskSchedule(
        reminder: reminder);
  }



  @pragma('vm:entry-point')
  static Future<void> scheduleNotifications({
    required NotificationSchedule schedule,
    required NotificationContent content,
  }) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;
    await myNotificationSchedules(schedule: schedule,content: content);
  }

  @pragma('vm:entry-point')
  static Future<void> scheduleInitialNotifications({
    required NotificationSchedule schedule,
    required NotificationContent content,
  }) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;
    await myInitialNotificationSchedules(schedule: schedule,content: content);
  }







  static Future<void> snoozeMedNotification(ReceivedAction receivedAction) async {
    await snoozeAlarm(
        receivedAction: receivedAction);
  }


  /// if the alarm isnt dismissed or snoozed automatically , this is executed after 10 mins

  static Future<void> postAlarmNotification(ReceivedAction receivedAction) async {

    await postAlarm(
        receivedAction: receivedAction);
  }



  static Future<void> cancelNotifications({
    required int id
}) async {
    await AwesomeNotifications().cancel(id);
  }
}


Future<void> snoozeAlarm({
  required ReceivedAction receivedAction
}) async {
  print('alarm snoozed');
  // var nowDate = DateTime.now().add(Duration(hours: hoursFromNow, seconds: 5));
  await AwesomeNotifications().createNotification(
    schedule: NotificationInterval(interval: 300,repeats: false,timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()),
    content: NotificationContent(
      id: -1,
      channelKey: 'alerts',
      title: '${receivedAction.title}',
      body: '${receivedAction.body}',
      notificationLayout: NotificationLayout.Default,
      //actionType : ActionType.DisabledAction,
      color: Colors.black,
      backgroundColor: Colors.black,
      category: NotificationCategory.Alarm,
      timeoutAfter: Duration(minutes: 1)

    ),
    actionButtons: [
      NotificationActionButton(
          key: 'SNOOZE',
          label: 'Snooze',
          actionType: ActionType.SilentAction
      ),
      NotificationActionButton(
          key: 'DISMISSED',
          label: 'Dismiss',
          actionType: ActionType.DismissAction
      ),
    ],
  );
}

Future<void> postAlarm({
  required ReceivedAction receivedAction
}) async {
  // var nowDate = DateTime.now().add(Duration(hours: hoursFromNow, seconds: 5));
  await AwesomeNotifications().createNotification(
    schedule: NotificationInterval(interval: 600,repeats: false,timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()),
    content: NotificationContent(
      id: -1,
      channelKey: 'alerts',
      title: '${receivedAction.title}',
      body: '${receivedAction.body}',
      notificationLayout: NotificationLayout.Default,
      timeoutAfter: Duration(minutes: 1),
      color: Colors.black,
      backgroundColor: Colors.black,
      category: NotificationCategory.Alarm,
      // actionType: ActionType.DisabledAction,
      customSound: 'resource://raw/notif',
      payload: {'postAlarm' : 'true'},
    ),
    actionButtons: [
      NotificationActionButton(
          key: 'SNOOZE',
          label: 'Snooze',
          actionType: ActionType.SilentAction
      ),
      NotificationActionButton(
          key: 'DISMISSED',
          label: 'Dismiss',
          actionType: ActionType.Default
      ),
    ],
  );
}



Future<void> myNotifyTaskSchedule({
  required TaskModel reminder
}) async {
  DateTime remind = DateFormat('hh:mm a, yyyy-MM-dd').parse(reminder.remindDate!);
  await AwesomeNotifications().createNotification(
    schedule:
    NotificationCalendar(
        year: remind.year,
        month: remind.month,
        day: remind.day,
        hour: remind.hour,
        minute: remind.minute,
        repeats: false
    ),
    content: NotificationContent(
      id: reminder.taskId,
      channelKey: 'alerts',
      title: '${reminder.taskName}',
      body: '${reminder.remindDate}',
      notificationLayout: NotificationLayout.Default,
      //actionType : ActionType.DisabledAction,
      color: Colors.black,
      backgroundColor: Colors.black,
      // customSound: 'resource://raw/notif',
      payload: {'actPag': 'myAct', 'actType': 'medicine'},
    ),
    actionButtons: [
      NotificationActionButton(
          key: 'SNOOZE2',
          label: 'Snooze',
          actionType: ActionType.SilentAction
      ),
      NotificationActionButton(
          key: 'DISMISSED',
          label: 'Dismiss',
          actionType: ActionType.Default
      ),
    ],
  );



}




Future<void> myNotificationSchedules({
  required NotificationSchedule schedule,
  required NotificationContent content,
}) async {



  await AwesomeNotifications().createNotification(
    schedule: schedule,
    content: content,
    actionButtons: [
      NotificationActionButton(
          key: 'SNOOZE',
          label: 'Snooze',
          actionType: ActionType.SilentAction
      ),
      NotificationActionButton(
          key: 'DISMISSED',
          label: 'Dismiss',
          actionType: ActionType.DismissAction
      ),
    ],
  );



}



Future<void> myInitialNotificationSchedules({
  required NotificationSchedule schedule,
  required NotificationContent content,
}) async {



  await AwesomeNotifications().createNotification(
    schedule: schedule,
    content: content,
  );


}








