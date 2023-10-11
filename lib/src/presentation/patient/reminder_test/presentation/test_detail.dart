import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image/image.dart' as img;

import 'edit_page.dart'; // for image decoding

class TestDetails extends StatefulWidget {
  final Map<String, dynamic> reminderTest;

  TestDetails(this.reminderTest);

  @override
  State<TestDetails> createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {




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
    // Decode the image
    final img.Image? image = img.decodeImage(widget.reminderTest['reminderImage']);

    final reminder = Hive.box<Map<String,dynamic>>('test_reminder');

    final int index = reminder.values.toList().indexWhere((element) => element['reminderId'] == widget.reminderTest['reminderId']);

    final reminderBox = reminder.getAt(index)!;

    print(reminderBox);


    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                title: Text('Medicine Type: ${reminderBox['medTypeName']}'),
                subtitle: Text('Medicine Name: ${reminderBox['medicineName']}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Strength: ${reminderBox['strength']} ${reminderBox['unit']}'),
                subtitle: Text('Frequency: ${reminderBox['frequency']['frequencyName']}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Schedule Time: ${reminderBox['scheduleTime'].join(', ')}'),
                subtitle: Text('Medication Duration: ${reminderBox['medicationDuration']} days'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Start Date: ${reminderBox['startDate']}'),
                subtitle: Text('End Date: ${reminderBox['endDate']}'),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Meal Type: ${reminderBox['meal']}'),
                subtitle: Text('Reminder Pattern: ${reminderBox['reminderPattern']['patternName']}'),
              ),
            ),
            if (image != null)
              Card(
                child: ListTile(
                  title: Text('Image:'),
                  subtitle: Image.memory(Uint8List.fromList(img.encodePng(image))),
                ),
              ),
            Card(
              child: ListTile(
                title: Text('Notes: ${reminderBox['notes'] ?? 'No notes'}'),
                subtitle: Text('Summary: ${reminderBox['summary']}'),
              ),
            ),
            ElevatedButton(onPressed: ()=>Get.to(()=>EditReminderPage(reminderBox))
                , child: Text('Edit'))

          ],
        ),
      ),
    );
  }
}