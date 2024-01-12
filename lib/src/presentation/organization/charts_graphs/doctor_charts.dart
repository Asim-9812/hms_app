





import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';
import '../../../data/services/user_services.dart';
import '../../../dummy_datas/dummy_datas.dart';
import '../../login/domain/model/user.dart';
import '../doctor_statistics/presentation/all_doctors.dart';

class DoctorCharts extends StatefulWidget {
  const DoctorCharts({super.key});

  @override
  State<DoctorCharts> createState() => _DoctorChartsState();
}

class _DoctorChartsState extends State<DoctorCharts> {

  List<User> doctors = [];
  int filterType = 0 ;

  final List<Map<String, dynamic>> dummyDepartmentData = [
    {
      'department': 'Medicine',
      'totalEmployees': 42,
      'maleDoctors': 14,
      'femaleDoctors': 12,
      'otherDoctors': 2,
      'otherStaff': 14,
    },
    {
      'department': 'Surgery',
      'totalEmployees': 35,
      'maleDoctors': 20,
      'femaleDoctors': 6,
      'otherDoctors': 1,
      'otherStaff': 8,
    },
    {
      'department': 'Gynaecology',
      'totalEmployees': 28,
      'maleDoctors': 3,
      'femaleDoctors': 21,
      'otherDoctors': 0,
      'otherStaff': 4,
    },
    {
      'department': 'Obstetrics',
      'totalEmployees': 18,
      'maleDoctors': 1,
      'femaleDoctors': 16,
      'otherDoctors': 0,
      'otherStaff': 1,
    },
    {
      'department': 'Paediatrics',
      'totalEmployees': 30,
      'maleDoctors': 10,
      'femaleDoctors': 15,
      'otherDoctors': 1,
      'otherStaff': 4,
    },
    {
      'department': 'Radiology',
      'totalEmployees': 15,
      'maleDoctors': 7,
      'femaleDoctors': 5,
      'otherDoctors': 0,
      'otherStaff': 3,
    },
    // Add more departments with their respective data...
  ];



  @override
  void initState() {
    super.initState();
    _getDoctorsList();
    _calculateGenderCounts();
  }

  void _getDoctorsList() async {
    final List<User> doctorList = await UserService().getDoctors();
    setState(() {
      doctors = doctorList;
    });
  }


  Map<String, int> _calculateGenderCounts() {
    Map<String, int> genderCounts = {
      'Male': 0,
      'Female': 0,
      'Others': 0,
    };

    for (var data in doctors) {
      final gender = data.genderID;
      if (gender == 1) {
        genderCounts['Male'] = (genderCounts['Male'] ?? 0) + 1;
      } else if (gender == 2) {
        genderCounts['Female'] = (genderCounts['Female'] ?? 0) + 1;
      } else {
        genderCounts['Others'] = (genderCounts['Others'] ?? 0) + 1;
      }
    }

    return genderCounts;
  }

  @override
  Widget build(BuildContext context) {

    Map<String, int> genderCounts = _calculateGenderCounts();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            children: [
              h10,
              Expanded(
                child: InkWell(
                  onTap: (){
                    setState(() {
                      filterType = 0;
                    });
                  },
                  child: Container(
                    padding:  EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                    decoration: BoxDecoration(
                      color: filterType == 0?ColorManager.primary.withOpacity(0.7) : ColorManager.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ColorManager.black.withOpacity(0.5)
                      )
                    ),
                    child: Text('By Gender',style: getRegularStyle(color:filterType == 0? ColorManager.white : ColorManager.black,fontSize: 18),),
                  ),
                ),
              ),
              w10,
              Expanded(
                child: InkWell(
                  onTap: (){
                    setState(() {
                      filterType = 1;
                    });
                  },
                  child: Container(
                    padding:  EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                    decoration: BoxDecoration(
                        color: filterType == 1?ColorManager.primary.withOpacity(0.7) : ColorManager.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ColorManager.black.withOpacity(0.5)
                      )
                    ),
                    child: Text('By Department',style: getRegularStyle(color: filterType == 1?ColorManager.white : ColorManager.black,fontSize: 18),),
                  ),
                ),
              )
            ],
          ),
        ),
        h20,
        h20,
        filterType == 0
            ? SfCartesianChart(

          primaryXAxis: CategoryAxis(),
          series: <ChartSeries>[
            ColumnSeries<String, String>(
              dataSource: genderCounts.keys.toList(),
              xValueMapper: (String gender, _) => gender,
              yValueMapper: (String gender, _) => genderCounts[gender]!,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              pointColorMapper: (String gender, _) {
                if (gender == 'Male') {
                  return ColorManager.primary.withOpacity(0.7);
                } else if (gender == 'Female') {
                  return ColorManager.premiumContainer.withOpacity(0.7);
                } else {
                  return ColorManager.red.withOpacity(0.5);
                }
              },
            ),
          ],
        )
        :SfCartesianChart(


          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            isResponsive: true,
            orientation: LegendItemOrientation.horizontal,
            overflowMode: LegendItemOverflowMode.wrap,

          ),
          primaryXAxis: CategoryAxis(
              isVisible: true
          ),
          series: _getChartSeries(),
        ),
        h20,
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary.withOpacity(0.7)
            ),
            onPressed: ()=>Get.to(()=>DoctorsList()),
            child: Text('View full information',style: getRegularStyle(color: ColorManager.white,fontSize: 16),)
        )
      ],
    );
  }

  List<StackedColumnSeries<Map<String, dynamic>, String>> _getChartSeries() {
    return <StackedColumnSeries<Map<String, dynamic>, String>>[
      StackedColumnSeries<Map<String, dynamic>, String>(

        dataSource: dummyDepartmentData,
        xValueMapper: (Map<String, dynamic> data, _) => data['department'],
        yValueMapper: (Map<String, dynamic> data, _) => data['maleDoctors'],
        name: 'Male Doctors',
      ),
      StackedColumnSeries<Map<String, dynamic>, String>(
        dataSource: dummyDepartmentData,
        xValueMapper: (Map<String, dynamic> data, _) => data['department'],
        yValueMapper: (Map<String, dynamic> data, _) => data['femaleDoctors'],
        name: 'Female Doctors',
      ),
      StackedColumnSeries<Map<String, dynamic>, String>(
        dataSource: dummyDepartmentData,
        xValueMapper: (Map<String, dynamic> data, _) => data['department'],
        yValueMapper: (Map<String, dynamic> data, _) => data['otherDoctors'],
        name: 'Other Doctors',
      ),
      StackedColumnSeries<Map<String, dynamic>, String>(
        dataSource: dummyDepartmentData,
        xValueMapper: (Map<String, dynamic> data, _) => data['department'],
        yValueMapper: (Map<String, dynamic> data, _) => data['otherStaff'],
        name: 'Other Staff',
      ),
    ];
  }
}

