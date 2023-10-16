import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/model/reminder_model.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();



  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }



  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future scheduleNotification(
      {int id = 0,
        String? title,
        String? body,
        String? payLoad,
        bool? isRepeat,
        required DateTime scheduledNotificationDateTime}) async {


    TimeOfDay time = TimeOfDay(hour: scheduledNotificationDateTime.hour, minute: scheduledNotificationDateTime.minute);

    DateTime now = DateTime.now();

    DateTime date = DateTime(now.year,now.month,now.day,time.hour,time.minute);

    print( 'date tz : ${tz.TZDateTime.from(
      date,
      tz.local,
    )
    }',);

    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          date,
          tz.local,
        ),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);


  }


  Future scheduleEverydayNotification(
      {required Reminder reminder}) async {

    for(int j =0; j < reminder.medicationDuration; j++){
      for(String i in reminder.scheduleTime){


        DateTime time = DateFormat('hh:mm a').parse(i);

        //TimeOfDay time = TimeOfDay(hour: scheduledNotificationDateTime.hour, minute: scheduledNotificationDateTime.minute);

        DateTime now = DateTime.now();

        DateTime date = DateTime(now.year,now.month,now.day,time.hour,time.minute);

        print( 'date tz : ${tz.TZDateTime.from(
          date,
          tz.local,
        )
        }',);

        return notificationsPlugin.zonedSchedule(
            reminder.reminderId,
            reminder.medicineName,
            'It\'s time for your medicine',
            tz.TZDateTime.from(
              date,
              tz.local,
            ),
            await notificationDetails(),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);


      }
    }


    }




}
