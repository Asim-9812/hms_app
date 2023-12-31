




import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/presentation/notices/domain/services/notice_services.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';
import '../../../data/provider/common_provider.dart';

void showAlertDialog(BuildContext context) async {

  await showDialog(

    context: context,
    builder: (BuildContext context) {
      return Consumer(

        builder: (context,ref,child) {
          final notices = ref.watch(getNoticeList);
          return notices.when(
              data: (data){
                if(data.isEmpty){
                  Navigator.pop(context);
                }
                return AlertDialog(
                  backgroundColor: Colors.transparent,
                  contentPadding: EdgeInsets.zero,
                  content: Container(
                    decoration: BoxDecoration(
                      // color: ColorManager.primary,
                        image: DecorationImage(image: AssetImage('assets/images/containers/Tip-Container-3.png'),fit: BoxFit.fitHeight),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)
                        )
                    ),

                    width: 300,
                    padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 12.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Notices',style: getMediumStyle(color: ColorManager.white,fontSize: 24),),
                        h10,
                        Divider(
                          color: ColorManager.white,
                          indent: 8.w,
                          endIndent: 8.w,
                        ),
                        h10,
                        ...data.take(5).map((e) {
                          return Container(
                            decoration: BoxDecoration(
                                color: ColorManager.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
                            margin: EdgeInsets.only(bottom: 5.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Text('${e.description}',style: getRegularStyle(color: ColorManager.black,fontSize: 14),textAlign: TextAlign.start,maxLines: 2,overflow: TextOverflow.ellipsis,),
                                h20,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('John Doe',style: getMediumStyle(color: ColorManager.black,fontSize: 16)),
                                    Text('${DateFormat('yyyy-MM-dd').format(e.entryDate)}',style: getRegularStyle(color: ColorManager.black,fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        h20,
                        InkWell(
                          onTap: (){
                            ref.read(itemProvider.notifier).updateNotice(false);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 18.h),
                            child: Center(
                              child: Text('OK',style: getMediumStyle(color: ColorManager.primary,fontSize: 18),),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                );

              },
              error: (error,stack)=>AlertDialog(

            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  color: ColorManager.blueText,
                  child: Center(child: Text('Notices',style: getMediumStyle(color: ColorManager.white,fontSize: 24),)),
                ),
                h20,
                Container(
                  height: 150,
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Center(child: Text('$error',style: getRegularStyle(color: ColorManager.black),)),
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.blueText
                ),
                child: Text('OK'),
                onPressed: () {
                  ref.read(itemProvider.notifier).updateNotice(false);
                  Navigator.of(context).pop();// Close the dialog
                },
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
          ),
              loading: ()=>SizedBox()
          );
        }
      );
    },
    barrierDismissible: false,

  );
}