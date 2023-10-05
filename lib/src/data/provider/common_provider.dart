
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/patient/reminders/domain/model/reminder_model.dart';

final imageProvider = StateNotifierProvider.autoDispose<ImageProvider1, XFile?>((ref) => ImageProvider1(null));
final imageProvider2 = StateNotifierProvider.autoDispose<ImageProvider1, XFile?>((ref) => ImageProvider1(null));



class ImageProvider1 extends StateNotifier<XFile?>{
  ImageProvider1(super.state);

  void pickAnImage() async{
    final ImagePicker _picker = ImagePicker();
    state = await _picker.pickImage(source: ImageSource.gallery);
  }

  void camera() async{
    final ImagePicker _picker = ImagePicker();
    state = await _picker.pickImage(source: ImageSource.camera);
  }

}


final itemProvider = ChangeNotifierProvider.autoDispose((ref) => CommonProvider());

class CommonProvider extends ChangeNotifier {


  bool noticeChange = true;
  int noticeIndex = 0;
  int selectMealType = 0;
  int selectPatternId = 0;
  // TabController tabController = TabController(length: 2, vsync: this);



  List<ReminderModel> reminderList = Hive.box<ReminderModel>('medicine_reminder').values.toList();


  ///for summary...
  String medicineType = 'Tablet';
  String medicineName = '';
  String strength ='';
  String strengthUnit ='';
  String frequency ='';
  String mealTime ='';



  void updateMedicineType(String value){
    medicineType = value;
    notifyListeners();
  }

  void updateMedicineName(String value){
    medicineName = value;
    notifyListeners();
  }


  void updateStrength(String value){
    strength = value;
    notifyListeners();
  }
  void updateStrengthUnit(String value){
    strengthUnit = value;
    notifyListeners();
  }
  void updateFrequency(String value){
    frequency = value;
    notifyListeners();
  }

  void updateMealTime(String value){
    mealTime = value;
    notifyListeners();
  }











  void updateNotice(bool value){
    noticeChange = value;
    notifyListeners();
  }

  void updateIndex(int value){
    noticeIndex = value;
    notifyListeners();
  }
  void updateMealType(int value){
    selectMealType = value;
    notifyListeners();
  }

  void updatePatternId(int value){
    selectPatternId = value;
    notifyListeners();
  }


}
