import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class testNotifications extends StatelessWidget {
  // Specify the initial date
  final DateTime startDate = DateTime.now();
  final DateTime endDate = DateTime.now().add(Duration(days: 30));


  // Number of action days and skip days (you can change these values)
  final int actionDays =7;
  final int skipDays =0;

  @override
  Widget build(BuildContext context) {
    final int totalDays = endDate.difference(startDate).inDays;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Schedule'),
      ),
      body: ListView.builder(
        itemCount: totalDays, // Number of days
        itemBuilder: (context, index) {
          List<String> daysOfWeek = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
          // Calculate the date by adding index days to the start date
          final currentDate = startDate.add(Duration(days: index));

          // Calculate if it's a day to take action or skip based on the dynamic values
          final isActionDay = (index % (actionDays + skipDays) < actionDays);



          return ListTile(
            title: Text('Date: ${currentDate.toLocal()} ${DateFormat('EEEE').format(currentDate)}'),
            subtitle: daysOfWeek.contains(DateFormat('EEEE').format(currentDate))? isActionDay ? Text('Take Action') : Text('Skip') : Text('Skip'),
          );
        },
      ),
    );
  }
}
