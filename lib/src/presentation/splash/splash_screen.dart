

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/presentation/login/presentation/status_page.dart';

import 'package:page_transition/page_transition.dart';

import '../../core/resources/color_manager.dart';
import '../login/domain/model/user.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  int accountId = 0;
  @override
  Widget build(BuildContext context) {

    final userBox = Hive.box<User>('session').values.toList();
    if(userBox.isEmpty){
      
      setState(() {
        accountId = 0;
      });
    }
    else{

      setState(() {
        accountId = userBox[0].typeID!;
      });
    }
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        )
    );

    return AnimatedSplashScreen(
      backgroundColor: ColorManager.white,
      splash: 'assets/images/logo001.png',
      nextScreen: StatusPage(accountId:accountId),
      splashIconSize: 360.h,
      centered: true,
      curve: Curves.easeInOut,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      duration: 2000,

    );
  }
}
