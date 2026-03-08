import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/global_controller/page_controller.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:pamirnet/widgets/authtextfield.dart';
import 'package:pamirnet/widgets/button_one.dart';

import '../controllers/change_balance_controller.dart';
import '../global_controller/font_controller.dart';

class ChangeBalance extends StatefulWidget {
  String? subID;
  ChangeBalance({super.key, this.subID});

  @override
  State<ChangeBalance> createState() => _ChangeBalanceState();
}

class _ChangeBalanceState extends State<ChangeBalance> {
  int _value = 1;

  final Mypagecontroller mypagecontroller = Get.find();
  final BalanceController balanceController = Get.put(BalanceController());
  final box = GetStorage();

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    balanceController.status.value = "credit";
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
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
                  Obx(
                    () => Text(
                      languagesController.tr("CHANGE_BALANCE"),
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
              RadioListTile(
                value: 1,
                groupValue: _value,
                activeColor: Colors.green,
                onChanged: (val) {
                  balanceController.status.value = "credit";
                  setState(() {
                    _value = val!;
                  });
                },
                title: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: AppColors.primaryColor.withOpacity(0.20),
                          ),
                          color: _value == 1 ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Obx(
                                () => Text(
                                  languagesController.tr("CREDIT"),
                                  style: TextStyle(
                                    color: _value == 1
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        box.read("language").toString() == "Fa"
                                        ? Get.find<FontController>().currentFont
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              RadioListTile(
                value: 2,
                groupValue: _value,
                activeColor: Colors.green,
                onChanged: (val) {
                  balanceController.status.value = "debit";
                  setState(() {
                    _value = val!;
                  });
                },
                title: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: AppColors.primaryColor.withOpacity(0.20),
                          ),
                          color: _value == 2 ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Obx(
                                () => Text(
                                  languagesController.tr("DEBIT"),
                                  style: TextStyle(
                                    color: _value == 2
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        box.read("language").toString() == "Fa"
                                        ? Get.find<FontController>().currentFont
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Obx(
                    () => Text(
                      languagesController.tr("AMOUNT"),
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
              SizedBox(height: 12),
              Container(
                height: 50,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Obx(
                        () => Authtextfield(
                          hinttext: languagesController.tr("ENTER_AMOUNT"),
                          controller: balanceController.amountController,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Image.asset(
                              //   "assets/icons/afghanistan.png",
                              //   height: 30,
                              // ),
                              Text(
                                box.read("currency_code"),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontFamily:
                                      box.read("language").toString() == "Fa"
                                      ? Get.find<FontController>().currentFont
                                      : null,
                                ),
                              ),
                              // Icon(
                              //   FontAwesomeIcons.chevronDown,
                              //   color: Colors.grey.shade600,
                              //   size: screenHeight * 0.020,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Obx(
                () => DefaultButton(
                  buttonName: balanceController.isLoading.value == false
                      ? languagesController.tr("CONFIRMATION")
                      : languagesController.tr("PLEASE_WAIT"),
                  mycolor: AppColors.primaryColor,
                  onpressed: () {
                    if (balanceController.amountController.text.isEmpty ||
                        balanceController.status.value == '') {
                      Fluttertoast.showToast(
                        msg: languagesController.tr("ENTER_AMOUNT"),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      if (balanceController.status.value == "credit") {
                        balanceController.credit(widget.subID.toString());
                      } else {
                        balanceController.debit(widget.subID.toString());
                      }
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
  PasswordBox({super.key, this.hintText});

  String? hintText;

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
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              suffixIcon: Icon(Icons.visibility_off),
            ),
          ),
        ),
      ),
    );
  }
}
