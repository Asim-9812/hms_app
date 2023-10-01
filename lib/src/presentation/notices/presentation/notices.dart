




import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                    items: noticeList.map((e) {
                      return Container(
                        decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${e['title']}',style: getSemiBoldStyle(color: ColorManager.black,fontSize: 20),),
                            h10,
                            Text('${e['description']}',style: getRegularStyle(color: ColorManager.black,fontSize: 16),textAlign: TextAlign.justify,),
                            h20,
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child:Text('${e['date']}',style: getRegularStyle(color: ColorManager.black,fontSize: 14)),

                            )
                          ],
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      pageSnapping: true,
                      autoPlay: true,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  w20,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.dotGrey,
                        elevation: 0
                    ),
                    child: Text('Notify later',style: TextStyle(color: ColorManager.black),),
                    onPressed: () {
                      ref.read(itemProvider.notifier).updateNotice(false);
                      Navigator.of(context).pop();// Close the dialog
                    },
                  ),
                ],
              ),
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        }
      );
    },
    barrierDismissible: false,

  );
}