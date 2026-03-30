import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/bundle_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/categories_list_controller.dart';
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

class NewServiceScreen extends StatefulWidget {
  NewServiceScreen({super.key});

  @override
  State<NewServiceScreen> createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends State<NewServiceScreen> {
  // final categorisListController = Get.find<CategorisListController>();
  NewCategorisListController categorisListController = Get.put(
    NewCategorisListController(),
  );

  final box = GetStorage();

  @override
  void initState() {
    super.initState();

    categorisListController.nonsocialArray.clear();
    categorisListController.fetchcategories();
    serviceController.fetchservices();
  }

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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Obx(
                () => categorisListController.isLoading.value == false
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 3.0,
                          mainAxisSpacing: 3.0,
                          childAspectRatio: 0.9,
                        ),
                        itemCount:
                            categorisListController.nonsocialArray.length,
                        itemBuilder: (context, index) {
                          final data =
                              categorisListController.nonsocialArray[index];
                          return GestureDetector(
                            onTap: () {
                              serviceController.reserveDigit.clear();
                              bundleController.finalList.clear();

                              box.write("maxlength", data["phoneNumberLength"]);

                              box.write("validity_type", "");
                              box.write("company_id", "");
                              box.write("search_tag", "");
                              box.write("country_id", data["countryId"]);

                              box.write(
                                "service_category_id",
                                data["categoryId"],
                              );
                              bundleController.initialpage = 1;

                              mypagecontroller.changePage(
                                RechargeScreen(),
                                isMainPage: false,
                              );
                            },
                            child: Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                            data["countryImage"],
                                          ),
                                    ),
                                    Text(
                                      data["categoryName"],
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: SizedBox(),
                        ),
                      ),
              ),

              // Display Social Service Categories without Country
              Obx(
                () => categorisListController.isLoading.value == false
                    ? Column(
                        children: categorisListController
                            .allcategorieslist
                            .value!
                            .data!
                            .servicecategories!
                            .where((category) => category.type == "social")
                            .map((category) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.categoryName.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 3.0,
                                          mainAxisSpacing: 3.0,
                                          childAspectRatio: 0.9,
                                        ),
                                    itemCount: category.services?.length ?? 0,
                                    itemBuilder: (context, serviceIndex) {
                                      final service =
                                          category.services![serviceIndex];
                                      return GestureDetector(
                                        onTap: () {
                                          bundleController.finalList.clear();
                                          box.write("validity_type", "");
                                          box.write(
                                            "company_id",
                                            service.companyId.toString(),
                                          );
                                          box.write("search_tag", "");
                                          box.write(
                                            "country_id",
                                            service.company!.countryId
                                                .toString(),
                                          );
                                          box.write(
                                            "service_category_id",
                                            category.id.toString(),
                                          );
                                          bundleController.initialpage = 1;

                                          mypagecontroller.changePage(
                                            SocialBundles(),
                                            isMainPage: false,
                                          );
                                        },
                                        child: Card(
                                          color: Colors.white,
                                          child: Container(
                                            width: 152,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 0),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                          service
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    service.company!.companyName
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              );
                            })
                            .toList(),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
