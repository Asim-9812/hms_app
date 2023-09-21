import 'package:carousel_slider/carousel_slider.dart';
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
  final CarouselController _carouselController = CarouselController();
  int _currentSlide = 0; // Store the current slide index

  @override
  Widget build(BuildContext context) {
    final getHealthTips = ref.watch(getHealthTipsList);

    return getHealthTips.when(
      data: (data) {
        return Column(
          children: [
            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: 80,
                enlargeCenterPage: true,
                pageSnapping: true,
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 500),
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  // Update the current slide index when the page changes
                  setState(() {
                    _currentSlide = index;
                  });
                },
              ),
              items: data.map((tips) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: ColorManager.dotGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${tips.type}', style: getMediumStyle(color: Colors.black, fontSize: 20)),
                      h10,
                      Text(
                        tips.description ?? '',
                        style: getRegularStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            h10,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: data.asMap().entries.map((entry) {
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
                          ? ColorManager.primary // Active dot color
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
