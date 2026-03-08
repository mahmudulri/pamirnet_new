import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../global_controller/font_controller.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton({
    super.key,
    this.buttonName,
    this.mycolor,
    this.onpressed,
  });
  final box = GetStorage();
  String? buttonName;
  Color? mycolor;
  VoidCallback? onpressed;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        height: screenHeight * 0.065,
        width: screenWidth,
        decoration: BoxDecoration(
          color: mycolor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            buttonName.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
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
