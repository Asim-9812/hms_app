import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/model/health_tips_model.dart';

final tagListProvider = ChangeNotifierProvider.autoDispose((ref) => TagListProvider());


class TagListProvider extends ChangeNotifier{

  List<HealthTipsModel> filteredList = [];


  void updateTagList(List<HealthTipsModel> list){
    filteredList = list;
    notifyListeners();
  }


}