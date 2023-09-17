import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';


import '../../core/resources/string_manager.dart';
import '../../core/resources/style_manager.dart';
import '../../core/resources/value_manager.dart';
import 'list_of_bmi_category/bmi_list.dart';


class IBW extends StatefulWidget {
  @override
  IBWState createState() => IBWState();
}

class IBWState extends State<IBW> {
  double _linePositionY = 200.0;
  double y = 0.4; // Initial Y position of the line
  int selectedOption = 1;
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  // final TextEditingController feetController = TextEditingController();
  // final TextEditingController inchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  double result = 0.0;
  List bmiList = bmiCategories;
  int category = 0;
  int unit =1;
  int invalidType = 0;
  bool disableValidate = true;

  double _calculateHeight(double y){
    double res = 10 - (y * 10).toPrecision(1);
    return res;
  }

  double _convertCM(double y){
    double res = 11.75*y+55.75 ;
    return res;
  }


  int _calculateIBW({
    required double h,
    required double g
  }) {
    double m = g + 0.9 * (h-152.4);
    setState(() {
      result = m;
      isLoading = false;
    });
    return m.round();
  }



  (String,int,int) _convertCmToFeetAndInches(double cm) {
    final int totalInches = (cm * 0.393701).round();
    final int feet = totalInches ~/ 12;
    final int inches = totalInches % 12;

    return ('$feet\'$inches"',feet,inches);
  }

  double convertFeetAndInchesToCm(int feet, int inches) {
    double totalCm = (feet * 30.48) + (inches * 2.54);
    return totalCm;
  }





  Future<void> _showDialog(int height,bool isWideScreen,bool isNarrowScreen) async {

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
                  Text('Your Ideal Body Weight is',style: getMediumStyle(color: Colors.black),),
                  h20,
                  Text('$height Kg',style: getMediumStyle(color: Colors.black),),
                  h20,
                  h20,
                  Text('Please keep in mind that this is an approximate estimate and individual factors may vary.',style: getRegularStyle(color: ColorManager.black),textAlign: TextAlign.justify,)

                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size.fromWidth(200.w),
                      backgroundColor: ColorManager.primary
                  ),
                  onPressed: () {
                    setState(() {
                      isLoading = false;
                      _formKey.currentState!.reset();
                      disableValidate = true;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('OK',style: getMediumStyle(color: Colors.white,fontSize: 16),)
              )
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        }
    );

  }

  bool weightValid = true;
  bool ageValid = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 420;

    double fontSize = isWideScreen?14: 14.sp;
    double height = _calculateHeight(y);
    double heightCM = _convertCM(height);
    double convertToCm = convertFeetAndInchesToCm(_convertCmToFeetAndInches(heightCM).$2,_convertCmToFeetAndInches(heightCM).$3);
    double size = isWideScreen? ((_calculateHeight(y).toPrecision(1) * 25)+40):((_calculateHeight(y).toPrecision(1) * 25)+40).sp;
    (size);
    // Get the screen size

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 3,
          backgroundColor: ColorManager.primary,
          title: Text('IBW Calculator'),
          centerTitle: true,
          titleTextStyle: getMediumStyle(color: ColorManager.white),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 1.4 / 2,
                child: GestureDetector(
                  onVerticalDragUpdate: (value) {
                    double yValue = value.delta.dy;
                    if ((y > -1.0 && y <= 0.7) || (yValue > 0 && y <= 0.7)) {
                      // Only allow dragging if y is in the range of -0.1 to 0.5
                      setState(() {
                        y += yValue * 0.004;

                        // Limit y within the range of -0.1 to 0.5
                        y = y.clamp(-1.0, 0.7);


                      });
                      // (yValue > 0 ? 'downward' : 'upward');
                    }
                  },
                  child: Row(
                    children: [
                      Form(
                        key:_formKey,
                        child: Container(
                          width:MediaQuery.of(context).size.width * 1/ 2 ,
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          height: MediaQuery.of(context).size.height ,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Gender',style: getMediumStyle(color: ColorManager.black,fontSize: 18),),
                              h20,
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  Container(
                                    height: 100,
                                    width: 90.w,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedOption = 1;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: selectedOption == 1 ? ColorManager.primaryDark : ColorManager.dotGrey),
                                              shape: BoxShape.circle,
                                              color: selectedOption == 1 ? ColorManager.primary : Colors.transparent,
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
                                            style: getRegularStyle(color: selectedOption == 1 ? ColorManager.black : ColorManager.textGrey, fontSize: fontSize),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  w05,
                                  Container(
                                    height: 100,
                                    width: 90.w,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedOption = 2;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: selectedOption == 2 ? ColorManager.primaryDark : ColorManager.dotGrey),
                                              shape: BoxShape.circle,
                                              color: selectedOption ==2 ? ColorManager.primary : Colors.transparent,
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
                                            style: getRegularStyle(color: selectedOption == 2 ? ColorManager.black : ColorManager.textGrey, fontSize: fontSize),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              h20,
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
                                          else if (int.parse(value) <= 0){
                                            return 'Invalid';
                                          }
                                          else{

                                            return null;
                                          }
                                        },
                                        controller: ageController,
                                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                                        style: getMediumStyle(color: ColorManager.black),
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: ColorManager.dotGrey.withOpacity(0.2),
                                            border: OutlineInputBorder(
                                            )
                                        ),
                                      ),
                                    ),
                                    w10,
                                    Text('yrs old')
                                  ],
                                ),
                              ),
                              h20,
                              Text('Height',style: getMediumStyle(color: ColorManager.black,fontSize: 18),),
                              h10,
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 18.w),
                                color: ColorManager.dotGrey.withOpacity(0.2),
                                padding:EdgeInsets.symmetric(horizontal: 8.w,vertical: 12.h) ,
                                child: Row(
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
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width * 1/ 2 ,
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        height: MediaQuery.of(context).size.height ,
                        decoration: BoxDecoration(
                            color: ColorManager.primary,
                            border: BorderDirectional(
                              start: BorderSide(
                                color: ColorManager.primaryDark,
                              ),
                              bottom: BorderSide(
                                  color: ColorManager.primaryDark
                              ),

                            )
                        ),
                        child: Container(
                          color: ColorManager.white,
                          child: Stack(
                            children: [

                              Align(
                                alignment: Alignment.bottomLeft,
                                child:  Container(
                                  width: 50,
                                  height: MediaQuery.of(context).size.height*0.8,
                                  decoration: BoxDecoration(
                                      color: ColorManager.primary,
                                      border: Border.all(
                                          color: ColorManager.primaryDark
                                      )
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      50, // Number of scale divisions
                                          (index) {
                                        double position =  index *0.01;
                                        return Container(
                                          height: 5,
                                          color: Colors.white,
                                          margin: EdgeInsets.only(top: position),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 5.h),
                                  child: Image.asset(selectedOption == 1 ? 'assets/icons/man.png':'assets/icons/woman.png',width: 120.w,height: size,fit: BoxFit.fitHeight,),
                                ),
                              ),
                              Align(
                                alignment: Alignment(0, y*1.03),
                                child: Container(
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        color: ColorManager.primary,
                                        height: 50,
                                        width: 70,
                                        child: Center(
                                          child: Text(unit ==1 ?
                                          '${ heightCM.toPrecision(1)} cm':'${_convertCmToFeetAndInches(heightCM).$1} ft' ,
                                            style: getRegularStyle(color: ColorManager.white),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 0.5,
                                        width: double.infinity,
                                        color: ColorManager.primaryDark,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              h20,
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      fixedSize: Size.fromWidth(250.w)
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      if(ageValid == true && weightValid == true){
                        if(selectedOption == 1){
                          if(unit == 1){
                            int x=  _calculateIBW(h:heightCM.toPrecision(1),g: 50 );
                            _showDialog(x,isWideScreen,isNarrowScreen);
                            setState(() {
                              disableValidate = false;
                            });
                            weightController.clear();
                            ageController.clear();
                          }
                          else{
                            int x=  _calculateIBW( h:convertToCm.toPrecision(1),g: 50 );
                            _showDialog(x,isWideScreen,isNarrowScreen);
                            setState(() {
                              disableValidate = false;
                            });
                            weightController.clear();
                            ageController.clear();
                          }

                        } else {
                          if(unit == 1){
                            int x=  _calculateIBW(h:heightCM.toPrecision(1),g: 45.5 );
                            _showDialog(x,isWideScreen,isNarrowScreen);
                            setState(() {
                              disableValidate = false;
                            });
                            weightController.clear();
                            ageController.clear();
                          }
                          else{
                            int x=  _calculateIBW(h:convertToCm.toPrecision(1),g: 45.5 );
                            _showDialog(x,isWideScreen,isNarrowScreen);
                            setState(() {
                              disableValidate = false;
                            });
                            weightController.clear();
                            ageController.clear();
                          }
                        }
                      }



                    }
                  },
                  child:isLoading? SpinKitDualRing(color: ColorManager.white): Text('Calculate'),
                ),
              ),
              h10,
              Container(
                height: 140,
                padding:EdgeInsets.symmetric(horizontal: 8.w) ,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(CupertinoIcons.info,color: ColorManager.black,),
                        w10,
                        Text('Disclaimer',style: getMediumStyle(color: ColorManager.black,fontSize: 20.sp),)
                      ],
                    ),
                    h10,
                    Expanded(child: Text('The calculator employs the B.J. Devine Formula (1974) for estimating ideal body weight based on limited input parameters; its results are indicative and not a substitute for professional medical advice.'
                      ,textAlign: TextAlign.justify,
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
