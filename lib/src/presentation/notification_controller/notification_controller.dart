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
import 'package:meroupachar/src/presentation/patient/reminder/presentation/reminder_tabs.dart';

import '../../../main.dart';
import '../../app/app.dart';
import '../login/domain/model/user.dart';
import '../patient/patient_dashboard/presentation/patient_main_page.dart';








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
              ledColor: Colors.deepPurple)
        ],

        debug: false);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
              (silentData) => onActionReceivedImplementationMethod(silentData));

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
        .setListeners(onActionReceivedMethod: onActionReceivedMethod,onDismissActionReceivedMethod: (receivedAction){
          print('Action received');
          return onDismissActionReceivedMethod(receivedAction);
    },);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {

    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
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


    print(receivedAction.payload);

    final payload = receivedAction.payload;
    if(payload !=null){
      if(payload['reminderTypeId'] == '1'){
        print('executed 2');
        final allReminderBox = Hive.box<Reminder>('med_reminder');
        final reminderBox = Hive.box<Reminder>('med_reminder').values.toList();
        final reminderIndex = reminderBox.indexWhere((element) => element.medicineName == receivedAction.title);
        final reminder = reminderBox.firstWhere((element) => element.medicineName == receivedAction.title);
        cancelNotifications(id: reminder.contentId);
        cancelNotifications(id: reminder.initialContentId);
        final dateList = reminder.dateList;
        final index = dateList.indexWhere((element) => element.dateId.toString() == payload['dateId'])+1;
        if(dateList.length > index){
          print(index);
          final newDate = dateList[index];
          final newInitialDate = newDate.reminderDate.subtract(Duration(minutes: 10));
          print(newDate.reminderDate);
          print(newInitialDate);
          final contentId = Random().nextInt(9999);
          final initialContentId = Random().nextInt(9999);
          await scheduleNotifications(
              content: NotificationContent(
                  id: contentId,
                  channelKey: 'alerts',
                  title: reminder.medicineName,
                  body: '${reminder.strength} ${reminder.unit} ${reminder.meal}',
                  payload: {
                    'reminderTypeId' : '1',
                    'dateId' : newDate.dateId.toString()
                  },
                  criticalAlert: true,
                  displayOnBackground: true,
                  displayOnForeground: true,
                  fullScreenIntent: true,
                  wakeUpScreen: true,
                  category: NotificationCategory.Alarm,
                  timeoutAfter: const Duration(minutes: 1)
              ),
              schedule: NotificationCalendar(
                  year: newDate.reminderDate.year,
                  month: newDate.reminderDate.month,
                  day: newDate.reminderDate.day,
                  hour: newDate.reminderDate.hour,
                  minute: newDate.reminderDate.minute,
                  timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
              )
          );
          await scheduleInitialNotifications(
              schedule:NotificationCalendar(
                  year: newInitialDate.year,
                  month: newInitialDate.month,
                  day: newInitialDate.day,
                  hour: newInitialDate.hour,
                  minute: newInitialDate.minute,
                  timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
              ),
              content: NotificationContent(
                id: initialContentId,
                channelKey: 'alerts',
                title: reminder.medicineName,
                body: '10 minutes before your medicine',
                notificationLayout: NotificationLayout.Default,
                //actionType : ActionType.DisabledAction,
                color: Colors.black,
                wakeUpScreen: true,
                displayOnForeground: true,
                displayOnBackground: true,
                backgroundColor: Colors.black,
              )
          );
          Reminder reminderModel = Reminder(
              reminderId: reminder.reminderId,
              userId: reminder.userId,
              medTypeId: reminder.medTypeId,
              medTypeName: reminder.medTypeName,
              medicineName: reminder.medicineName,
              strength: reminder.strength,
              unit: reminder.unit,
              frequency: reminder.frequency,
              scheduleTime: reminder.scheduleTime,
              medicationDuration: reminder.medicationDuration,
              startDate: reminder.startDate,
              endDate: reminder.endDate,
              mealTypeId: reminder.mealTypeId,
              meal: reminder.meal,
              reminderPattern: reminder.reminderPattern,
              reminderImage: reminder.reminderImage,
              notes: reminder.notes,
              summary: reminder.summary,
              contentId: contentId,
              dateList: reminder.dateList,
              reminderTypeId: 1,
              initialContentId: initialContentId
          );
          allReminderBox.putAt(reminderIndex, reminderModel);

        }
      }
      else if(payload['reminderTypeId'] == '2'){
        final allReminderBox = Hive.box<GeneralReminderModel>('general_reminder_box');
        final reminderBox = Hive.box<GeneralReminderModel>('general_reminder_box').values.toList();
        final reminderIndex = reminderBox.indexWhere((element) => element.title == receivedAction.title);
        final reminder = reminderBox.firstWhere((element) => element.title == receivedAction.title);
        cancelNotifications(id: reminder.contentId);
        if(reminder.initialReminder != null){
          cancelNotifications(id: reminder.initialContentId!);
        }

        int addedTime = 0;
        Duration? duration ;
        final contentId = Random().nextInt(9999);
        final initialContentId = Random().nextInt(9999);

        if(reminder.initialReminder != null){
          addedTime = reminder.initialReminder!.initialReminder;
          if(reminder.initialReminder!.initialReminderTypeId == 1){
            duration = Duration(minutes: addedTime);
          }
          else if(reminder.initialReminder!.initialReminderTypeId  == 2){
            duration = Duration(hours: addedTime);
          }
          else if(reminder.initialReminder!.initialReminderTypeId  == 3){
            duration = Duration(days: addedTime);
          }
        }
        if(reminder.reminderPattern.reminderPatternId ==2){
          final dateList = DateTime.parse(payload['dateTime']!);
          final newDate = dateList.add(Duration(days: 1));

          final newInitialDate = newDate.subtract(duration??Duration(seconds: 0));
          scheduleNotifications(
              content: NotificationContent(
                  id: contentId,
                  channelKey: 'alerts',
                  title: reminder.title,
                  body: reminder.description,
                  payload: {
                    'reminderTypeId' : '2',
                    'dateId' : newDate.toString()
                  },
                  criticalAlert: true,
                  displayOnBackground: true,
                  displayOnForeground: true,
                  fullScreenIntent: true,
                  wakeUpScreen: true,
                  category: NotificationCategory.Alarm,
                  timeoutAfter: const Duration(minutes: 1)
              ),
              schedule: NotificationCalendar(
                  year: newDate.year,
                  month: newDate.month,
                  day: newDate.day,
                  hour: newDate.hour,
                  minute: newDate.minute,
                  timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
              )
          );
          if(reminder.initialReminder!= null){
            scheduleInitialNotifications(
                schedule: NotificationCalendar(
                    year: newInitialDate.year,
                    month: newInitialDate.month,
                    day: newInitialDate.day,
                    hour: newInitialDate.hour,
                    minute: newInitialDate.minute,
                    timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                ),
                content: NotificationContent(
                  id: initialContentId,
                  channelKey: 'alerts',
                  title: reminder.title,
                  body: reminder.description,
                  notificationLayout: NotificationLayout.Default,
                  //actionType : ActionType.DisabledAction,
                  color: Colors.black,
                  wakeUpScreen: true,
                  displayOnForeground: true,
                  displayOnBackground: true,
                  backgroundColor: Colors.black,
                )
            );
          }

          GeneralReminderModel reminderModel = GeneralReminderModel(reminderId: reminder.reminderId, title: reminder.title, description: reminder.description, time: reminder.time, startDate: reminder.startDate, reminderPattern: reminder.reminderPattern, userId: reminder.userId, contentId: contentId, reminderTypeId: reminder.reminderTypeId);
          allReminderBox.putAt(reminderIndex, reminderModel);
        }
        if(reminder.reminderPattern.reminderPatternId ==3){
          final dateList = DateTime.parse(payload['dateTime']!);
          String day ='';
          DateTime? newAddedDate ;

          int addedDatesCount = 0;

          do {
            DateTime newDate = dateList.add(
                Duration(days: addedDatesCount));

            day = DateFormat('EEEE').format(newDate);
            newAddedDate = newDate;


            addedDatesCount++;
          } while (reminder.reminderPattern.daysOfWeek!.contains(day));

          final newInitialDate = newAddedDate.subtract(duration??Duration(seconds: 0));
          scheduleNotifications(
              content: NotificationContent(
                  id: contentId,
                  channelKey: 'alerts',
                  title: reminder.title,
                  body: reminder.description,
                  payload: {
                    'reminderTypeId' : '2',
                    'dateId' : newAddedDate.toString()
                  },
                  criticalAlert: true,
                  displayOnBackground: true,
                  displayOnForeground: true,
                  fullScreenIntent: true,
                  wakeUpScreen: true,
                  category: NotificationCategory.Alarm,
                  timeoutAfter: const Duration(minutes: 1)
              ),
              schedule: NotificationCalendar(
                  year: newAddedDate.year,
                  month: newAddedDate.month,
                  day: newAddedDate.day,
                  hour: newAddedDate.hour,
                  minute: newAddedDate.minute,
                  timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
              )
          );
          if(reminder.initialReminder!= null){
            scheduleInitialNotifications(
                schedule:NotificationCalendar(
                    year: newInitialDate.year,
                    month: newInitialDate.month,
                    day: newInitialDate.day,
                    hour: newInitialDate.hour,
                    minute: newInitialDate.minute,
                    timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                ),
                content: NotificationContent(
                  id: initialContentId,
                  channelKey: 'alerts',
                  title: reminder.title,
                  body: reminder.description,
                  notificationLayout: NotificationLayout.Default,
                  //actionType : ActionType.DisabledAction,
                  color: Colors.black,
                  wakeUpScreen: true,
                  displayOnForeground: true,
                  displayOnBackground: true,
                  backgroundColor: Colors.black,
                )
            );
          }

          GeneralReminderModel reminderModel = GeneralReminderModel(reminderId: reminder.reminderId, title: reminder.title, description: reminder.description, time: reminder.time, startDate: reminder.startDate, reminderPattern: reminder.reminderPattern, userId: reminder.userId, contentId: contentId, reminderTypeId: reminder.reminderTypeId);
          allReminderBox.putAt(reminderIndex, reminderModel);
        }
        if(reminder.reminderPattern.reminderPatternId ==4){
          final dateList = DateTime.parse(payload['dateTime']!);
          final newDate = dateList.add(Duration(days: reminder.reminderPattern.interval ?? 0));

          final newInitialDate = newDate.subtract(duration??Duration(seconds: 0));

          scheduleNotifications(
              content: NotificationContent(
                  id: contentId,
                  channelKey: 'alerts',
                  title: reminder.title,
                  body: reminder.description,
                  payload: {
                    'reminderTypeId' : '2',
                    'dateId' : newDate.toString()
                  },
                  criticalAlert: true,
                  displayOnBackground: true,
                  displayOnForeground: true,
                  fullScreenIntent: true,
                  wakeUpScreen: true,
                  category: NotificationCategory.Alarm,
                  timeoutAfter: const Duration(minutes: 1)
              ),
              schedule: NotificationCalendar(
                  year: newDate.year,
                  month: newDate.month,
                  day: newDate.day,
                  hour: newDate.hour,
                  minute: newDate.minute,
                  timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
              ),
          );
          if(reminder.initialReminder!= null){
            scheduleInitialNotifications(
                schedule: NotificationCalendar(
                    year: newInitialDate.year,
                    month: newInitialDate.month,
                    day: newInitialDate.day,
                    hour: newInitialDate.hour,
                    minute: newInitialDate.minute,
                    timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                ),
                content: NotificationContent(
                  id: initialContentId,
                  channelKey: 'alerts',
                  title: reminder.title,
                  body: reminder.description,
                  notificationLayout: NotificationLayout.Default,
                  //actionType : ActionType.DisabledAction,
                  color: Colors.black,
                  wakeUpScreen: true,
                  displayOnForeground: true,
                  displayOnBackground: true,
                  backgroundColor: Colors.black,
                )
            );
          }

          GeneralReminderModel reminderModel = GeneralReminderModel(reminderId: reminder.reminderId, title: reminder.title, description: reminder.description, time: reminder.time, startDate: reminder.startDate, reminderPattern: reminder.reminderPattern, userId: reminder.userId, contentId: contentId, reminderTypeId: reminder.reminderTypeId);
          allReminderBox.putAt(reminderIndex, reminderModel);
        }

      }
      else{
        if (receivedAction.buttonKeyPressed != 'DISMISSED' && !isPostAlarmExecuted) {
          await postAlarmNotification(receivedAction);
          isPostAlarmExecuted = true;
          print('executed');
        }
      }


    }

  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    print(receivedAction.payload ?? 'null payload');
    onDismissActionReceivedMethod(receivedAction);
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
          actionType: ActionType.SilentBackgroundAction
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
          actionType: ActionType.SilentBackgroundAction
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
          actionType: ActionType.SilentBackgroundAction
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
          actionType: ActionType.SilentBackgroundAction
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








