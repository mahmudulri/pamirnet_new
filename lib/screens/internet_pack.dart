import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/controllers/bundle_controller.dart';
import 'package:pamirnet/controllers/country_list_controller.dart';
import 'package:pamirnet/controllers/service_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';

import '../global_controller/font_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import 'recharge_screen.dart';

class InternetPack extends StatelessWidget {
  InternetPack({super.key});

  LanguagesController languagesController = Get.put(LanguagesController());

  final countrylistController = Get.find<CountryListController>();
  final box = GetStorage();

  final serviceController = Get.find<ServiceController>();
  final bundleController = Get.find<BundleController>();
  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                      print(countrylistController.finalCountryList.toList());
                    },
                    child: Obx(
                      () => Text(
                        languagesController.tr("COUNTRY_SELECTION"),
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
              Expanded(
                child: Obx(
                  () => countrylistController.isLoading.value == false
                      ? GridView.builder(
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    2, // Number of columns in the grid
                                crossAxisSpacing:
                                    5.0, // Spacing between columns
                                mainAxisSpacing: 5.0, // Spacing between rows
                                childAspectRatio: 1.5,
                              ),
                          itemCount:
                              countrylistController.finalCountryList.length,
                          itemBuilder: (context, index) {
                            final data =
                                countrylistController.finalCountryList[index];
                            return GestureDetector(
                              onTap: () {
                                box.write("country_id", data["id"]);

                                box.write("countryName", data["country_name"]);

                                serviceController.reserveDigit.clear();
                                bundleController.finalList.clear();

                                box.write(
                                  "maxlength",
                                  data["phone_number_length"].toString(),
                                );

                                box.write("validity_type", "");
                                box.write("company_id", "");
                                box.write("search_tag", "");

                                // box.write("service_category_id",
                                //     data["categories"][index]["categoryId"]);

                                mypagecontroller.changePage(
                                  RechargeScreen(),
                                  isMainPage: false,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white.withOpacity(0.30),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: NetworkImage(
                                          data["country_flag_image_url"],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        data["country_name"],
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: screenHeight * 0.020,
                                          fontFamily:
                                              box.read("language").toString() ==
                                                  "Fa"
                                              ? Get.find<FontController>()
                                                    .currentFont
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
