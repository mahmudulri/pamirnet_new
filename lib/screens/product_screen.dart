import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/bundle_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/country_list_controller.dart';
import '../controllers/service_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../services/service_screen.dart';
import '../utils/colors.dart';
import '../widgets/button_one.dart';
import 'country_selection.dart';
import 'recharge_screen.dart';
import 'social_bundles.dart';

class NewServiceScreen extends StatelessWidget {
  NewServiceScreen({super.key});

  // final categorisListController = Get.find<CategorisListController>();

  CategorisListController categorisListController = Get.put(
    CategorisListController(),
  );

  final box = GetStorage();
  List mycolor = [
    Color(0xffF4EBFC),
    Color(0xffEAFBFB),
    Color(0xffE9F2ED),
    Color(0xffFBF5F1),
    Color(0xffEAFBFB),
    Color(0xffF7FBEF),
  ];

  final List<String> icons = [
    "assets/icons/sim.png",
    "assets/icons/social-bundles.png",
    "assets/icons/dataplan.png",
    "assets/icons/credit-transfer.png",
    "assets/icons/callsmsplan.png",
  ];

  // final countryListController = Get.find<CountryListController>();
  final bundleController = Get.find<BundleController>();

  final serviceController = Get.find<ServiceController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Color(0xffEFF3F4),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        height: screenHeight,
        width: screenWidth,
        child: Obx(
          () => categorisListController.isLoading.value == false
              ? GridView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 7,
                    mainAxisSpacing: 7,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: categorisListController
                      .allcategorieslist
                      .value
                      .data!
                      .servicecategories!
                      .length,
                  itemBuilder: (context, index) {
                    final data = categorisListController
                        .allcategorieslist
                        .value
                        .data!
                        .servicecategories![index];

                    final color = mycolor[index % mycolor.length];
                    final icon = icons[index % icons.length];

                    return GestureDetector(
                      onTap: () {
                        box.write("service_category_id", data.id);

                        if (data.type.toString() == "nonsocial") {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(content: InternetPack());
                            },
                          );
                        } else {
                          box.write("validity_type", "");
                          box.write("search_tag", "");
                          box.write("service_category_id", data.id);
                          box.write("country_id", "");
                          box.write("company_id", "");

                          showDialog(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.all(20),
                                child: ServiceScreen(),
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              data.categoryName.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w800,
                                fontSize: screenHeight * 0.015,
                                fontFamily:
                                    box.read("language").toString() == "Fa"
                                    ? Get.find<FontController>().currentFont
                                    : null,
                              ),
                            ),
                            data.categoryImageUrl.toString() == "null"
                                ? Image.asset(icon, height: 50)
                                : Image.network(
                                    data.categoryImageUrl.toString(),
                                    height: 50,
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
