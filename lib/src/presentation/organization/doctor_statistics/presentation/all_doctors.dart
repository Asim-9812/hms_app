




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';

import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../../dummy_datas/dummy_datas.dart';

class DoctorsList extends StatefulWidget {


  @override
  State<DoctorsList> createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {

  final TextEditingController _searchController =TextEditingController();
  List<Map<String, dynamic>> filteredDoctorsData = doctorsData;


  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    (screenSize);

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;
    bool isExtraWide = screenSize.width > 1000;
    bool isExtraNarrow = screenSize.width <350;


    ImageProvider<Object>? profileImage;
      profileImage = AssetImage('assets/icons/user.png');



    int _crossAxisCount(){
      if(isWideScreen){
        return 4;
      } else if(isNarrowScreen){
        return 2;
      } else if(isExtraNarrow){
        return 1;
      } else if(isExtraWide){
        return 5;
      } else{
        return 3;
      }

    }

    Color _getDepartmentColor(int id){
      if(id == 1){
        return ColorManager.red.withOpacity(0.6);
      } else if(id == 2){
        return ColorManager.primary.withOpacity(0.8);
      } else if(id == 3){
        return ColorManager.orange.withOpacity(0.7);
      } else if(id == 4){
        return ColorManager.primaryDark.withOpacity(0.8);
      } else if(id == 5){
        return ColorManager.accentPink.withOpacity(0.7);
      } else {
        return ColorManager.white;
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.primary.withOpacity(0.7),

          title: Text('Doctors',style: getMediumStyle(color: ColorManager.white,fontSize: 24),),
          actions: [
            IconButton(onPressed: (){}, icon: FaIcon(Icons.filter_list))
          ],
        ),
        body: Column(
          children: [
            h20,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18.w),
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              decoration: BoxDecoration(
                color: ColorManager.searchColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: ColorManager.searchColor, width: 1),
              ),
              child: TextFormField(

                controller: _searchController,
                style: getRegularStyle(color: ColorManager.black,fontSize: 16),
                onChanged: (value) {
                  setState(() {
                    filteredDoctorsData = doctorsData
                        .where((doctor) =>
                    doctor['name']
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                        doctor['department']
                            .toString()
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search...'
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*4/5,
              child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                  itemCount: filteredDoctorsData.length,
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _crossAxisCount(),
                      childAspectRatio: 1/2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10
                  ) ,
                  itemBuilder: (context,index){
                    return Container(
                      decoration: BoxDecoration(
                          color: _getDepartmentColor(filteredDoctorsData[index]['department_id']),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        color: ColorManager.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Card(
                              color: Colors.grey,
                              shape: CircleBorder(
                                  side: BorderSide(
                                    width: 2,
                                    color: ColorManager.black.withOpacity(0.5),
                                  )
                              ),
                              child: CircleAvatar(
                                radius: 40.r,
                                backgroundColor: ColorManager.white,
                                backgroundImage: profileImage ,
                              ),
                            ),
                            h20,
                            Text('${filteredDoctorsData[index]['name']}',style: getMediumStyle(color: ColorManager.black,fontSize: isWideScreen?16:16.sp),),
                            h10,
                            Text('${filteredDoctorsData[index]['department']}',style: getMediumStyle(color: ColorManager.black,fontSize: isWideScreen?16:16.sp),),

                          ],
                        ),

                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
