import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/bundle_controller.dart';
import '../controllers/categories_list_controller.dart';
import '../controllers/service_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import 'recharge_screen.dart';
import 'social_bundles.dart';

class NewServiceScreen extends StatefulWidget {
  NewServiceScreen({super.key});

  @override
  State<NewServiceScreen> createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends State<NewServiceScreen> {
  NewCategorisListController categorisListController = Get.put(
    NewCategorisListController(),
  );

  final box = GetStorage();

  final bundleController = Get.find<BundleController>();

  final serviceController = Get.find<ServiceController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();

  @override
  void initState() {
    super.initState();

    box.write("country_id", "");
    box.write("service_category_id", "");

    // First time only fetch categories if no data exists
    if (categorisListController.nonsocialArray.isEmpty) {
      categorisListController.fetchcategories();
    }

    // First time only fetch services if no data exists
    if (serviceController.allserviceslist.value.data?.services?.isEmpty ??
        true) {
      serviceController.fetchservices();
    }
  }

  // =========================
  // SWIPE REFRESH
  // =========================
  Future<void> _refreshData() async {
    // Clear old category data before getting fresh data
    categorisListController.nonsocialArray.clear();

    // Fetch fresh categories
    categorisListController.fetchcategories();

    // Fetch fresh services
    serviceController.fetchservices();

    // Wait until both API requests finish
    while (categorisListController.isLoading.value ||
        serviceController.isLoading.value) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (mounted) {
      setState(() {});
    }
  }

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
          padding: const EdgeInsets.all(12),

          // =========================
          // SWIPE REFRESH ADDED
          // =========================
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              children: [
                Obx(
                  () => categorisListController.isLoading.value == false
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                print(
                                  'enable_operator_lookup: ${data["enable_operator_lookup"]}',
                                );

                                print('Category Name: ${data["categoryName"]}');

                                serviceController.reserveDigit.clear();

                                bundleController.finalList.clear();

                                box.write(
                                  "maxlength",
                                  data["phoneNumberLength"],
                                );

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
                                  RechargeScreen(
                                    catName: data["categoryName"],
                                    enableOperatorLookup:
                                        data["enable_operator_lookup"] ?? false,
                                  ),
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
                                        offset: const Offset(0, 0),
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
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.all(50.0),
                            child: SizedBox(),
                          ),
                        ),
                ),

                // =====================================
                // SOCIAL SERVICE CATEGORIES
                // =====================================
                Obx(
                  () => categorisListController.isLoading.value == false
                      ? Column(
                          children: categorisListController
                              .allcategorieslist
                              .value
                              .data!
                              .servicecategories!
                              .where((category) => category.type == "social")
                              .map((category) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category.categoryName.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),

                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                                    offset: const Offset(0, 0),
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
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      service
                                                          .company!
                                                          .companyName
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
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
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.transparent,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
