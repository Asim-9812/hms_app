import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notification_services.dart';



class TestNotification extends StatefulWidget {
  const TestNotification({super.key, required this.title});

  final String title;


  @override
  State<TestNotification> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TestNotification> {
  DateTime? time;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            datePicker(context),
            scheduleBtn(context),
          ],
        ),
      ),
    );
  }

  Widget datePicker(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
        final now = DateTime.now();
        if(selectedTime != null){
          setState(() {

            time = DateTime(now.year,now.month,now.day,selectedTime.hour,selectedTime.minute);
          });
          print(DateFormat('EEEE').format(time!));
        }
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }


  Widget scheduleBtn(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        debugPrint('Notification Scheduled for $time');
        NotificationService().scheduleNotification(
            title: 'Scheduled Notification',
            body: '$time',
            scheduledNotificationDateTime: time!
        );
      },
    );
  }
}

