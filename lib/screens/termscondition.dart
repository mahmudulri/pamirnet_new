import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';

import '../utils/colors.dart';

class Termscondition extends StatelessWidget {
  Termscondition({super.key});

  LanguagesController languagesController = Get.put(LanguagesController());

  String longtext =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                      languagesController.tr("TERMS_AND_CONDITIONS"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.022,
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
              SizedBox(height: 40),
              Image.asset("assets/icons/privacypolicy.png", height: 120),
              SizedBox(height: 20),
              Text(longtext, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }
}
