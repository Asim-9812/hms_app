


import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TestCreate extends StatelessWidget {
  const TestCreate({super.key});

  Future<Uint8List> loadImageAsBytes(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }



  void saveData() async {

   Map<String,dynamic> reminderTest = {
     'reminderId' : 1002,
     'medTypeId' : 1,
     'medTypeName' : 'Tablet',
     'medicineName' : 'Medicine 2',
     'strength' : 12,
     'unit' : 'mg',
     'frequency' : {
       'frequencyId' : 1,
         'frequencyName' : 'OD - Once a day',
       'intervals' : '12 hours interval'
     } ,
     'scheduleTime' : ['03:30 AM','15:30 PM'],
     'medicationDuration' : 23,
     'startDate' : DateTime.now(),
     'endDate' : DateTime.now().add(Duration(days: 23)),
     'mealTypeId' : 1,
     'meal' : 'Before a meal',
     'reminderPattern' : {
       'reminderPatternId' : 1,
       'patternName' : 'Everyday',
       'interval' : null,
       'daysOfWeek' : null,
     } ,
     'reminderImage' : await loadImageAsBytes('assets/images/containers/primary-container.png'),
     'notes':null,
     'summary':'this is a summary'
   };

   await Hive.box<Map<String,dynamic>>('test_reminder').add(reminderTest);
   print('Saved');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(onPressed: (){
          saveData();
        }, child: Text('Save')),
      ),
    );
  }
}
