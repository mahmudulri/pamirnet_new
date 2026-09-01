import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../global_controller/languages_controller.dart';

class KText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;

  KText({
    Key? key,
    required this.text,
    this.fontSize = 16,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.fontFamily,
    this.textAlign,
  }) : super(key: key);
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Colors.black,
        fontWeight: fontWeight,
      ),
    );
  }
}

// number format

class NText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  NText({
    Key? key,
    required this.text,
    this.fontSize = 16,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Text(
        languagesController.number(text),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          fontSize: fontSize,
          color: color ?? Colors.black,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
}
