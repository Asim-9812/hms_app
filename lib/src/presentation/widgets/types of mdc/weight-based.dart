


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';

class WBD extends StatefulWidget {
  const WBD({super.key});

  @override
  State<WBD> createState() => _WBDState();
}

class _WBDState extends State<WBD> {
  int frequency = 1;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool weightValid = true;
  bool doseValid = true;
  int invalidType = 0;

  bool disableValidate = true;


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white.withOpacity(0.99),
        appBar: AppBar(
          elevation: 3,
          backgroundColor: ColorManager.primary,
          title: Text('Weight Based Dosage'),
          titleTextStyle: getMediumStyle(color: ColorManager.white),
          centerTitle: true,
          leading: IconButton(
            onPressed: ()=>Get.back(),
            icon: FaIcon(Icons.chevron_left,color: ColorManager.white,),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  h20,
                  Text('1. Patient\'s weight in KGs?',style: getRegularStyle(color: ColorManager.black),),
                  h10,
                  TextFormField(
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
                    style: getMediumStyle(color: ColorManager.black),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black.withOpacity(0.5)
                            )
                        ),
                      filled: true,
                      fillColor: ColorManager.dotGrey.withOpacity(0.2),
                      border: OutlineInputBorder(
                      )
                    ),
                  ),
                  h20,
                  Text('2. Recommended dosage per kg in mg/kg?',style: getRegularStyle(color: ColorManager.black),),
                  h10,
                  TextFormField(
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
                    controller: _dosageController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: getMediumStyle(color: ColorManager.black),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black.withOpacity(0.5)
                            )
                        ),
                        filled: true,
                        fillColor: ColorManager.dotGrey.withOpacity(0.2),
                        border: OutlineInputBorder(
                        )
                    ),
                  ),
                  h20,
                  Text('3. Frequency of the dosage once/every ?',style: getRegularStyle(color: ColorManager.black),),
                  h10,
                  GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 3/1,
                        crossAxisCount: 2),
                    children: [
                      RadioListTile<int>(
                        tileColor: ColorManager.dotGrey.withOpacity(0.3),
                        title: Text('24 hrs'),
                        value: 1,
                        groupValue: frequency,
                        onChanged: (value) {
                          setState(() {
                            frequency = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        tileColor: ColorManager.dotGrey.withOpacity(0.3),
                        title: Text('12 hrs'),
                        value: 2,
                        groupValue: frequency,
                        onChanged: (value) {
                          setState(() {
                            frequency = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        tileColor: ColorManager.dotGrey.withOpacity(0.3),
                        title: Text('8 hrs'),
                        value: 3,
                        groupValue: frequency,
                        onChanged: (value) {
                          setState(() {
                            frequency = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        tileColor: ColorManager.dotGrey.withOpacity(0.3),
                        title: Text('6 hrs'),
                        value: 4,
                        groupValue: frequency,
                        onChanged: (value) {
                          setState(() {
                            frequency = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        tileColor: ColorManager.dotGrey.withOpacity(0.3),
                        title: Text('4 hrs'),
                        value: 6,
                        groupValue: frequency,
                        onChanged: (value) {
                          setState(() {
                            frequency = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        tileColor: ColorManager.dotGrey.withOpacity(0.3),
                        title: Text('3 hrs'),
                        value: 8,
                        groupValue: frequency,
                        onChanged: (value) {
                          setState(() {
                            frequency = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        tileColor: ColorManager.dotGrey.withOpacity(0.3),
                        title: Text('2 hrs'),
                        value: 12,
                        groupValue: frequency,
                        onChanged: (value) {
                          setState(() {
                            frequency = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        tileColor: ColorManager.dotGrey.withOpacity(0.3),
                        title: Text('1 hr'),
                        value: 24,
                        groupValue: frequency,
                        onChanged: (value) {
                          setState(() {
                            frequency = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  h20,
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primaryDark,
                        fixedSize: Size.fromWidth(300)
                      ),
                        onPressed: (){
                        if(_formKey.currentState!.validate()){
                            _calculateDose(w: double.parse(_weightController.text), d: double.parse(_dosageController.text), f: frequency);
                            setState(() {
                              disableValidate = false;
                            });
                            _weightController.clear();
                            _dosageController.clear();


                        }

                        },
                        child: Text('Calculate',style: getMediumStyle(color: ColorManager.white,fontSize: 16),)),
                  ),
                  h100,

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  _calculateDose({
  required double w,
    required double d,
    required int f
  }){
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;
    final dose = w * d;
    final total = dose * f;
    ('$dose , $total');
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: ColorManager.white.withOpacity(0.7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: isWideScreen? 300:300.w,
                    decoration: BoxDecoration(
                      color: ColorManager.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: ColorManager.black.withOpacity(0.7),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                          child: Text('Calculated amount per single dose',style: getMediumStyle(color: ColorManager.white),),
                        ),
                        h20,
                        Text('${dose.round()}mg/kg',style: getMediumStyle(color: ColorManager.white),),
                        h20,
                      ],
                    ),
                  ),
                  h20,
                  Container(

                    decoration: BoxDecoration(
                        color: ColorManager.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: isWideScreen? 300:300.w,
                          decoration: BoxDecoration(
                              color: ColorManager.black.withOpacity(0.5),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                          child: Center(child: Text('Total daily dosage',style: getMediumStyle(color: ColorManager.white),)),
                        ),
                        h20,
                        Text('${total.round()}mg/kg',style: getMediumStyle(color: ColorManager.white),),
                        h20
                      ],
                    ),
                  ),
                  h20,
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(300)
                      ),
                      onPressed: (){
                        setState(() {
                          _formKey.currentState!.reset();
                          disableValidate = true;
                        });

                        FocusScope.of(context).unfocus();
                        Navigator.pop(context);

                      }, child: Text('OK')),
                


                ],
              ),
            ),
          );
        }
    );
}
}
