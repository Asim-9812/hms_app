
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';

import '../core/resources/route_manager.dart';
import '../presentation/notification_controller/notification_controller.dart';


final GlobalKey<ScaffoldMessengerState> snackBarKey =
GlobalKey<ScaffoldMessengerState>();


class MyApp extends StatefulWidget {
  MyApp._internal(); // private named constructor
  int appState = 0;
  static final MyApp instance =
      MyApp._internal(); // single instance -- singleton

  factory MyApp() => instance; // factory for the class instance

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {


  @override
  void initState() {
    NotificationController.startListeningNotificationEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(500, 1000),
      builder: (context, child) {
        return KhaltiScope(
          publicKey: 'test_public_key_d5355c28fd984efabb516a5b832a769e',
          // publicKey: 'live_public_key_ceead578475246fc83a9040d00610f93',
          enabledDebugging: true,


          builder: (context,navKey) {
            return GetMaterialApp(
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: ColorManager.primary)
              ),
              scaffoldMessengerKey: snackBarKey,
              supportedLocales:const [
                Locale('en', 'US'),
                Locale('ne', 'NP'),
              ] ,
              navigatorKey: navKey,
              localizationsDelegates: const [
                KhaltiLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              onGenerateRoute: RouteGenerator.getRoute,
              initialRoute: Routes.splashRoute,
            );
          }
        );
      },
    );
  }
}
