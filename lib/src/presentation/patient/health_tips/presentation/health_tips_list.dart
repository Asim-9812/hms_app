import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/presentation/patient/health_tips/data/tagList_provider.dart';
import 'package:meroupachar/src/presentation/patient/health_tips/domain/services/health_tips_services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/value_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../login/domain/model/user.dart';
import '../domain/model/health_tips_model.dart';




class HealthTipsList extends ConsumerStatefulWidget {


  @override
  ConsumerState<HealthTipsList> createState() => _HealthTipsState();
}

class _HealthTipsState extends ConsumerState<HealthTipsList> {
  final CarouselController _carouselController = CarouselController();
  int _currentSlide = 0; // Store the current slide index

  final List<String> imageList = ['assets/images/containers/Tip-Container-3.png'];


  /// health tags...

  List<HealthTipsModel> selectedTags = [];

  void _showMultiSelect(BuildContext context,String token) async {
    final tagList = await HealthTipServices().getHealthTips(token: token);
    Set<String> addedTypes = Set<String>();
    List<HealthTipsModel> uniqueTagList = [];

    for (var tag in tagList) {
      if (!addedTypes.contains(tag.type)) {
        uniqueTagList.add(tag);
        addedTypes.add(tag.type!);
      }
    }

    // Create a copy of selectedTags with the same reference as uniqueTagList
    List<HealthTipsModel> initialSelectedTags =
    selectedTags.map((tag) => uniqueTagList.firstWhere((t) => t.type == tag.type)).toList();

    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          title: Text('Choose Health Tips'),
          listType: MultiSelectListType.CHIP,
          selectedColor: ColorManager.primary,
          separateSelectedItems: true,
          selectedItemsTextStyle: getRegularStyle(color: ColorManager.white, fontSize: 16),
          itemsTextStyle: getRegularStyle(color: ColorManager.black, fontSize: 16),
          items: uniqueTagList
              .map((tag) => MultiSelectItem<HealthTipsModel>(tag, tag.type!))
              .toList(),
          initialValue: initialSelectedTags, // Use initialSelectedTags here
          onConfirm: (values) {
            setState(() {
              selectedTags = values.map((tag) => tag).toList(); // Store selected items
            });
            ref.read(tagListProvider.notifier).updateTagList(selectedTags);
            print(selectedTags);
          },
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {


    final userBox = Hive.box<User>('session').values.toList();
    final user = userBox[0];
    final token = user.token;

    final getHealthTips = ref.watch(getHealthTipsList(token??''));
    final tagList = ref.watch(tagListProvider).filteredList;

    return getHealthTips.when(
      data: (data) {
        if(data.isEmpty){
          return SizedBox();
        }
        final updatedList =tagList.isEmpty
            ? data
            : data.where((tips) => tagList.any((tag) => tag.type == tips.type)).toList();
        // print('<div>${updatedList[3].description}</div>');
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Health Tips',style: getMediumStyle(color: ColorManager.black,fontSize:18),),
                IconButton(onPressed: (){
                  _showMultiSelect(context,token??'');
                }, icon: FaIcon(FontAwesomeIcons.checkSquare,size: 20,color: ColorManager.orange.withOpacity(0.7),))
              ],
            ),
            CarouselSlider(
              carouselController: _carouselController,

              options: CarouselOptions(
                height: 150.h,
                // aspectRatio: 16/5,
                // enlargeCenterPage: true,
                pageSnapping: true,
                autoPlay:updatedList.length >1? true : false,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: false,
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
              items: updatedList.map((tips) {
                int index = updatedList.indexOf(tips) % imageList.length;


                return Container(
                  width: double.infinity,
                  // height: 200,
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  padding: EdgeInsets.only( top: 8,bottom: 8),
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

                      //
                      // HtmlWidget(
                      //   tips.description!,
                      //   textStyle: TextStyle(color: ColorManager.white),
                      //   customStylesBuilder: (element) {
                      //     if (element.localName == 'body') {
                      //       // Set the maximum number of lines using CSS style
                      //       return {'max-height': '1em', 'overflow': 'hidden'};
                      //     }
                      //     return null;
                      //   },
                      // )

                      Html(
                        data: '${tips.description}',style: {
                            'body' : Style(
                              color: ColorManager.white,
                              fontSize: FontSize.medium,
                              maxLines: 2,
                              textOverflow: TextOverflow.ellipsis,

                            )
                          },)

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
                          InkWell(
                            onTap: ()async{
                              await showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 18),
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text('Health Tips'),
                                          IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(CupertinoIcons.xmark_circle))
                                        ],
                                      ),
                                      titlePadding: EdgeInsets.symmetric(vertical: 12,horizontal: 18),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          HtmlWidget(
                                            tips.description!,
                                            textStyle: TextStyle(color: ColorManager.black),
                                          ),
                                          const SizedBox(height: 20,),
                                          Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text('By ${tips.createdBy}')),
                                          const SizedBox(height: 20,)
                                        ],
                                      ),
                                    );
                                  }
                              );
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
                                decoration: BoxDecoration(
                                    color: ColorManager.orange.withOpacity(0.7),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))
                                ),
                                child:Text('Read More',style: getMediumStyle(color: ColorManager.white, fontSize: 16.sp,))),
                          ),
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
              children: updatedList.asMap().entries.map((entry) {
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
      error: (error, stack) => SizedBox(),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
