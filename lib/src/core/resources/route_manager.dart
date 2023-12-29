import 'package:flutter/material.dart';
import 'package:meroupachar/src/core/resources/string_manager.dart';

import '../../presentation/splash/splash_screen.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onBoarding";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String changePasswordRoute = "/forgot_password";
  static const String mainRoute = "/dashboard";
  static const String storeDetailsRoute = "/detail";
  static const String notificationPage = "/notification-page";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      // case Routes.loginRoute:
      //   return MaterialPageRoute(builder: (_) => const UserLoginView());
      // // case Routes.onBoardingRoute:
      // //   return MaterialPageRoute(builder: (_) => OnBoardingView());
      // case Routes.registerRoute:
      //   return MaterialPageRoute(builder: (_) => const UserSignUpView());
      // case Routes.changePasswordRoute:
      //   return MaterialPageRoute(builder: (_) => const ChangePasswordView());
      // case Routes.mainRoute:
      //   return MaterialPageRoute(builder: (_) => const MainView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
