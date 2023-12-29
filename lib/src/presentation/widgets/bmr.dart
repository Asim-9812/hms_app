


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../core/resources/style_manager.dart';
import '../../core/resources/value_manager.dart';
import 'list_of_bmi_category/bmi_list.dart';

class BMR extends StatefulWidget {
  const BMR({super.key});

  @override
  State<BMR> createState() => _BMRState();
}

class _BMRState extends State<BMR> {

  double minHeight = 91.44;
  double maxHeight = 243.84;
  double _value = (243.84+91.44)/2; //initial value i.e. avg of max and min height
  double result = 0.0;
  int gender = 1;
  bool disableValidate = true;
  int unit =1;
  List bmiList = bmiCategories;

  final _formKey = GlobalKey<FormState>();

  TextEditingController _ageController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _cmController = TextEditingController();
  TextEditingController _ftController = TextEditingController();
  TextEditingController _inchController = TextEditingController();



  (String,int,int) _convertCmToFeetAndInches(double cm) {
    final int totalInches = (cm * 0.393701).round();
    final int feet = totalInches ~/ 12;
    final int inches = totalInches % 12;

    return ('$feet\'$inches"',feet,inches);
  }



  void _calculateBMR({
    required double w,
    required double h,
    required double a
  }) {
    if(gender == 1){
      double bmr = 10 * w + 6.25 * h - 5 * a + 5;
      setState(() {
        result = bmr;
      });
      _showDialog();
    } else{
      double bmr = 10 * w + 6.25 * h- 5 * a - 161;
      setState(() {
        result = bmr;
      });
      _showDialog();
    }

  }



  Future<void> _showDialog() async {
    final List<Map<String, String>> activityLevels = [
      {
        'activityLevel': 'Sedentary: little or no exercise',
        'calorie': '${result.round() + 300}',
      },
      {
        'activityLevel': 'Exercise 1-3 times/week',
        'calorie': '${result.round() + 673}',
      },
      {
        'activityLevel': 'Exercise 4-5 times/week',
        'calorie': '${result.round() + 836}',
      },
      {
        'activityLevel': 'Daily exercise or intense exercise 3-4 times/week',
        'calorie': '${result.round() + 990}',
      },
      {
        'activityLevel': 'Intense exercise 6-7 times/week',
        'calorie': '${result.round() + 1307}',
      },
      {
        'activityLevel': 'Very intense exercise daily, or physical job',
        'calorie': '${result.round() + 1624}',
      },
    ];
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            content: Container(
              // height: 450.h,
              width: MediaQuery.of(context).size.height*2/3,
              // color: Colors.red,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Calculated BMR',style: getMediumStyle(color: Colors.black),),
                  Text('${result.round()} calories/day',style: getMediumStyle(color: ColorManager.black,fontSize: 18),),
                  h10,
                  Text('Daily calorie needs based on activity level',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),

                  ListTile(
                    tileColor: ColorManager.primary,
                    title: Text('Activity Level',style: getRegularStyle(color: ColorManager.white,fontSize: 20),),
                    trailing: Text('Calories',style: getRegularStyle(color: ColorManager.white,fontSize: 16),),
                  ),
                  h10,
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: activityLevels.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        shape: Border(
                            bottom: BorderSide(
                                color: ColorManager.black.withOpacity(0.5)
                            )
                        ),
                        title: Text(activityLevels[index]['activityLevel']!,style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                        trailing: Text('${activityLevels[index]['calorie']}',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                      );
                    },
                  )

                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromWidth(200.w),
                      backgroundColor: ColorManager.primary
                  ),
                  onPressed: ()=>Navigator.pop(context),
                  child: Text('OK',style: getMediumStyle(color: Colors.white,fontSize: 16),)
              )
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        }
    );

  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white.withOpacity(0.9),
        appBar: AppBar(
          elevation: 3,
          backgroundColor: ColorManager.primary,
          title: Text('BMR Calculator'),
          titleTextStyle: getMediumStyle(color: ColorManager.white),
          centerTitle: true,
          leading: IconButton(
            onPressed: ()=>Get.back(),
            icon: FaIcon(Icons.chevron_left,color: ColorManager.white,),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              Row(
                children: [

                  Container(
                    height: MediaQuery.of(context).size.height*1.6/2,
                    width: MediaQuery.of(context).size.width*0.8/2,
                    padding: EdgeInsets.only(left: 8.w,top: 8.h,right: 8.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),

                            child: Column(
                              children: [
                                Text('Gender',style: getMediumStyle(color: ColorManager.black,fontSize: 18),),
                                h20,
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [

                                    Container(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            gender = 1;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: gender ==1 ? ColorManager.primary: ColorManager.dotGrey),
                                                shape: BoxShape.circle,
                                                color: gender ==1 ?ColorManager.primary :Colors.transparent,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  'assets/icons/man.png',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                            ),
                                            h10,
                                            Text(
                                              'Male',
                                              style: getRegularStyle(color:gender ==1 ?ColorManager.black:  ColorManager.textGrey, fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    w10,
                                    Container(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            gender = 2;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: gender ==2 ? ColorManager.primary: ColorManager.dotGrey),
                                                shape: BoxShape.circle,
                                                color: gender ==2 ? ColorManager.primary: Colors.transparent,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  'assets/icons/woman.png',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                            ),
                                            h10,
                                            Text(
                                              'Female',
                                              style: getRegularStyle(color: gender == 2? ColorManager.black: ColorManager.textGrey, fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                          h10,
                          Container(
                            decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Age',style: getMediumStyle(color: ColorManager.black,fontSize: 18),),
                                h10,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          autovalidateMode: disableValidate? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                                          validator: (value){
                                            if(value!.isEmpty){
                                              return 'Required';
                                            }
                                            else if (int.tryParse(value) == null || int.parse(value) <= 0) {
                                              return 'Invalid';
                                            }

                                            else if (RegExp(r'^(?=.*?[A-Z])').hasMatch(value)||RegExp(r'^(?=.*?[a-z])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value))  {
                                              return 'Invalid';
                                            }
                                            else if (int.parse(value) > 100){
                                              return 'Invalid';
                                            }
                                            else{

                                              return null;
                                            }
                                          },
                                          controller: _ageController,
                                          keyboardType: TextInputType.number,
                                          style: getMediumStyle(color: ColorManager.black,fontSize: 16),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black.withOpacity(0.5)
                            )
                        ),
                                            filled: true,
                                            fillColor: ColorManager.dotGrey.withOpacity(0.2),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ColorManager.black.withOpacity(0.5)
                                                )
                                            ),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ColorManager.black.withOpacity(0.5)
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      w05,
                                      Text('yrs old')
                                    ],
                                  ),
                                ),
                                h20,
                                Text('Weight',style: getMediumStyle(color: ColorManager.black,fontSize: 18),),
                                h10,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          autovalidateMode: disableValidate? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Required';
                                            } else if (RegExp(r'^(?=.*?[A-Z])').hasMatch(value) || RegExp(r'^(?=.*?[a-z])').hasMatch(value) || RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)) {
                                              return 'Invalid';
                                            } else {
                                              try {
                                                final numericValue = double.tryParse(value.replaceAll(',', '.').trim());
                                                if (numericValue == null || numericValue <= 0) {
                                                  return 'Invalid';
                                                }
                                              } catch (e) {
                                                return 'Invalid';
                                              }
                                              return null;
                                            }
                                          },
                                          controller: _weightController,
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          style: getMediumStyle(color: ColorManager.black,fontSize: 16),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black.withOpacity(0.5)
                            )
                        ),
                                            filled: true,
                                            fillColor: ColorManager.dotGrey.withOpacity(0.2),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ColorManager.black.withOpacity(0.5)
                                                )
                                            ),

                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ColorManager.black.withOpacity(0.5)
                                                )
                                            ),

                                          ),
                                        ),
                                      ),
                                      w05,
                                      Text('in Kgs')
                                    ],
                                  ),
                                ),


                              ],
                            ),
                          ),
                          h10,
                          Container(
                            decoration: BoxDecoration(
                                color: ColorManager.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                            child: Column(
                              children: [
                                Text('Height',style: getMediumStyle(color: ColorManager.black,fontSize: 18),),
                                h10,
                                unit == 1
                                    ?Container(
                                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                                  child:  TextFormField(
                                    autovalidateMode: disableValidate? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                                    validator: (value){
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      } else {
                                        try {
                                          double parsedValue = double.parse(value);
                                          if (parsedValue >= maxHeight || parsedValue < minHeight) {
                                            return 'Invalid';
                                          }
                                        } catch (e) {
                                          return 'Invalid';
                                        }
                                      }
                                      return null;
                                    },
                                    onChanged: (value){
                                      setState(() {
                                        _value = double.parse(value);
                                      });
                                    },
                                    controller: _cmController,
                                    keyboardType: TextInputType.number,
                                    style: getMediumStyle(color: ColorManager.black,fontSize: 16),
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black.withOpacity(0.5)
                            )
                        ),
                                        filled: true,
                                        fillColor: ColorManager.dotGrey.withOpacity(0.2),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorManager.black.withOpacity(0.5)
                                            )
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorManager.black.withOpacity(0.5)
                                            )
                                        ),
                                        labelText: 'cm'


                                    ),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6)
                                    ],
                                  ),
                                )
                                    :Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 18.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          autovalidateMode: disableValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Required';
                                            }
                                            if (!value.contains(RegExp(r'^\d+$'))) {
                                              return 'Invalid';
                                            }
                                            if(int.parse(value) > 8){
                                              return 'Invalid';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _value = (int.parse(_ftController.text) * 30.48) + ((_inchController.text.isNotEmpty ? int.parse(_inchController.text) : 0) * 2.54);
                                            });
                                          },
                                          controller: _ftController, // Controller for feet
                                          keyboardType: TextInputType.number,
                                          style: getMediumStyle(color: ColorManager.black,fontSize: 16),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black.withOpacity(0.5)
                            )
                        ),
                                              filled: true,
                                              fillColor: ColorManager.dotGrey.withOpacity(0.2),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: ColorManager.black.withOpacity(0.5),
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: ColorManager.black.withOpacity(0.5),
                                                ),
                                              ),
                                              labelText: 'ft'
                                          ),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(2),
                                          ],
                                        ),
                                      ),
                                      w10,
                                      Expanded(
                                        child: TextFormField(
                                          autovalidateMode: disableValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Required';
                                            }
                                            if (!value.contains(RegExp(r'^\d+$'))) {
                                              return 'Invalid';
                                            }
                                            if(int.parse(value) > 11){
                                              return 'Invalid';
                                            }
                                            if(_ftController.text.isNotEmpty){
                                              if(int.parse(_ftController.text)== 8 && int.parse(_inchController.text)>0){
                                                return 'Invalid';
                                              }
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _value = (int.parse(_ftController.text) * 30.48) + (int.parse(_inchController.text) * 2.54);
                                            });
                                          },
                                          controller: _inchController, // Controller for inches
                                          keyboardType: TextInputType.number,
                                          style: getMediumStyle(color: ColorManager.black,fontSize: 16),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black.withOpacity(0.5)
                            )
                        ),
                                            filled: true,
                                            fillColor: ColorManager.dotGrey.withOpacity(0.2),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: ColorManager.black.withOpacity(0.5),
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: ColorManager.black.withOpacity(0.5),
                                              ),
                                            ),
                                            labelText: 'in',
                                          ),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(2),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                h10,
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          unit =1;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: unit == 1? ColorManager.primary : ColorManager.white,
                                            border: unit !=1 ?Border.all(
                                                color: ColorManager.black.withOpacity(0.5)
                                            ):null
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
                                        child: Text('CM',style: getMediumStyle(color:unit ==1 ? ColorManager.white: ColorManager.black,fontSize: 20),),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          unit =2 ;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: unit == 2? ColorManager.primary : ColorManager.white,
                                            border: unit !=2 ?Border.all(
                                                color: ColorManager.black.withOpacity(0.5)
                                            ):null
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
                                        child: Text('FT',style: getMediumStyle(color:unit==2?ColorManager.white: ColorManager.black,fontSize: 20),),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),

                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(

                      // decoration: BoxDecoration(
                      //   border: BorderDirectional(
                      //     start: BorderSide(
                      //       color: ColorManager.black
                      //     ),
                      //     bottom: BorderSide(
                      //       color: ColorManager.black
                      //     )
                      //   )
                      // ),
                      height: MediaQuery.of(context).size.height*1.6/2,
                      child: Container(
                        margin: EdgeInsets.only(right: 12.w,top: 8.h),
                        padding: EdgeInsets.only(bottom: 8.w),
                        decoration: BoxDecoration(
                            color: ColorManager.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            h10,
                            Text(unit == 1  ? 'HEIGHT (in cm)':'HEIGHT (in ft)',style: getMediumStyle(color: ColorManager.black,fontSize: 18),),
                            h10,
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SfSlider.vertical(
                                    activeColor: ColorManager.primary,
                                    inactiveColor: ColorManager.primary.withOpacity(0.2),
                                    min: minHeight,
                                    max: maxHeight,
                                    value: _value < minHeight? minHeight : _value > maxHeight ? maxHeight : _value,
                                    interval: 30.48,
                                    showTicks: true,
                                    showLabels: true,
                                    enableTooltip: true,
                                    labelFormatterCallback: (actualValue, formattedText) => unit == 1 ? '${actualValue.round()}' : '${_convertCmToFeetAndInches(actualValue).$1}',
                                    tooltipPosition: SliderTooltipPosition.right,
                                    tooltipTextFormatterCallback: (actualValue, formattedText) => unit == 1 ? '${actualValue.round()} cm' :'${_convertCmToFeetAndInches(actualValue).$1} FT' ,
                                    minorTicksPerInterval: 1,
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        _value = value;
                                        _cmController.text = _value.toPrecision(2).toString();
                                        _ftController.text = _convertCmToFeetAndInches(value).$2.toString();
                                        _inchController.text = _convertCmToFeetAndInches(value).$3.toString();
                                      });
                                    },
                                  ),
                                  w20,
                                  Image.asset(gender == 1 ?'assets/icons/man.png':'assets/icons/woman.png',width: 150.w,height : _value < 91 ? (91*91/120) : _value > 243 ? (243*243/120) : (_value*_value/120),fit: BoxFit.fitHeight,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              h10,
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      fixedSize : Size.fromWidth(300.w)

                  ),
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                     _calculateBMR(w: double.parse(_weightController.text), h: _value, a: double.parse(_ageController.text));

                    }
                  },
                  child: Text('Calculate',style: TextStyle(color: ColorManager.white),))

            ],
          ),
        ),
      ),
    );
  }


}