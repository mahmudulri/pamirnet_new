import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pamirnet/controllers/dashboard_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/screens/change_pin.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:pamirnet/widgets/button_one.dart';

import '../global_controller/font_controller.dart';
import '../global_controller/page_controller.dart';
import '../helpers/price.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // File? _selectedImage;
  // Future<void> _pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  //   if (image != null) {
  //     setState(() {
  //       _selectedImage = File(image.path);
  //     });
  //   }
  // }

  final dashboardController = Get.find<DashboardController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();
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
          padding: EdgeInsets.all(12.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
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
                      languagesController.tr("PROFILE"),
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
              Center(
                child:
                    dashboardController
                            .alldashboardData
                            .value
                            .data!
                            .userInfo!
                            .profileImageUrl !=
                        null
                    ? Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              dashboardController
                                  .alldashboardData
                                  .value
                                  .data!
                                  .userInfo!
                                  .profileImageUrl
                                  .toString(),
                            ),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      )
                    : Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: GestureDetector(
                  onTap: () {
                    mypagecontroller.changePage(
                      ChangePinScreen(),
                      isMainPage: false,
                    );
                  },
                  child: Container(
                    height: screenHeight * 0.055,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Obx(
                        () => Text(
                          languagesController.tr("CHANGE_PIN"),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: screenHeight * 0.018,
                            fontFamily: box.read("language").toString() == "Fa"
                                ? Get.find<FontController>().currentFont
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Obx(
                () => Profilebox(
                  boxname: languagesController.tr("FULL_NAME"),
                  data: dashboardController
                      .alldashboardData
                      .value
                      .data!
                      .userInfo!
                      .resellerName
                      .toString(),
                ),
              ),
              SizedBox(height: 10),
              Obx(
                () => Profilebox(
                  boxname: languagesController.tr("EMAIL"),
                  data: dashboardController
                      .alldashboardData
                      .value
                      .data!
                      .userInfo!
                      .email
                      .toString(),
                ),
              ),
              SizedBox(height: 10),
              Obx(
                () => Profilebox(
                  boxname: languagesController.tr("PHONENUMBER"),
                  data: dashboardController
                      .alldashboardData
                      .value
                      .data!
                      .userInfo!
                      .phone
                      .toString(),
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // Profilebox(
              //   boxname: "Location",
              //   data: "IRAN, RAZAVIKHHORASAN, MASHHAD",
              // ),
              SizedBox(height: 10),
              Obx(
                () => BalanceBox(
                  boxname: languagesController.tr("BALANCE"),
                  data:
                      dashboardController
                          .alldashboardData
                          .value
                          .data!
                          .userInfo!
                          .balance
                          .toString() +
                      " " +
                      box.read("currency_code"),
                ),
              ),
              SizedBox(height: 10),
              Obx(
                () => BalanceBox(
                  boxname: languagesController.tr("LOAN_BALANCE"),
                  data:
                      dashboardController
                          .alldashboardData
                          .value
                          .data!
                          .userInfo!
                          .loanBalance
                          .toString() +
                      " " +
                      box.read("currency_code"),
                ),
              ),
              SizedBox(height: 10),
              Obx(
                () => BalanceBox(
                  boxname: languagesController.tr("TOTAL_SOLD_AMOUNT"),
                  data:
                      dashboardController
                          .alldashboardData
                          .value
                          .data!
                          .totalSoldAmount
                          .toString() +
                      " " +
                      box.read("currency_code"),
                ),
              ),
              SizedBox(height: 10),
              Obx(
                () => BalanceBox(
                  boxname: languagesController.tr("TOTAL_REVENUE"),
                  data: dashboardController
                      .alldashboardData
                      .value
                      .data!
                      .totalRevenue
                      .toString(),
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class Profilebox extends StatelessWidget {
  Profilebox({super.key, this.boxname, this.data});

  String? boxname;
  String? data;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.070,
      width: screenWidth,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(boxname.toString()),

            Text(
              data.toString(),
              style: TextStyle(
                fontSize: screenHeight * 0.0150,
                fontFamily: box.read("language").toString() == "Fa"
                    ? Get.find<FontController>().currentFont
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceBox extends StatelessWidget {
  BalanceBox({super.key, this.boxname, this.data});

  String? boxname;
  String? data;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.070,
      width: screenWidth,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(boxname.toString()),
            Spacer(),

            PriceTextView(
              price: data.toString(),
              textStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              "  " + box.read("currency_code"),
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
