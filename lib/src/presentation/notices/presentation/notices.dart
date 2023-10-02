




import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/presentation/notices/domain/services/notice_services.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';
import '../../../data/provider/common_provider.dart';
import '../../../dummy_datas/dummy_datas.dart';

void showAlertDialog(BuildContext context) {
  List noticeList = notices;
  showDialog(

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
                        child: CarouselSlider(
                          items: data.map((e) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: ColorManager.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${e.type}',style: getSemiBoldStyle(color: ColorManager.black,fontSize: 20),),
                                  h10,
                                  Text('${e.description}',style: getRegularStyle(color: ColorManager.black,fontSize: 16),textAlign: TextAlign.justify,),
                                  h20,
                                  Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child:Text('${DateFormat('yyyy-MM-dd').format(e.entryDate)}',style: getRegularStyle(color: ColorManager.black,fontSize: 14)),

                                  ),
                                  h20,
                                  // Align(
                                  //   alignment: Alignment.topCenter,
                                  //   child:Text('By',style: getRegularStyle(color: ColorManager.black,fontSize: 16)),
                                  // ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child:Text('- John Doe',style: getMediumStyle(color: ColorManager.black,fontSize: 18)),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            pageSnapping: true,
                            autoPlay:data.length>1? true:false,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration: Duration(milliseconds: 500),
                            viewportFraction: 1,
                          ),
                        ),
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
                        print(ref.watch(itemProvider).noticeChange);
                      },
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.center,
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