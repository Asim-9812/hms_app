



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/presentation/widgets/types%20of%20mdc/BSA.dart';
import 'package:meroupachar/src/presentation/widgets/types%20of%20mdc/abw.dart';
import 'package:meroupachar/src/presentation/widgets/types%20of%20mdc/cnd.dart';
import 'package:meroupachar/src/presentation/widgets/types%20of%20mdc/weight-based.dart';

import '../../core/resources/color_manager.dart';
import '../../core/resources/style_manager.dart';
import '../../core/resources/value_manager.dart';

class MDC extends StatelessWidget {
  const MDC({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;
    return Scaffold(
      backgroundColor: ColorManager.white.withOpacity(0.99),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorManager.white,
        leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.chevron_left,color: Colors.black,)),
        title: Text('MDC',style: getMediumStyle(color: ColorManager.black,fontSize: isNarrowScreen? 24.sp:28),),

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          h20,
          InkWell(
            onTap: ()=>Get.to(()=>WBD()),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 18.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 12.h),
              decoration: BoxDecoration(
                  color: ColorManager.dotGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: ColorManager.black.withOpacity(0.5)
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: ColorManager.orange.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                        child: Center(
                          child: FaIcon(Icons.calculate,color: ColorManager.black,),
                        ),
                      ),
                      w10,
                      Text('Weight-Based Dosage',style: getRegularStyle(color: ColorManager.black),)
                    ],
                  ),
                  FaIcon(Icons.chevron_right,color: ColorManager.black,)
                ],
              ),
            ),
          ),
          h10,
          InkWell(
            onTap: ()=>Get.to(()=>BSA()),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 18.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 12.h),
              decoration: BoxDecoration(
                  color: ColorManager.dotGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: ColorManager.black.withOpacity(0.5)
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: ColorManager.primary.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                        child: Center(
                          child: FaIcon(Icons.gas_meter_rounded,color: ColorManager.black,),
                        ),
                      ),
                      w10,
                      Text('Body Surface Area (BSA)',style: getRegularStyle(color: ColorManager.black),)
                    ],
                  ),
                  FaIcon(Icons.chevron_right,color: ColorManager.black,)
                ],
              ),
            ),
          ),
          h10,
          InkWell(
            onTap: ()=>Get.to(()=>CND()),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 18.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 12.h),
              decoration: BoxDecoration(
                  color: ColorManager.dotGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: ColorManager.black.withOpacity(0.5)
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: ColorManager.red.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
                        child: Center(
                          child: FaIcon(CupertinoIcons.lab_flask_solid,color: ColorManager.black,),
                        ),
                      ),
                      w10,
                      Text('Concentration and Dilution',style: getRegularStyle(color: ColorManager.black),)
                    ],
                  ),
                  FaIcon(Icons.chevron_right,color: ColorManager.black,)
                ],
              ),
            ),
          ),
          h10,
          InkWell(
            onTap: ()=>Get.to(()=>ABW()),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 18.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 12.h),
              decoration: BoxDecoration(
                  color: ColorManager.dotGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: ColorManager.black.withOpacity(0.5)
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: ColorManager.primaryDark.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 8.h),
                        child: Center(
                          child: FaIcon(FontAwesomeIcons.weightScale,color: ColorManager.black,),
                        ),
                      ),
                      w10,
                      Text('Adjusted Body Weight (ABW)',style: getRegularStyle(color: ColorManager.black),)
                    ],
                  ),
                  FaIcon(Icons.chevron_right,color: ColorManager.black,)
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
