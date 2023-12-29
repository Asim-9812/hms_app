



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/presentation/widgets/bmi.dart';
import 'package:meroupachar/src/presentation/widgets/ibw.dart';


import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../widgets/edd.dart';
import '../../../widgets/gcs.dart';
import '../../../widgets/mdc.dart';

class DoctorUtilityPage extends StatefulWidget {
  const DoctorUtilityPage({super.key});

  @override
  State<DoctorUtilityPage> createState() => _PatientReportPageState();
}

class _PatientReportPageState extends State<DoctorUtilityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        centerTitle: true,
        elevation: 1,
        title: Text('Utilities',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),

      ),
      body: GridView(
        padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 18.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1/1
        ),
        children: [
          InkWell(
            onTap: ()=>Get.to(()=>BMI()),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ColorManager.black.withOpacity(0.5)
                ),
                  color: ColorManager.orange.withOpacity(0.2)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset('assets/icons/bmi.png',height: 40,fit: BoxFit.fitHeight,),
                  ),
                  h20,
                  Text('BMI Calculator',style: getRegularStyle(color: ColorManager.black,fontSize: 16.sp),)


                ],
              ),
            ),
          ),
          InkWell(
            onTap: ()=>Get.to(()=>EDD()),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: ColorManager.black.withOpacity(0.5)
                  ),
                  color: ColorManager.primaryDark.withOpacity(0.1)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset('assets/icons/schedule.png',height: 40,fit: BoxFit.fitHeight,),
                  ),
                  h20,
                  Text('EDD Calculator',style: getRegularStyle(color: ColorManager.black,fontSize: 16.sp),)


                ],
              ),
            ),
          ),
          InkWell(
            onTap: ()=>Get.to(()=>IBW()),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: ColorManager.black.withOpacity(0.5)
                  ),
                  color: ColorManager.yellowFellow.withOpacity(0.3)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset('assets/icons/weight-scale.png',height: 40,fit: BoxFit.fitHeight,),
                  ),
                  h20,
                  Text('IBW Calculator',style: getRegularStyle(color: ColorManager.black,fontSize: 16.sp),)


                ],
              ),
            ),
          ),
          InkWell(
            onTap: ()=>Get.to(()=>GCS()),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: ColorManager.black.withOpacity(0.5)
                  ),
                  color: ColorManager.accentPink.withOpacity(0.1)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset('assets/icons/brain.png',height: 40,fit: BoxFit.fitHeight,),
                  ),
                  h20,
                  Text('GCS',style: getRegularStyle(color: ColorManager.black,fontSize: 16.sp),)


                ],
              ),
            ),
          ),
          InkWell(
            onTap: ()=>Get.to(()=>MDC()),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: ColorManager.black.withOpacity(0.5)
                  ),
                  color: ColorManager.primary.withOpacity(0.1)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset('assets/icons/injection.png',height: 40,fit: BoxFit.fitHeight,),
                  ),
                  h20,
                  Text('MD Calculator',style: getRegularStyle(color: ColorManager.black,fontSize: 16.sp),)


                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: ColorManager.black.withOpacity(0.5)
                ),
              color: ColorManager.red.withOpacity(0.1)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset('assets/icons/muscle-pain.png',height: 40,fit: BoxFit.fitHeight,),
                ),
                h20,
                Text('Pain Score',style: getRegularStyle(color: ColorManager.black,fontSize: 16.sp),)


              ],
            ),
          ),


        ],
      )
    );
  }
}
