import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/bundle_controller.dart';
import '../controllers/country_list_controller.dart';
import '../controllers/service_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import 'recharge_screen.dart';

class InternetPack extends StatefulWidget {
  InternetPack({super.key});

  @override
  State<InternetPack> createState() => _InternetPackState();
}

class _InternetPackState extends State<InternetPack> {
  CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  BundleController bundleController = Get.put(BundleController());

  ServiceController serviceController = Get.put(ServiceController());

  final box = GetStorage();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final Mypagecontroller mypagecontroller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 450,
      width: screenWidth,
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            width: screenWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 6,
                  blurRadius: 6,
                  offset: Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(
              () => countrylistController.isLoading.value == false
                  ? Column(
                      children: [
                        GridView.builder(
                          padding: EdgeInsets.all(8),
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 1.0,
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
                                  data["phone_number_length"],
                                );
                                box.write("validity_type", "");
                                box.write("company_id", "");
                                box.write("search_tag", "");
                                mypagecontroller.changePage(
                                  RechargeScreen(),
                                  isMainPage: false,
                                );
                                Navigator.pop(context);
                              },
                              child: InnerShadow(
                                shadows: [
                                  Shadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 5,
                                    offset: const Offset(
                                      3,
                                      0,
                                    ), // push inward from right
                                  ),
                                  // Top side shadow
                                  Shadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 5,
                                    offset: const Offset(
                                      0,
                                      -3,
                                    ), // push inward from top
                                  ),
                                ],
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
