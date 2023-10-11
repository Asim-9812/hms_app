



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/presentation/notices/domain/model/notice_model.dart';

import '../../../core/resources/value_manager.dart';


class Personal extends StatelessWidget {
  final List<NoticeModel> notificationList;
  Personal({required this.notificationList});

  @override
  Widget build(BuildContext context) {

    if(notificationList.isEmpty){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
                angle: 30 * 3.14159265358979323846 / 180,

                child: FaIcon(Icons.notifications_active_outlined,color: ColorManager.dotGrey,size: 50.sp,)),
            h20,
            Text('No new notification',style: getMediumStyle(color: ColorManager.dotGrey),),
          ],
        ),
      );
    }
    
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
        itemCount: notificationList.length,
        itemBuilder: (context,index){
          return Container(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: ColorManager.black.withOpacity(0.4),
                        width: 0.5
                    )
                )
            ),
            child: ListTile(
              leading: FaIcon(Icons.notifications,color: ColorManager.primary,size: 30.sp,),
              title: Text(notificationList[index].type,style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notificationList[index].description,style: getRegularStyle(color: ColorManager.black.withOpacity(0.7),fontSize: 16),maxLines: 2,),
                  h10,
                  Text('${DateFormat('yyyy-MM-dd').format(notificationList[index].entryDate)}',style: getRegularStyle(color: ColorManager.black.withOpacity(0.7),fontSize: 12)),

                ],
              ),
            ),
          );
        }
    );
  }
}
