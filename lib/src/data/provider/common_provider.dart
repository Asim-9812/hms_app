
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


final imageProvider = StateNotifierProvider.autoDispose<ImageProvider1, XFile?>((ref) => ImageProvider1(null));
final imageProvider2 = StateNotifierProvider.autoDispose<ImageProvider1, XFile?>((ref) => ImageProvider1(null));



class ImageProvider1 extends StateNotifier<XFile?>{
  ImageProvider1(super.state);

  void pickAnImage() async{
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      final file = XFile(croppedFile!.path);
      state = file;
    }
  }

  void camera() async{
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);
    if(image != null){
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      final file = XFile(croppedFile!.path);
      state = file;
    }



  }

}


final itemProvider = ChangeNotifierProvider.autoDispose((ref) => CommonProvider());

class CommonProvider extends ChangeNotifier {


  bool noticeChange = true;
  int noticeIndex = 0;
  int selectMealType = 1;
  int selectPatternId = 0;
  // TabController tabController = TabController(length: 2, vsync: this);


  bool isMenuOpen = false;





  ///for summary...
  String medicineType = 'Tablet';
  String medicineName = '';
  String strength ='';
  String strengthUnit ='';
  String frequency ='';
  String mealTime ='Before a Meal';



  void updateMenu(bool value) {
    isMenuOpen = value;
    notifyListeners();
  }



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
