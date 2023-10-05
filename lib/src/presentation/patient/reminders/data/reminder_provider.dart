//
//
//
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive/hive.dart';
//
// import '../../../../../main.dart';
// import '../domain/model/reminder_model.dart';
//
// final reminderProvider = StateNotifierProvider<ReminderProvider, List<ReminderModel>>((ref) => ReminderProvider(ref.watch(boxB)));
//
// class ReminderProvider extends StateNotifier<List<ReminderModel>>{
//   ReminderProvider(super.state);
//
//   Future<String> addReminder(ReminderModel reminder) async{
//     if(state.isEmpty){
//       final newReminderItem = ReminderModel(
//         id: reminder.id,
//           medicineType: reminder.medicineType,
//           medicineName: reminder.medicineName,
//           strength: reminder.strength,
//           strengthUnitType: reminder.strengthUnitType,
//           frequency: reminder.frequency,
//           intakeTime: reminder.intakeTime,
//           totalDays: reminder.totalDays,
//           startDate: reminder.startDate,
//           endDate:reminder.endDate,
//           medicineTime: reminder.medicineTime,
//           reminderDuration: reminder.reminderDuration,
//           breakDuration:reminder.breakDuration,
//           summary: reminder.summary,
//           createdDate: reminder.createdDate,
//           userId: reminder.userId,
//         reminderImage: reminder.reminderImage,
//           reminderNote: reminder.reminderNote,
//         daysOfWeek: reminder.daysOfWeek
//       );
//       Hive.box<ReminderModel>('medicine_reminder').add(newReminderItem);
//       state = [newReminderItem];
//       print('Saved');
//       return 'success';
//     }else{
//       return 'fail';
//     }
//   }
//   //
//   // Future<String> updateReminder(ReminderModel reminder) async{
//   //   ReminderModel reminderItem = ReminderModel(
//   //       id: reminder.id,
//   //       title: reminder.title,
//   //       description: reminder.description,
//   //       timeOfDay: reminder.timeOfDay,
//   //       repeat: reminder.repeat,
//   //       dateList: reminder.dateList
//   //   );
//   //
//   //   Hive.box<ReminderModel>('ReminderBox').put(reminder.id, reminderItem);
//   //
//   //   state = state.map((e) {
//   //     if(e.id == reminderItem.id){
//   //       return reminderItem;
//   //     }
//   //     return e;
//   //   }).toList();
//   //
//   //   return 'success';
//   // }
//   //
//   // void removeItem(ReminderModel reminderItem) {
//   //   reminderItem.delete();
//   //   state.remove(reminderItem);
//   //   state = [...state];
//   // }
//
// }