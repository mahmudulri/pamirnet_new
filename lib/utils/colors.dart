import 'package:flutter/material.dart';

class AppColors {
  // static const primaryColor = Color(0xffA433FF);
  static const primaryColor = Color(0xff036266);

  static const secondaryColor = Color(0xffEEF4FF);
  static const listbuilderboxColor = Color(0xffEFEFEF);

  static LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xffFFFFFF), AppColors.primaryColor.withOpacity(0.20)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
