import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/controllers/sub_reseller_password_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/global_controller/page_controller.dart';
import 'package:pamirnet/pages/network.dart';
import 'package:pamirnet/widgets/button_one.dart';

import '../global_controller/font_controller.dart';
import '../utils/colors.dart';

class SetPassword extends StatelessWidget {
  SetPassword({super.key, this.subID});

  String? subID;

  final SubresellerPassController passwordConttroller = Get.put(
    SubresellerPassController(),
  );

  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Transform.rotate(
                    angle: 0.785398, // 45 degrees in radians (π/4 or 0.785398)
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
                  GestureDetector(
                    onTap: () {
                      print(subID);
                    },
                    child: Obx(
                      () => Text(
                        languagesController.tr("SET_PASSWORD"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.022,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
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
                      languagesController.tr("NEW_PASSWORD"),
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
                () => PasswordBox(
                  hintText: languagesController.tr("ENTER_NEW_PASSWORD"),
                  controller: passwordConttroller.newpassController,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Obx(
                    () => Text(
                      languagesController.tr("CONFIRM_PASSWORD"),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: screenHeight * 0.020,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Obx(
                () => PasswordBox(
                  hintText: languagesController.tr("ENTER_CONFIRM_PASSWORD"),
                  controller: passwordConttroller.confirmpassController,
                ),
              ),
              SizedBox(height: 25),
              Obx(
                () => DefaultButton(
                  buttonName: passwordConttroller.isLoading.value == false
                      ? languagesController.tr("CONFIRMATION")
                      : languagesController.tr("PLEASE_WAIT"),
                  mycolor: Colors.green,
                  onpressed: () {
                    if (passwordConttroller.newpassController.text.isEmpty ||
                        passwordConttroller
                            .confirmpassController
                            .text
                            .isEmpty) {
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
                      passwordConttroller.change(subID);
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

class PasswordBox extends StatelessWidget {
  PasswordBox({super.key, this.hintText, this.controller});

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
              hintStyle: TextStyle(
                fontFamily: box.read("language").toString() == "Fa"
                    ? Get.find<FontController>().currentFont
                    : null,
              ),
              suffixIcon: Icon(Icons.visibility_off),
            ),
          ),
        ),
      ),
    );
  }
}
