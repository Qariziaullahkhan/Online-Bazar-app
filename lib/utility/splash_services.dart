import 'dart:async';

import 'package:ahsan_online_bazar/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const DashboardScreen()));
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      //   const DashboardScreen();
      // }));
    });
  }
}
