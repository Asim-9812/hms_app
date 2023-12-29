



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';

class CND extends StatefulWidget {
  const CND({super.key});

  @override
  State<CND> createState() => _CNDState();
}

class _CNDState extends State<CND> {
  int frequency = 0;
  final TextEditingController _icController = TextEditingController();
  final TextEditingController _fcController = TextEditingController();
  final TextEditingController _fvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int format = 1;
  bool disableValidate = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white.withOpacity(0.99),
        appBar: AppBar(
          elevation: 3,
          backgroundColor: ColorManager.primary,
          title: Text('CND Based Dosage'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1. Initial Concentration?',style: getRegularStyle(color: ColorManager.black),),
                      w20,
                      Row(
                        children: [
                          Container(
                            width: 75,
                            child: TextFormField(
                              autovalidateMode: disableValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
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
                              controller: _icController,
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
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),


                          w10,
                          Text('mg/mL',style: getRegularStyle(color: ColorManager.black),),
                        ],
                      ),
                    ],
                  ),
                  h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('2. Final Concentration?',style: getRegularStyle(color: ColorManager.black),),
                      w20,
                      Row(
                        children: [
                          Container(
                            width: 75,
                            child: TextFormField(
                              autovalidateMode: disableValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
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
                              controller: _fcController,
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
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          w10,
                          Text('mL',style: getRegularStyle(color: ColorManager.black),),
                        ],
                      ),
                    ],
                  ),
                  h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('3. Final volume?',style: getRegularStyle(color: ColorManager.black),),
                      w20,
                      Row(
                        children: [
                          Container(
                            width: 75,
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
                              controller: _fvController,
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

                            )
                          ),
                          w10,
                          Text('mL',style: getRegularStyle(color: ColorManager.black),),
                        ],
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
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                              _calculateDose(c1: double.parse(_icController.text),
                                  c2: double.parse(_fcController.text),
                                  v2: double.parse(_fvController.text));

                              setState(() {
                                disableValidate = false;
                              });
                              _icController.clear();
                              _fvController.clear();
                              _fcController.clear();


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
    required double c1,
    required double v2,
    required double c2,

  })async{
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;

    final v1  = (c2*v2)/c1;
    await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: ColorManager.white.withOpacity(0.7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            content: Column(
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
                        child: Center(child: Text('Initial Volume',style: getMediumStyle(color: ColorManager.white),)),
                      ),
                      h20,
                      Text('${v1.toPrecision(2)} mL',style: getMediumStyle(color: ColorManager.white),),
                      h20,
                    ],
                  ),
                ),
                h20,
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(300)
                    ),
                    onPressed: () {

                      setState(() {
                        _formKey.currentState!.reset();
                        disableValidate = true;
                      });


                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    }, child: Text('OK')),



              ],
            ),
          );


        }
    );


  }



}
