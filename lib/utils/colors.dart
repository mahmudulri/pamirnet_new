import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xff036266);
  static const primaryColor2 = Color.fromARGB(255, 22, 34, 34);
  static const greenColor = Colors.green;
  static const fontColor = Colors.black;
  static const primarycolor2 = Color.fromARGB(255, 22, 34, 34);

  static const secondaryColor = Color(0xffEEF4FF);
  static const listbuilderboxColor = Color(0xffEFEFEF);

  static LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xffFFFFFF), AppColors.primaryColor.withOpacity(0.20)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
