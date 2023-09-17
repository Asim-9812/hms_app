

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';

import '../../../../core/resources/style_manager.dart';
import '../domain/model/health_tips_model.dart';

class HealthTips extends StatelessWidget {
  final List<HealthTipsModel> healthTipsList;
  HealthTips({required this.healthTipsList});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text('Health Tips',style: getMediumStyle(color: ColorManager.black),),
        elevation: 1,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(
            color: ColorManager.black
        ),

      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
        itemCount: healthTipsList.length,
          itemBuilder: (context,index){
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            child: ListTile(
              shape: Border(
                bottom: BorderSide(
                  color: ColorManager.black.withOpacity(0.2)
                )
              ),
              title: Text(healthTipsList[index].type!,style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
              subtitle: Text(healthTipsList[index].type!,style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
              
            ),
          );
          }
      ),
    );
  }
}
