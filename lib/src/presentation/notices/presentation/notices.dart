
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/presentation/notices/domain/services/notice_services.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';
import '../../../data/provider/common_provider.dart';

void showAlertDialog(BuildContext context,String code) async {

  await showDialog(

    context: context,
    builder: (BuildContext context) {
      return Consumer(

        builder: (context,ref,child) {
          final notices = ref.watch(getNoticeList(code));
          return notices.when(
              data: (data){
                if(data.isEmpty){
                 Navigator.pop(context);
                 return SizedBox();
                }
                else{
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
                                  HtmlWidget(
                                    e.description!,
                                    textStyle: TextStyle(color: ColorManager.black,overflow: TextOverflow.ellipsis),
                                    renderMode: RenderMode.column,
                                    customStylesBuilder: (style){
                                      return {'color': 'black'};
                                    }
                                    ,

                                  ),

                                  //Text('${e.description}',style: getRegularStyle(color: ColorManager.black,fontSize: 14),textAlign: TextAlign.start,maxLines: 2,overflow: TextOverflow.ellipsis,),
                                  h20,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(e.createdBy!.length >= 30 ? e.code! : e.createdBy! ,style: getMediumStyle(color: ColorManager.black,fontSize: 16)),
                                      Text('${DateFormat('yyyy-MM-dd').format(e.validDate!)}',style: getRegularStyle(color: ColorManager.black,fontSize: 14)),
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
                }


              },
              error: (error,stack)=>AlertDialog(

            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  color: ColorManager.primary,
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
                    backgroundColor: ColorManager.primary
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



void showAlertDialog2(BuildContext context,String code,WidgetRef ref) async {

  final notices = ref.watch(getNoticeList(code));

  return notices.when(
      data: (data){
        if(data.isNotEmpty){
          showDialog(

          context: context,
          builder: (BuildContext context) {
            return  AlertDialog(
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
                            HtmlWidget(
                              e.description!,
                              textStyle: TextStyle(color: ColorManager.black,overflow: TextOverflow.ellipsis),
                              renderMode: RenderMode.column,
                              customStylesBuilder: (style){
                                return {'color': 'black'};
                              }
                              ,

                            ),

                            //Text('${e.description}',style: getRegularStyle(color: ColorManager.black,fontSize: 14),textAlign: TextAlign.start,maxLines: 2,overflow: TextOverflow.ellipsis,),
                            h20,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.createdBy!.length >= 30 ? e.code! : e.createdBy! ,style: getMediumStyle(color: ColorManager.black,fontSize: 16)),
                                Text('${DateFormat('yyyy-MM-dd').format(e.validDate!)}',style: getRegularStyle(color: ColorManager.black,fontSize: 14)),
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
            );;
          },
          barrierDismissible: false,

          );

        }


      },
      error: (error,stack)=>AlertDialog(

        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              color: ColorManager.primary,
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
                backgroundColor: ColorManager.primary
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