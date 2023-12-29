


import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

import '../../core/resources/value_manager.dart';
import '../common/snackbar.dart';

class EDD extends StatefulWidget {
  const EDD({super.key});

  @override
  State<EDD> createState() => _EDDState();
}

class _EDDState extends State<EDD> {
  final _formKey = GlobalKey<FormState>();
  String? calculatedEDD;
  String? calculatedNepEDD;
  NepaliDateTime? NepRange;

  // Function to calculate EDD
  String calculateEDD(DateTime date) {
    int day = date.day ?? 1;
    int month = date.month ?? 1;
    int year = date.year ?? DateTime.now().year;


    DateTime lastPeriodDate = DateTime(year, month, day);
    DateTime edd = lastPeriodDate.add(Duration(days: 280)); // Adding 280 days for EDD

    return DateFormat('MMMM dd, yyyy').format(edd); // Format EDD date
  }

  String calculateNepaliEDD(NepaliDateTime date) {
    int day = date.day ?? 1;
    int month = date.month ?? 1;
    int year = date.year ?? DateTime.now().year;

    setState(() {
      NepRange = calculateNepaliEDDRange(date);
    });


    NepaliDateTime lastPeriodDate = NepaliDateTime(year, month, day);
    NepaliDateTime edd = lastPeriodDate.add(Duration(days: 280)); // Adding 280 days for EDD

    return NepaliDateFormat('MMMM dd, yyyy').format(edd); // Format EDD date
  }

  NepaliDateTime calculateNepaliEDDRange(NepaliDateTime date) {
    int day = date.day ?? 1;
    int month = date.month ?? 1;
    int year = date.year ?? DateTime.now().year;


    NepaliDateTime lastPeriodDate = NepaliDateTime(year, month, day);
    NepaliDateTime edd = lastPeriodDate.add(Duration(days: 280)); // Adding 280 days for EDD

    return edd; // Format EDD date
  }

  int dateType = 1;
  String dateTime = '' ;
  String nepDateTime = '' ;
  DateTime? initialDate;
  NepaliDateTime? initialNepDate;





  bool invalid = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          elevation: 3,
          backgroundColor: ColorManager.primary,
          title: Text('EDD Calculator'),
          centerTitle: true,
          titleTextStyle: getMediumStyle(color: ColorManager.white),
          leading: IconButton(
            onPressed: ()=>Get.back(),
            icon: FaIcon(Icons.chevron_left,color: ColorManager.white,),
          ),

        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                h20,
                Text(
                  'When was the first day of your last period?',
                  style: getMediumStyle(color: ColorManager.black, fontSize: 20.sp),
                ),
                h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          dateType = 1;
                          dateTime = '';
                          calculatedNepEDD = null;
                          invalid=false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(80, 50),
                        side: BorderSide(
                            color: ColorManager.black
                        ),
                        elevation: 0,
                        backgroundColor: dateType==1? ColorManager.primary : ColorManager.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      child: Text('A.D.',style: getRegularStyle(color: dateType == 1 ? ColorManager.white:ColorManager.black,fontSize: 16),),
                    ),
                    w10,
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          dateType = 2;
                          nepDateTime = '';
                          calculatedEDD = null;
                          invalid=false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(80, 50),
                        side: BorderSide(
                            color: ColorManager.black
                        ),
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: dateType == 2 ? ColorManager.white:ColorManager.black
                        ),
                        elevation: 0,
                        backgroundColor:dateType==2? ColorManager.red.withOpacity(0.4) : ColorManager.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      child: Text('B.S.',style: getRegularStyle(color: dateType == 2 ? ColorManager.white:ColorManager.black,fontSize: 16)),
                    ),
                  ],
                ),
                h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          // color: ColorManager.lightBlueAccent.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: ColorManager.black
                        )
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('${dateType == 1 ? dateTime : nepDateTime}',style: getRegularStyle(color: ColorManager.black,fontSize: 18),),
                      ),
                    ),
                    w10,
                    dateType == 1
                        ? ElevatedButton(
                        onPressed: () async {
                          final DateTime currentDate = DateTime.now();
                          final DateTime nineMonthsAgo = currentDate.subtract(Duration(days: 9 * 30));
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate ?? DateTime.now(),
                            firstDate: nineMonthsAgo,
                            lastDate: DateTime.now(),
                          );
                          setState(() {
                            dateTime = DateFormat('yyyy-MM-dd').format(pickedDate!);
                            initialDate = pickedDate;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(50,50),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          elevation: 0,
                          backgroundColor: ColorManager.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        child: FaIcon(Icons.calendar_month,color: ColorManager.white,)
                    )
                        : ElevatedButton(
                        onPressed: () async {
                          final NepaliDateTime currentNepaliDate = NepaliDateTime.now();
                          final NepaliDateTime nineMonthsAgo = currentNepaliDate.subtract(Duration(days: 9 * 30));
                          picker.NepaliDateTime? _selectedNepaliDate = await picker.showMaterialDatePicker(
                            context: context,
                            initialDate: initialNepDate?? NepaliDateTime.now(),
                            firstDate: nineMonthsAgo,
                            lastDate: NepaliDateTime.now(),
                            initialDatePickerMode: DatePickerMode.day,
                          );
                          setState(() {
                            nepDateTime = NepaliDateFormat('yyyy-MM-dd').format(_selectedNepaliDate!);
                            initialNepDate = _selectedNepaliDate;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(50,50),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          elevation: 0,
                          backgroundColor: ColorManager.red.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        child: FaIcon(Icons.calendar_month,color: ColorManager.white,)
                    ),
                  ],
                ),
                h10,
                Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dateType == 1
                            ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.primaryDark
                            ),
                            onPressed: (){
                              final scaffoldMessage = ScaffoldMessenger.of(context);
                              if(dateTime == ''){
                                scaffoldMessage.showSnackBar(
                                  SnackbarUtil.showFailureSnackbar(
                                    message: 'Please pick a date',
                                    duration: const Duration(milliseconds: 1400),
                                  ),
                                );
                              }

                              final DateTime date = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.parse(dateTime)));

                              setState(() {
                                invalid = false;
                                calculatedEDD = calculateEDD(date);
                              });
                            },
                            child: Text('Calculate',style: getRegularStyle(color: ColorManager.white,fontSize: 20))
                        ) : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.primaryDark
                            ),
                            onPressed: (){
                              final scaffoldMessage = ScaffoldMessenger.of(context);
                              if(nepDateTime == ''){
                                scaffoldMessage.showSnackBar(
                                  SnackbarUtil.showFailureSnackbar(
                                    message: 'Please pick a date',
                                    duration: const Duration(milliseconds: 1400),
                                  ),
                                );
                              }

                              final NepaliDateTime date = NepaliDateTime.parse(NepaliDateFormat('yyyy-MM-dd').format(NepaliDateTime.parse(nepDateTime)));

                              setState(() {
                                invalid = false;
                                calculatedNepEDD = calculateNepaliEDD(date);
                              });
                            },
                            child: Text('Calculate',style: getRegularStyle(color: ColorManager.white,fontSize: 20),)
                        ) ,
                        w10,
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: ColorManager.dotGrey
                            ),
                            onPressed: (){
                              setState(() {
                                dateTime = '';
                                calculatedEDD = null;
                                calculatedNepEDD = null;
                                nepDateTime = '';
                                invalid=false;
                              });
                            },
                            child: Text('Clear',style: getRegularStyle(color: ColorManager.black),)
                        ),
                      ],
                    )
                ),
                h20,
                if (calculatedEDD != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Estimated Due Date :',
                            style: getMediumStyle(color: ColorManager.black, fontSize: 18),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '$calculatedEDD',
                            style: getMediumStyle(color: ColorManager.primaryDark, fontSize: 18),
                          ),
                          SizedBox(height: 30.h),
                          Text(
                            'Estimated Due Date Range :',
                            style: getMediumStyle(color: ColorManager.black, fontSize: 18),
                          ),
                          SizedBox(height: 10.h),
                          Text(calculateEDDRange(),style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                          SizedBox(height: 30.h),
                          Text(
                            'Disclaimer :',
                            style: getMediumStyle(color: ColorManager.black, fontSize: 18),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Please note that due dates are estimates and can vary for each individual. Factors such as menstrual cycle length, ovulation, and other medical considerations can influence the actual delivery date. Consult with a healthcare professional for personalized guidance.',
                            style: getRegularStyle(color: ColorManager.black, fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),

                if (calculatedNepEDD != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Estimated Due Date :',
                            style: getMediumStyle(color: ColorManager.black, fontSize: 18),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '$calculatedNepEDD',
                            style: getMediumStyle(color: ColorManager.primaryDark, fontSize: 18),
                          ),
                          SizedBox(height: 30.h),
                          Text(
                            'Estimated Due Date Range:',
                            style: getMediumStyle(color: ColorManager.black, fontSize: 18),
                          ),
                          SizedBox(height: 10.h),
                          Text(calculateNepEDDRange(),style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                          SizedBox(height: 30.h),
                          Text(
                            'Disclaimer :',
                            style: getMediumStyle(color: ColorManager.black, fontSize: 18),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Please note that due dates are estimates and can vary for each individual. Factors such as menstrual cycle length, ovulation, and other medical considerations can influence the actual delivery date. Consult with a healthcare professional for personalized guidance.',
                            style: getRegularStyle(color: ColorManager.black, fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),



              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to calculate EDD range
  String calculateEDDRange() {
    DateTime edd = DateFormat('MMMM dd, yyyy').parse(calculatedEDD!); // Parse calculated EDD
    DateTime eddMinus7 = edd.subtract(Duration(days: 7)); // Subtract 7 days
    DateTime eddPlus7 = edd.add(Duration(days: 7)); // Add 7 days

    return DateFormat('MMMM dd, yyyy').format(eddMinus7) + ' to ' + DateFormat('MMMM dd, yyyy').format(eddPlus7);
  }

  String calculateNepEDDRange() {
    NepaliDateTime edd = NepRange ?? NepaliDateTime.now(); // Parse calculated EDD
    NepaliDateTime eddMinus7 = edd.subtract(Duration(days: 7)); // Subtract 7 days
    NepaliDateTime eddPlus7 = edd.add(Duration(days: 7)); // Add 7 days

    return NepaliDateFormat('MMMM dd, yyyy').format(eddMinus7) + ' to ' + NepaliDateFormat('MMMM dd, yyyy').format(eddPlus7);
  }
}
