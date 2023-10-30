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
            (int id, String? title, String? body, String? payload) async {
          print('$id,$title,$body,$payload');            

            });

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      print(notificationResponse);
            });
  }



  notificationDetails({required Reminder reminder}) {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max,
          actions: [
            // AndroidNotificationAction(
            //     'Taken',
            //     'Taken',
            // ),
            AndroidNotificationAction('1', 'Snooze',)

          ]

        ),
        iOS: DarwinNotificationDetails());
  }

  // Future showNotification(
  //     {int id = 0, String? title, String? body, String? payLoad}) async {
  //   return notificationsPlugin.show(
  //       id, title, body, await notificationDetails());
  // }

  Future scheduleNotification(
      {required Reminder reminder}) async {



    DateTime now = DateTime.now();

    DateTime date = now.add(Duration(minutes: 5));

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
        await notificationDetails(reminder: reminder),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,


    );


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
            await notificationDetails(reminder: reminder),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        );


      }
    }


    }



  Future scheduleSpecificDaysNotification(
      {required Reminder reminder}) async {

    for(int j =0; j < reminder.medicationDuration; j++){

      for(String days in reminder.reminderPattern.daysOfWeek!){

        if(days == DateFormat('EEEE').format(DateTime.now())){
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
                await notificationDetails(reminder: reminder),
                androidAllowWhileIdle: true,
                uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);


          }
        }

      }


    }


  }




  Future scheduleIntervalSNotification(
      {required Reminder reminder}) async {

    for(int j =0; j < reminder.medicationDuration/reminder.reminderPattern.interval!; j++){

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
                await notificationDetails(reminder: reminder),
                androidAllowWhileIdle: true,
                uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);


          }


          await Future.delayed(Duration(days: reminder.reminderPattern.interval!));




    }


  }







}
