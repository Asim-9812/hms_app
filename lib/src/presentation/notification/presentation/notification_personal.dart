



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/icons/doctor.png')
              ),
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
