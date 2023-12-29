import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/presentation/patient/health_tips/data/tagList_provider.dart';
import 'package:meroupachar/src/presentation/patient/health_tips/domain/services/health_tips_services.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/value_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';


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
        if(data.isEmpty){
          return Column(
            children: [
              CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: 150,
                  enlargeCenterPage: true,
                  pageSnapping: true,
                  autoPlay: false,
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
                items: [Container(
                  // height: 150,
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
                        // height: 100,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child:
                            Html(data: 'A person should drink an average of 2L of water in a day.',style: {
                              'body' : Style(
                                color: ColorManager.white,
                                fontSize: FontSize.medium,
                                maxLines: 4,
                                textOverflow: TextOverflow.ellipsis,

                              )
                            },)


                          // Text(
                          //   tips.description ?? '',
                          //   style: getRegularStyle(color: ColorManager.white, fontSize: 18,),maxLines: 4,overflow: TextOverflow.ellipsis,softWrap: true,
                          // ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
                                decoration: BoxDecoration(
                                    color: ColorManager.orange.withOpacity(0.7),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))
                                ),
                                child: Text('By WHO',style: getMediumStyle(color: ColorManager.white, fontSize: 16,),maxLines: 1,)),
                          ],
                        ),
                      )



                    ],
                  ),
                )],
              ),
            ],
          );
        }
        final updatedList =tagList.isEmpty
            ? data
            : data.where((tips) => tagList.any((tag) => tag.type == tips.type)).toList();
        // print('<div>${updatedList[3].description}</div>');
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CarouselSlider(
              carouselController: _carouselController,

              options: CarouselOptions(
                height: 150,
                // aspectRatio: 16/9,
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
              items: updatedList.take(6).map((tips) {
                int index = updatedList.indexOf(tips) % imageList.length;


                return Container(
                  width: double.infinity,
                  // height: 200,
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
                    mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Align(
                      alignment: Alignment.centerLeft,
                      child:


                        HtmlWidget(
                            tips.description!,
                          textStyle: TextStyle(color: ColorManager.white,overflow: TextOverflow.ellipsis),

                          customStylesBuilder: (style){
                            return {'color': 'white'};
                          }
                          ,

                        ),



                          // Html(data: '<div>${tips.description}</div>',style: {
                          //   'body' : Style(
                          //     color: ColorManager.white,
                          //     fontSize: FontSize.medium,
                          //     maxLines: 4,
                          //     textOverflow: TextOverflow.ellipsis,
                          //
                          //   )
                          // },)


                      // Text(
                      //   tips.description ?? '',
                      //   style: getRegularStyle(color: ColorManager.white, fontSize: 18,),maxLines: 4,overflow: TextOverflow.ellipsis,softWrap: true,
                      // ),
                    ),


                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
                              decoration: BoxDecoration(
                                  color: ColorManager.orange.withOpacity(0.7),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))
                              ),
                              child:

                              tips.createdBy != null
                                  ? Text(tips.createdBy!.split(' ').length>2?  'By ${tips.createdBy!.split(' ')[0]} ${tips.createdBy!.split(' ')[1]}' : 'By ${tips.createdBy}',style: getMediumStyle(color: ColorManager.white, fontSize: 16,),maxLines: 1,):null),
                        ],
                      ),
                    )



                  ],
                    ),
                );
              }).toList(),
            ),
            h10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: updatedList.asMap().entries.take(6).map((entry) {
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
