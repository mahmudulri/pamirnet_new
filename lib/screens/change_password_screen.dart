import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import '../controllers/change_password_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../pages/homepages.dart';
import '../utils/colors.dart';
import '../widgets/button_one.dart';
import '../widgets/ktext.dart';
import 'change_balance.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordController changePasswordController = Get.put(
    ChangePasswordController(),
  );

  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff011A52), // Status bar background color
        statusBarIconBrightness: Brightness.light, // For Android
        statusBarBrightness: Brightness.light, // For iOS
      ),
    );
  }

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
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
                      languagesController.tr("CHANGE_PASSWORD"),
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
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => KText(
                            text: languagesController.tr("CURRENT_PASSWORD"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ChangePinBox(
                      // hintText:
                      //     languagesController.tr("ENTER_CURRENT_PASSWORD"),
                      controller:
                          changePasswordController.currentpassController,
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Obx(
                          () => KText(
                            text: languagesController.tr("NEW_PASSWORD"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ChangePinBox(
                      // hintText:
                      //     languagesController.tr("ENTER_NEW_PASSWORD"),
                      controller: changePasswordController.newpassController,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Obx(
                          () => KText(
                            text: languagesController.tr(
                              "CONFIRM_NEW_PASSWORD",
                            ),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ChangePinBox(
                      // hintText:
                      //     languagesController.tr("CONFIRM_NEW_PASSWORD"),
                      controller:
                          changePasswordController.confirmpassController,
                    ),
                    SizedBox(height: 25),
                    Obx(
                      () => DefaultButton(
                        mycolor: Colors.green,
                        buttonName:
                            changePasswordController.isLoading.value == false
                            ? languagesController.tr("CHANGE_NOW")
                            : languagesController.tr("PLEASE_WAIT"),
                        onpressed: () {
                          if (changePasswordController
                                  .currentpassController
                                  .text
                                  .isEmpty ||
                              changePasswordController
                                  .newpassController
                                  .text
                                  .isEmpty ||
                              changePasswordController
                                  .confirmpassController
                                  .text
                                  .isEmpty) {
                            Fluttertoast.showToast(
                              msg: languagesController.tr(
                                "FILL_DATA_CORRECTLY",
                              ),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            changePasswordController.change();
                          }
                        },
                      ),
                    ),
                  ],
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
      height: screenHeight * 0.065,
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
              hintStyle: TextStyle(fontSize: 15),
              hintText: hintText,
              border: InputBorder.none,
              // suffixIcon: Icon(
              //   Icons.visibility_off,
              // ),
            ),
            style: TextStyle(
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
