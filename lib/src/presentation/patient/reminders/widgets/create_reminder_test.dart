





import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medical_app/src/presentation/patient/reminders/domain/model/reminder_model.dart';
import 'package:timezone/standalone.dart' as tz;

class NotificationServices{

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings = const AndroidInitializationSettings('logo');


  void initializeNotifications() async {
    InitializationSettings initializationSettings = InitializationSettings(android: _androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }



  void scheduleNotification() async {


    TimeOfDay time = TimeOfDay(hour: 14, minute: 05);
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.max,
    );


    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        12,
        'test title',
        'test desc',
        _scheduleDaily(time) ,
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime
    );
  }

  static tz.TZDateTime _scheduleDaily(TimeOfDay time){
    var now = DateTime.now();

    var scheduledDate = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    return scheduledDate.isBefore(now) ? tz.TZDateTime.from(scheduledDate.add(const Duration(days: 1)), tz.getLocation('Asia/Kathmandu'))
        : tz.TZDateTime.from(scheduledDate, tz.getLocation('Asia/Kathmandu'));

  }

}