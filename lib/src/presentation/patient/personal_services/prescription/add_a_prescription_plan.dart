



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';

import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';

class AddPrescriptionPlan extends StatefulWidget {
  const AddPrescriptionPlan({super.key});

  @override
  State<AddPrescriptionPlan> createState() => _AddPrescriptionPlanState();
}

class _AddPrescriptionPlanState extends State<AddPrescriptionPlan> {

  List<String> natureType = ['Select','tablets', 'mg/ml'];
  int natureId = 0;
  String selectedNatureType = 'Select';
  int selectTime = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          title: Text('Add a plan',style: getMediumStyle(color: ColorManager.black),),
          elevation: 1,
          backgroundColor: ColorManager.white,
          leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.chevron_left,color: Colors.black,)),
          centerTitle:true,

        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                h20,
                Text('Pill name',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                h10,
                Container(
                  decoration: BoxDecoration(
                    color: ColorManager.dotGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorManager.black.withOpacity(0.5)
                    )
                  ),
                  child: TextFormField(
                    style: getRegularStyle(color: ColorManager.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                      hintText: 'Enter a pill name',
                    ),
                  ),
                ),
                h20,
                h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('How many/much?',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                        h10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 75,
                              decoration: BoxDecoration(
                                  color: ColorManager.dotGrey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: ColorManager.black.withOpacity(0.5)
                                  )
                              ),
                              child: TextFormField(
                                style: getRegularStyle(color: ColorManager.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                                ),
                              ),
                            ),
                            w10,
                            Container(
                              width: 100,
                              child: DropdownButtonFormField<String>(
                                validator: (value){
                                  if(selectedNatureType == natureType[0]){
                                    return 'Please select a nature type';
                                  }
                                  return null;
                                },
                                value: selectedNatureType,
                                decoration: InputDecoration(
                                 border: InputBorder.none
                                ),
                                items: natureType
                                    .map(
                                      (String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: getRegularStyle(color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                    .toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedNatureType = value!;
                                    natureId = natureType.indexOf(value);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    h20,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('How long?',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                        h10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 75,
                              decoration: BoxDecoration(
                                  color: ColorManager.dotGrey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: ColorManager.black.withOpacity(0.5)
                                  )
                              ),
                              child: TextFormField(
                                style: getRegularStyle(color: ColorManager.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 18.w),
                                ),
                              ),
                            ),
                            w10,
                            Text('in days',style: getRegularStyle(color: ColorManager.black),)
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                h20,
                h20,
                Text('When to take',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectTime=1;
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: selectTime==1?ColorManager.primary:ColorManager.dotGrey.withOpacity(0.2),
                          border: Border.all(
                            color: ColorManager.black.withOpacity(0.5)
                          ),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Center(
                          child: Text('Before a meal',style: getMediumStyle(color:selectTime==1?ColorManager.white: ColorManager.black,fontSize: 20),textAlign: TextAlign.center,),
                        ) ,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectTime=2;
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: selectTime==2?ColorManager.primary:ColorManager.dotGrey.withOpacity(0.2),
                          border: Border.all(
                            color: ColorManager.black.withOpacity(0.5)
                          ),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Center(
                          child: Text('With a meal',style: getMediumStyle(color:selectTime==2?ColorManager.white: ColorManager.black,fontSize: 20),textAlign: TextAlign.center,),
                        ) ,
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectTime=3;
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: selectTime==3?ColorManager.primary:ColorManager.dotGrey.withOpacity(0.2),
                          border: Border.all(
                            color: ColorManager.black.withOpacity(0.5)
                          ),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Center(
                          child: Text('After a meal',style: getMediumStyle(color:selectTime==3?ColorManager.white: ColorManager.black,fontSize: 20),textAlign: TextAlign.center,),
                        ) ,
                      ),
                    ),
                  ],
                ),
                h20,
                h20,
                Text('Additional Notes',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                h20,
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: ColorManager.dotGrey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorManager.black.withOpacity(0.4)
                    )
                  ),
                  child: TextFormField(
                    maxLines: null,
                    style: getRegularStyle(color: ColorManager.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h)
                    ),
                  ),
                ),
                h20,
                h20,
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryDark,
                      fixedSize: Size.fromWidth(320.w)
                    ),
                      onPressed: (){},
                      child: Text('Save Plan',style: getMediumStyle(color: ColorManager.white,fontSize: 16),)
                  ),
                )



              ],
            ),
          ),
        ),
      ),
    );
  }
}
