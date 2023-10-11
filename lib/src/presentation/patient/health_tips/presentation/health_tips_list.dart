import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/presentation/patient/health_tips/data/tagList_provider.dart';
import 'package:medical_app/src/presentation/patient/health_tips/domain/services/health_tips_services.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../domain/model/health_tips_model.dart';
import 'health_pop_up.dart';


class HealthTipsList extends ConsumerStatefulWidget {


  @override
  ConsumerState<HealthTipsList> createState() => _HealthTipsState();
}

class _HealthTipsState extends ConsumerState<HealthTipsList> {
  final CarouselController _carouselController = CarouselController();
  int _currentSlide = 0; // Store the current slide index

  final List<String> imageList = ['assets/images/containers/Tip-Container-3.png'];


  @override
  Widget build(BuildContext context) {

    final getHealthTips = ref.watch(getHealthTipsList);
    final tagList = ref.watch(tagListProvider).filteredList;

    return getHealthTips.when(
      data: (data) {
        final updatedList =tagList.isEmpty
            ? data
            : data.where((tips) => tagList.any((tag) => tag.type == tips.type)).toList();
        ;
        return Column(
          children: [
            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: 150,
                enlargeCenterPage: true,
                pageSnapping: true,
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 500),
                viewportFraction: 1,
                autoPlayInterval:Duration(seconds: 5) ,
                onPageChanged: (index, reason) {
                  // Update the current slide index when the page changes
                  setState(() {
                    _currentSlide = index;
                  });
                },
              ),
              items: updatedList.take(5).map((tips) {
                int index = updatedList.indexOf(tips) % imageList.length;

                return SingleChildScrollView(
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 18.w, top: 8.h,bottom: 8.h),
                    decoration: BoxDecoration(
                      // image: DecorationImage(image: AssetImage(imageList[index]),fit: BoxFit.cover),
                      color: ColorManager.primary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ColorManager.primary
                      )
                    ),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        height: 100,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            tips.description ?? '',
                            style: getRegularStyle(color: ColorManager.white, fontSize: 18,),maxLines: 4,overflow: TextOverflow.ellipsis,softWrap: true,
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap:() async {
                                // Get.to(()=>TestTips(tips));
                                await showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        content: Container(
                                          decoration: BoxDecoration(
                                              color: ColorManager.primary,
                                              borderRadius: BorderRadius.circular(5)
                                          ),

                                          width: 300,
                                          padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 18.w),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Health Tip',style: getMediumStyle(color: ColorManager.white,fontSize: 24),),
                                              Divider(
                                                color: ColorManager.white,
                                              ),
                                              h10,
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.9),
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                                padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 8.h),
                                                child: Text(tips.description!,style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                                              ),
                                              h20,
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: ColorManager.white
                                                      ),
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      }, child: Text('OK',style: getMediumStyle(color: ColorManager.primary,fontSize: 16),)),
                                                  Column(
                                                    children: [
                                                      Text('- John Doe',style: getMediumStyle(color: Colors.white,fontSize: 18),),
                                                      h10,
                                                      Text('2023-10-10',style: getMediumStyle(color: Colors.white,fontSize: 18),)
                                                    ],
                                                  ),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                );
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
                                  decoration: BoxDecoration(
                                      color: ColorManager.orange.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text('See more',style: getMediumStyle(color: ColorManager.white, fontSize: 16,),maxLines: 1,)),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
                                decoration: BoxDecoration(
                                    color: ColorManager.orange.withOpacity(0.7),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))
                                ),
                                child: Text('By JOHN DOE',style: getMediumStyle(color: ColorManager.white, fontSize: 16,),maxLines: 1,)),
                          ],
                        ),
                      )



                    ],
                      ),
                  ),
                );
              }).toList(),
            ),
            h10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: updatedList.asMap().entries.take(5).map((entry) {
                final int index = entry.key;
                return GestureDetector(
                  onTap: () {
                    _carouselController.animateToPage(index);
                  },
                  child: Container(
                    width: 10,
                    height: 10,
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentSlide == index
                          ? ColorManager.primary.withOpacity(0.7) // Active dot color
                          : ColorManager.dotGrey.withOpacity(0.5), // Inactive dot color
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
      error: (error, stack) => Center(
        child: Text(
          '$error',
          style: getRegularStyle(color: ColorManager.black, fontSize: 16),
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
