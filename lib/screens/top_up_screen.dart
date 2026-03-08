import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/utils/colors.dart';

import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../widgets/payment_button.dart';
import 'loan_screen.dart';
import 'receipts_screen.dart';

class TopUpScreen extends StatelessWidget {
  TopUpScreen({super.key});

  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();

  final Mypagecontroller mypagecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 12),
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
                      languagesController.tr("TOP_UP"),
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
                    angle: 0.785398,
                    child: Container(
                      height: 7,
                      width: 7,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              SizedBox(height: 10),
              TopUpButton(
                btnName: languagesController.tr("PAYMENT_RECEIPT_REQUEST"),
                icon: Icons.receipt_long,
                onpressed: () {
                  mypagecontroller.changePage(
                    ReceiptsScreen(),
                    isMainPage: false,
                  );
                },
              ),
              SizedBox(height: 10),
              TopUpButton(
                btnName: languagesController.tr(
                  "INCREASE_BALANCE_VIA_PAYMENT_GATEWAY",
                ),
                icon: Icons.payment,
                onpressed: () {
                  // mypagecontroller.changePage(
                  //   ReceiptsScreen(),
                  //   isMainPage: false,
                  // );
                },
              ),
              SizedBox(height: 10),
              TopUpButton(
                btnName: languagesController.tr(
                  "INCREASE_BALANCE_VIA_WHATSAPP",
                ),
                icon: Icons.chat,
                onpressed: () {
                  // mypagecontroller.changePage(
                  //   ReceiptsScreen(),
                  //   isMainPage: false,
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopUpButton extends StatefulWidget {
  TopUpButton({super.key, this.btnName, this.onpressed, this.icon});

  final String? btnName;
  final VoidCallback? onpressed;
  final IconData? icon;

  @override
  State<TopUpButton> createState() => _TopUpButtonState();
}

class _TopUpButtonState extends State<TopUpButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onpressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        height: 65,
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isPressed
                ? [
                    AppColors.secondaryColor.withOpacity(0.8),
                    AppColors.secondaryColor.withOpacity(0.9),
                  ]
                : [
                    AppColors.secondaryColor,
                    AppColors.secondaryColor.withOpacity(0.95),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(-2, -2),
                  ),
                ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              if (widget.icon != null)
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
              if (widget.icon != null) SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.btnName.toString(),

                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryColor.withOpacity(0.7),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
