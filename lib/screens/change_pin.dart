import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/controllers/change_pin_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/utils/colors.dart' show AppColors;
import 'package:pamirnet/widgets/button_one.dart';

import '../global_controller/font_controller.dart';
import 'change_balance.dart';

class ChangePinScreen extends StatelessWidget {
  ChangePinScreen({super.key});

  final ChangePinController changePinController = Get.put(
    ChangePinController(),
  );

  LanguagesController languagesController = Get.put(LanguagesController());

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Row(
                children: [
                  Transform.rotate(
                    angle: 0.785398,
                    child: Container(
                      height: 7,
                      width: 7,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Expanded(
                    child: Container(height: 1, color: Colors.grey.shade300),
                  ),
                  SizedBox(width: 8),
                  Obx(
                    () => Text(
                      languagesController.tr("CHANGE_PIN"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.022,
                        fontFamily: box.read("language").toString() == "Fa"
                            ? Get.find<FontController>().currentFont
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(height: 2, color: Colors.grey.shade300),
                  ),
                  Transform.rotate(
                    angle: 0.785398, // 45 degrees in radians (π/4 or 0.785398)
                    child: Container(
                      height: 7,
                      width: 7,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Obx(
                    () => Text(
                      languagesController.tr("OLD_PIN"),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: screenHeight * 0.020,
                        fontFamily: box.read("language").toString() == "Fa"
                            ? Get.find<FontController>().currentFont
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Obx(
                () => ChangePinBox(
                  hintText: languagesController.tr("ENTER_OLD_PIN"),
                  controller: changePinController.oldPinController,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Obx(
                    () => Text(
                      languagesController.tr("NEW_PIN"),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: screenHeight * 0.020,
                        fontFamily: box.read("language").toString() == "Fa"
                            ? Get.find<FontController>().currentFont
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Obx(
                () => ChangePinBox(
                  hintText: languagesController.tr("ENTER_NEW_PIN"),
                  controller: changePinController.newPinController,
                ),
              ),
              SizedBox(height: 25),
              Obx(
                () => DefaultButton(
                  buttonName: changePinController.isLoading.value == false
                      ? languagesController.tr("CHANGE_NOW")
                      : languagesController.tr("PLEASE_WAIT"),
                  mycolor: Colors.green,
                  onpressed: () {
                    if (changePinController.oldPinController.text.isEmpty ||
                        changePinController.newPinController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Fill the data",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      changePinController.change();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePinBox extends StatelessWidget {
  ChangePinBox({super.key, this.hintText, this.controller});

  String? hintText;
  TextEditingController? controller;

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.070,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              suffixIcon: Icon(Icons.visibility_off),
              hintStyle: TextStyle(
                fontFamily: box.read("language").toString() == "Fa"
                    ? Get.find<FontController>().currentFont
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
