import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../global_controller/font_controller.dart';

class Authtextfield extends StatelessWidget {
  Authtextfield({
    required this.hinttext,
    this.controller,
    super.key,
  });

  String hinttext;
  TextEditingController? controller;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // height: screenHeight * 0.065,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
          color: Colors.grey.shade300,
        ),
        color: Color(0xffF9FAFB),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 4,
          bottom: 4,
        ),
        child: TextField(
          style: TextStyle(
            fontSize: 18,
            fontFamily: box.read("language").toString() == "Fa"
                ? Get.find<FontController>().currentFont
                : null,
          ),
          keyboardType: hinttext.toString() == "Enter amount"
              ? TextInputType.phone
              : TextInputType.name,
          inputFormatters: hinttext == "Enter amount"
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ]
              : [],
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: hinttext.toString() == "Password"
                ? Icon(Icons.visibility_off)
                : null,
            border: InputBorder.none,
            hintText: hinttext,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: screenHeight * 0.020,
              fontFamily: box.read("language").toString() == "Fa"
                  ? Get.find<FontController>().currentFont
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
