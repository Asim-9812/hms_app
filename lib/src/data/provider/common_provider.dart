
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class CommonProvider extends ChangeNotifier{

  bool noticeChange = true;
  int noticeIndex = 0;

  void updateNotice(bool value){
    noticeChange = value;
    notifyListeners();
  }

  void updateIndex(int value){
    noticeIndex = value;
    notifyListeners();
  }

}
