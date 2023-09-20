



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/presentation/patient/health_tips/domain/services/health_tips_services.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/value_manager.dart';
import 'health_tips.dart';

class HealthTipsList extends ConsumerStatefulWidget {
  const HealthTipsList({super.key});

  @override
  ConsumerState<HealthTipsList> createState() => _HealthTipsState();
}

class _HealthTipsState extends ConsumerState<HealthTipsList> {




  @override
  Widget build(BuildContext context) {

    final getHealthTips = ref.watch(getHealthTipsList);

    return getHealthTips.when(
        data: (data){
          return Column(
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: data.length,
                  itemBuilder: (context,index){
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 2.h),
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                    color: ColorManager.dotGrey.withOpacity(0.2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${data[index].type}', style: getMediumStyle(color: Colors.black,fontSize: 16)),
                        h10,
                        Text(
                          data[index].description??'',
                          style: getRegularStyle(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                  }
              ),
              h20,
              Center(
                child: InkWell(
                    onTap: ()=>Get.to(()=>HealthTips(healthTipsList: data,)),
                    child: Text('See more',style: getRegularStyle(color: ColorManager.black,fontSize: 16),)),
              )
            ],
          );
        },
        error: (error,stack)=>Center(child: Text('$error',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),),
        loading: ()=>Center(child: CircularProgressIndicator(),)
    );
  }
}
