//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:meroupachar/src/core/resources/color_manager.dart';
// import 'package:meroupachar/src/core/resources/style_manager.dart';
// import 'package:meroupachar/src/presentation/patient/health_tips/domain/model/health_tips_model.dart';
//
// import '../../../../core/resources/value_manager.dart';
//
// class TestTips extends StatelessWidget {
//   final HealthTipsModel tips;
//   TestTips(this.tips);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Container(
//           decoration: BoxDecoration(
//             color: ColorManager.primary,
//             borderRadius: BorderRadius.circular(5)
//           ),
//
//           width: 300,
//           padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 18.w),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Health Tip',style: getMediumStyle(color: ColorManager.white,fontSize: 24),),
//               Divider(
//                 color: ColorManager.white,
//               ),
//               h10,
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(5)
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 8.h),
//                 child:  Html(data: tips.description,style: {
//                   'body' : Style(
//                     color: ColorManager.black,
//                     fontSize: FontSize.large,
//
//                   )
//                 },)
//
//                 // Text(tips.description!,style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
//               ),
//               h20,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorManager.white
//                       ),
//                       onPressed: (){}, child: Text('OK',style: getMediumStyle(color: ColorManager.primary,fontSize: 16),)),
//                   Column(
//                     children: [
//                       Text('- John Doe',style: getMediumStyle(color: Colors.white,fontSize: 18),),
//                       h10,
//                       Text('2023-10-10',style: getMediumStyle(color: Colors.white,fontSize: 18),)
//                     ],
//                   ),
//                 ],
//               ),
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
