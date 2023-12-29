import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../common/snackbar.dart';
import '../domain/model/calories_model.dart';
import 'add_previous_days.dart';

class CaloriesAllRecords extends StatefulWidget {
  final UserInfoCalories user;

  CaloriesAllRecords({required this.user});

  @override
  State<CaloriesAllRecords> createState() => _CaloriesAllRecordsState();
}

class _CaloriesAllRecordsState extends State<CaloriesAllRecords> {
  late List<CaloriesTrackingModel> allData;
  late DateTime selectedMonth;

  late Box<CaloriesTrackingModel> caloriesInfoBox;
  late ValueListenable<Box<CaloriesTrackingModel>> caloriesInfoBoxListenable;

  @override
  void initState() {
    super.initState();

    selectedMonth = DateTime.now();
    caloriesInfoBox = Hive.box<CaloriesTrackingModel>('saved_userCalories_box');
    caloriesInfoBoxListenable = caloriesInfoBox.listenable();
    caloriesInfoBoxListenable.addListener(_onHiveBoxChanged);

    caloriesInfoBox.values.toList().sort((a, b) => a.date.compareTo(b.date));
    allData = _allData(caloriesInfoBox.values.toList());
    // Filter the data based on the selected month
    allData = _filterDataByMonth(allData, selectedMonth);
  }



  List<CaloriesTrackingModel> _allData(List<CaloriesTrackingModel> data) {
    List<CaloriesTrackingModel> expandedData = [];
    final newData = data;

    newData.sort((a, b) => a.date.compareTo(b.date));

    if (newData.isNotEmpty) {
      final firstDate = DateTime.parse(data.first.date);
      final lastDate = DateTime.parse(data.last.date);

      for (int i = 0; i <= lastDate.difference(firstDate).inDays; i++) {
        final currentDate = firstDate.add(Duration(days: i));
        final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

        final existingData = newData.firstWhere(
              (element) => element.date == formattedDate,
          orElse: () => CaloriesTrackingModel(
            id: 0,
            userId: widget.user.userId,
            date: formattedDate,
            totalCalories: 0,
            totalCaloriesIntake: 0,
            caloriesIntakeList: [],
            totalCaloriesBurned: 0,
            caloriesBurnedList: [],
          ),
        );

        expandedData.add(existingData);
      }
    }

    expandedData.sort((a, b) => b.date.compareTo(a.date));
    return expandedData;
  }

  List<CaloriesTrackingModel> _filterDataByMonth(
      List<CaloriesTrackingModel> data, DateTime selectedMonth) {
    return data
        .where((item) =>
    DateTime.parse(item.date).year == selectedMonth.year &&
        DateTime.parse(item.date).month == selectedMonth.month)
        .toList();
  }

  bool _hasDataForMonth(DateTime month) {
    return caloriesInfoBox.values.any((item) =>
    DateTime.parse(item.date).year == month.year &&
        DateTime.parse(item.date).month == month.month);
  }


  void _onHiveBoxChanged() {
    setState(() {
      allData = _allData(caloriesInfoBox.values.toList());
      // Filter the data based on the selected month
      allData = _filterDataByMonth(allData, selectedMonth);
    });
  }

  @override
  void dispose() {
    caloriesInfoBoxListenable.removeListener(_onHiveBoxChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessage = ScaffoldMessenger.of(context);
    return Scaffold(
      backgroundColor: ColorManager.white.withOpacity(0.9),
      appBar: AppBar(
        elevation: 3,
        backgroundColor: ColorManager.primary,
        title: Text('All Records'),
        titleTextStyle: getMediumStyle(color: ColorManager.white, fontSize: 20),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: FaIcon(
            Icons.chevron_left,
            color: ColorManager.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              h10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      DateTime previousMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month - 1,
                      );

                      // Check if there is data for the previous month
                      if (_hasDataForMonth(previousMonth)) {
                        setState(() {
                          selectedMonth = previousMonth;
                          // Update the list with the new selected month
                          allData = _allData(caloriesInfoBox.values.toList());
                          // Filter the data based on the selected month
                          allData = _filterDataByMonth(allData, selectedMonth);
                        });
                      }
                      else{
                        scaffoldMessage.showSnackBar(
                          SnackbarUtil.showFailureSnackbar(
                            message: 'No Previous records',
                            duration: const Duration(milliseconds: 1400),
                          ),
                        );
                      }
                    },
                    icon: FaIcon(CupertinoIcons.backward_fill, color:ColorManager.black,),
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(selectedMonth),
                    style: getMediumStyle(color: ColorManager.black),
                  ),
                  IconButton(
                    onPressed: () {
                      DateTime nextMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month + 1,
                      );

                      // Check if there is data for the next month
                      if (_hasDataForMonth(nextMonth)) {
                        setState(() {
                          selectedMonth = nextMonth;
                          // Update the list with the new selected month
                          allData = _allData(caloriesInfoBox.values.toList());
                          // Filter the data based on the selected month
                          allData = _filterDataByMonth(allData, selectedMonth);
                        });
                      }
                      else{
                        scaffoldMessage.showSnackBar(
                          SnackbarUtil.showFailureSnackbar(
                            message: 'No New records',
                            duration: const Duration(milliseconds: 1400),
                          ),
                        );
                      }
                    },
                    icon: FaIcon(CupertinoIcons.forward_fill, color: ColorManager.black,),
                  ),
                ],
              ),
              h20,
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allData.length,
                itemBuilder: (context, index) {
                  final item = allData[index];

                  if (item.id == 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: ListTile(
                        onTap: () => Get.to(() => PreviousCaloriesPage(data: item, user: widget.user,)),
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: ColorManager.black.withOpacity(0.5),
                          ),
                        ),
                        title: Text(item.date, style: getMediumStyle(color: ColorManager.black, fontSize: 20),),
                        subtitle: Text('Add calories'),
                        trailing: FaIcon(Icons.add),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: ListTile(
                        onTap: () => Get.to(() => PreviousCaloriesPage(data: item, user: widget.user,)),
                        tileColor: ColorManager.white,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: ColorManager.black.withOpacity(0.5),
                          ),
                        ),
                        trailing: FaIcon(Icons.chevron_right),
                        title: Text(item.date, style: getMediumStyle(color: ColorManager.black, fontSize: 20),),
                        subtitle: Row(
                          children: [
                            Text('Total Calories:'),
                            w10,
                            Text(
                              '${item.totalCalories}',
                              style: TextStyle(
                                color: item.totalCalories > widget.user.requiredCalories + 200
                                    ? ColorManager.red
                                    : item.totalCalories < widget.user.requiredCalories - 200
                                    ? ColorManager.orange
                                    : ColorManager.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              h100,
            ],
          ),
        ),
      ),
    );
  }
}
