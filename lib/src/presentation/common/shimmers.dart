





import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/resources/value_manager.dart';

class ProfileShimmer extends StatefulWidget {
  const ProfileShimmer({super.key});

  @override
  State<ProfileShimmer> createState() => _ProfileShimmerState();
}

class _ProfileShimmerState extends State<ProfileShimmer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 1,
        iconTheme: IconThemeData(
          color: ColorManager.black
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Shimmer.fromColors(
          baseColor: ColorManager.dotGrey,
          highlightColor: ColorManager.white,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
            height: MediaQuery.of(context).size.height * 0.9/4,
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(10)
            ),
          ),
        ),
          h20,
          Container(
            height: 100,
            // color: ColorManager.red,
            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
            child: ListTile(
              leading: Shimmer.fromColors(
                baseColor: ColorManager.dotGrey,
                highlightColor: ColorManager.white,
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  width: 50,
                  height: 50,
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: ColorManager.dotGrey,
                    highlightColor: ColorManager.white,
                    child: Container(
                      width: 200.w,
                      height: 10,
                      margin: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                      decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: ColorManager.dotGrey,
                    highlightColor: ColorManager.white,
                    child: Container(
                      width: 350.w,
                      height: 10,
                      margin: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                      decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
          h20,
          Container(
              height: 100,
              // color: ColorManager.red,
              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
              child: ListTile(
                leading: Shimmer.fromColors(
                  baseColor: ColorManager.dotGrey,
                  highlightColor: ColorManager.white,
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: 50,
                    height: 50,
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: ColorManager.dotGrey,
                      highlightColor: ColorManager.white,
                      child: Container(
                        width: 200.w,
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                        decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: ColorManager.dotGrey,
                      highlightColor: ColorManager.white,
                      child: Container(
                        width: 350.w,
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                        decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),
          h20,
          Container(
              height: 100,
              // color: ColorManager.red,
              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
              child: ListTile(
                leading: Shimmer.fromColors(
                  baseColor: ColorManager.dotGrey,
                  highlightColor: ColorManager.white,
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: 50,
                    height: 50,
                  ),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: ColorManager.dotGrey,
                      highlightColor: ColorManager.white,
                      child: Container(
                        width: 200.w,
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                        decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: ColorManager.dotGrey,
                      highlightColor: ColorManager.white,
                      child: Container(
                        width: 350.w,
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                        decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),



      ],
      ),
    );
  }
}
