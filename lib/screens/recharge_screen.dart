import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:pamirnet/controllers/bundle_controller.dart';
import 'package:pamirnet/controllers/confirm_pin_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/helpers/price.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pamirnet/widgets/number_textfield.dart';
import '../controllers/service_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/page_controller.dart';
import '../widgets/animated_card.dart';

class RechargeScreen extends StatefulWidget {
  RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());
  void initializeDuration() {
    duration = [
      {"Name": languagesController.tr("All"), "Value": ""},
      {"Name": languagesController.tr("UNLIMITED"), "Value": "unlimited"},
      {"Name": languagesController.tr("MONTHLY"), "Value": "monthly"},
      {"Name": languagesController.tr("WEEKLY"), "Value": "weekly"},
      {"Name": languagesController.tr("DAILY"), "Value": "daily"},
      {"Name": languagesController.tr("HOURLY"), "Value": "hourly"},
      {"Name": languagesController.tr("NIGHTLY"), "Value": "nightly"},
    ];
  }

  int selectedIndex = -1;
  int duration_selectedIndex = 0;

  List<Map<String, String>> duration = [];

  String search = "";
  String inputNumber = "";

  final box = GetStorage();

  final FocusNode _focusNode = FocusNode();

  final confirmPinController = Get.find<ConfirmPinController>();

  final ScrollController scrollController = ScrollController();

  final serviceController = Get.find<ServiceController>();
  final bundleController = Get.find<BundleController>();

  Future<void> refresh() async {
    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination.totalPages ??
        0;
    final int currentPage = bundleController.initialpage;

    // Prevent loading more pages if we've reached the last page
    if (currentPage >= totalPages) {
      print(
        "End..........................................End.....................",
      );
      return;
    }

    // Check if the scroll position is at the bottom
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      bundleController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (bundleController.initialpage <= totalPages) {
        print("Load More...................");
        bundleController.fetchallbundles();
      } else {
        bundleController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  void _onTextChanged() {
    if (!mounted) return;

    setState(() {
      inputNumber = confirmPinController.numberController.text;

      // Print debug information
      print("Input Number: $inputNumber");

      if (inputNumber.isEmpty) {
        box.write("company_id", "");
        bundleController.initialpage = 1;
        bundleController.finalList.clear();
        bundleController.fetchallbundles();
        // Handle case where text field is cleared
        print("Text field is empty. Showing all services.");

        // Clear the company_id from the box

        // Reset bundleController and fetch all bundles
      } else if (inputNumber.length == 3 || inputNumber.length == 4) {
        final services = serviceController.allserviceslist.value.data!.services;

        // Print number of services for debugging
        print("Number of services: ${services.length}");

        bool matchFound = false;

        for (var service in services) {
          for (var code in service.company!.companycodes!) {
            // Print reservedDigit for debugging
            print("Checking reservedDigit: ${code.reservedDigit}");

            if (code.reservedDigit == inputNumber) {
              box.write("company_id", service.companyId);
              bundleController.initialpage = 1;
              bundleController.finalList.clear();
              setState(() {
                bundleController.fetchallbundles();
              });

              print("Matched company_id: ${service.companyId}");
              matchFound = true;
              break; // Exit the inner loop
            }
          }
          if (matchFound) break; // Exit the outer loop
        }

        if (!matchFound) {
          print("No match found for input number: $inputNumber");
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    confirmPinController.numberController.clear();
    // bundleController.finalList.clear();
    bundleController.initialpage = 1;
    serviceController.fetchservices();
    bundleController.fetchallbundles();

    confirmPinController.numberController.addListener(_onTextChanged);
    initializeDuration();
    scrollController.addListener(refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    confirmPinController.numberController.removeListener(_onTextChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Transform.rotate(
                      angle:
                          0.785398, // 45 degrees in radians (π/4 or 0.785398)
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
                      () => GestureDetector(
                        onTap: () {
                          // print(box.read("country_id"));
                          bundleController.fetchallbundles();
                        },
                        child: Text(
                          languagesController
                              .tr("INTERNET_PACKAGE")
                              .toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * 0.020,
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
                      angle:
                          0.785398, // 45 degrees in radians (π/4 or 0.785398)
                      child: Container(
                        height: 7,
                        width: 7,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Obx(
                  () => CustomTextField(
                    confirmPinController: confirmPinController.numberController,
                    languageData: languagesController.tr("ENTER_PHONE_NUMBER"),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  color: Colors.transparent,
                  width: screenWidth,
                  child: Obx(() {
                    // Check if the allserviceslist is not null and contains data
                    final services =
                        serviceController
                            .allserviceslist
                            .value
                            .data
                            ?.services ??
                        [];

                    // Show all services if input is empty, otherwise filter
                    final filteredServices = inputNumber.isEmpty
                        ? services
                        : services.where((service) {
                            return service.company?.companycodes?.any((code) {
                                  final reservedDigit =
                                      code.reservedDigit ?? '';
                                  return inputNumber.startsWith(reservedDigit);
                                }) ??
                                false;
                          }).toList();

                    return serviceController.isLoading.value == false
                        ? Center(
                            child: ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return SizedBox(width: 5);
                              },
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredServices.length,
                              itemBuilder: (context, index) {
                                final data = filteredServices[index];

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      bundleController.initialpage = 1;
                                      bundleController.finalList.clear();
                                      selectedIndex = index;
                                      box.write("company_id", data.companyId);
                                      bundleController.fetchallbundles();
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: selectedIndex == index
                                          ? Color(0xff34495e)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 5,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            data.company?.companyLogo ?? '',
                                        placeholder: (context, url) {
                                          print('Loading image: $url');
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                        errorWidget: (context, url, error) {
                                          print(
                                            'Error loading image: $url, error: $error',
                                          );
                                          return Icon(Icons.error);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                              strokeWidth: 1.0,
                            ),
                          );
                  }),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: duration.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            duration_selectedIndex = index;
                            box.write(
                              "validity_type",
                              duration[index]["Value"],
                            );
                            bundleController.initialpage = 1;
                            bundleController.finalList.clear();
                            bundleController.fetchallbundles();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: duration_selectedIndex == index
                                  ? Colors.white.withOpacity(0.45)
                                  : Colors.white.withOpacity(0.45),
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: duration_selectedIndex == index
                                ? AppColors.primaryColor
                                : Colors.white.withOpacity(0.30),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              child: Text(
                                duration[index]["Name"]!,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: duration_selectedIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily:
                                      box.read("language").toString() == "Fa"
                                      ? Get.find<FontController>().currentFont
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Obx(
                  () => bundleController.isLoading.value == false
                      ? Container(
                          child: bundleController.finalList.isNotEmpty
                              ? SizedBox()
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/icons/empty.png",
                                        height: 80,
                                      ),
                                      Text("No Data found"),
                                    ],
                                  ),
                                ),
                        )
                      : SizedBox(),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white.withOpacity(0.30),
                      ),
                      color: Color(0xffCAE7F6).withOpacity(0.80),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Obx(
                        () =>
                            bundleController.isLoading.value == false &&
                                bundleController.finalList.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  itemCount: bundleController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        bundleController.finalList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (confirmPinController
                                            .numberController
                                            .text
                                            .isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: languagesController.tr(
                                              "ENTER_PHONE_NUMBER",
                                            ),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else {
                                          if (box.read("permission") == "no" ||
                                              confirmPinController
                                                      .numberController
                                                      .text
                                                      .length
                                                      .toString() !=
                                                  box
                                                      .read("maxlength")
                                                      .toString()) {
                                            Fluttertoast.showToast(
                                              msg: languagesController.tr(
                                                "ENTER_CORRECT_NUMBER",
                                              ),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            // Stop further execution if permission is "no"
                                          } else {
                                            box.write(
                                              "bundleID",
                                              data.id.toString(),
                                            );

                                            showDialog(
                                              context: context,
                                              barrierColor: Colors.black
                                                  .withOpacity(0.6),
                                              builder: (context) {
                                                return AnimatedConfirmDialog(
                                                  data: data,
                                                  confirmPinController:
                                                      confirmPinController,
                                                  languagesController:
                                                      languagesController,
                                                  box: box,
                                                  screenWidth: screenWidth,
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 10,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              // Company Logo
                                              Container(
                                                height: 56,
                                                width: 56,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                          data
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),

                                              // Bundle Info (Left side)
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      data.bundleTitle
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black87,
                                                        fontFamily:
                                                            box
                                                                    .read(
                                                                      "language",
                                                                    )
                                                                    .toString() ==
                                                                "Fa"
                                                            ? Get.find<
                                                                    FontController
                                                                  >()
                                                                  .currentFont
                                                            : null,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Obx(
                                                      () => Text(
                                                        data.validityType
                                                                    .toString() ==
                                                                "unlimited"
                                                            ? languagesController
                                                                  .tr(
                                                                    "UNLIMITED",
                                                                  )
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "monthly"
                                                            ? languagesController
                                                                  .tr("MONTHLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "weekly"
                                                            ? languagesController
                                                                  .tr("WEEKLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "daily"
                                                            ? languagesController
                                                                  .tr("DAILY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "hourly"
                                                            ? languagesController
                                                                  .tr("HOURLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "nightly"
                                                            ? languagesController
                                                                  .tr("NIGHTLY")
                                                            : "",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              box
                                                                      .read(
                                                                        "language",
                                                                      )
                                                                      .toString() ==
                                                                  "Fa"
                                                              ? Get.find<
                                                                      FontController
                                                                    >()
                                                                    .currentFont
                                                              : null,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Price and Badge (Right side)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Sale/Badge
                                                  Obx(
                                                    () => Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            data.validityType
                                                                    .toString() ==
                                                                "weekly"
                                                            ? Color(0xFFFFF3CD)
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "monthly"
                                                            ? Color(0xFFD1E7FF)
                                                            : Color(0xFFFFF3CD),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        data.validityType
                                                                    .toString() ==
                                                                "weekly"
                                                            ? languagesController
                                                                  .tr("WEEKLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "monthly"
                                                            ? languagesController
                                                                  .tr("MONTHLY")
                                                            : languagesController
                                                                  .tr("SALE"),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 11,
                                                          color:
                                                              data.validityType
                                                                      .toString() ==
                                                                  "weekly"
                                                              ? Color(
                                                                  0xFF856404,
                                                                )
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "monthly"
                                                              ? Color(
                                                                  0xFF084298,
                                                                )
                                                              : Color(
                                                                  0xFF856404,
                                                                ),
                                                          fontFamily:
                                                              box
                                                                      .read(
                                                                        "language",
                                                                      )
                                                                      .toString() ==
                                                                  "Fa"
                                                              ? Get.find<
                                                                      FontController
                                                                    >()
                                                                    .currentFont
                                                              : null,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),

                                                  // Price
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .baseline,
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    children: [
                                                      PriceTextView(
                                                        price: data.sellingPrice
                                                            .toString(),
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        box.read(
                                                          "currency_code",
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey
                                                              .shade700,
                                                          fontFamily:
                                                              box
                                                                      .read(
                                                                        "language",
                                                                      )
                                                                      .toString() ==
                                                                  "Fa"
                                                              ? Get.find<
                                                                      FontController
                                                                    >()
                                                                    .currentFont
                                                              : null,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : bundleController.finalList.isEmpty
                            ? Container(color: Colors.transparent)
                            : RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  itemCount: bundleController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        bundleController.finalList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (confirmPinController
                                            .numberController
                                            .text
                                            .isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: languagesController.tr(
                                              "ENTER_PHONE_NUMBER",
                                            ),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else {
                                          if (box.read("permission") == "no" ||
                                              confirmPinController
                                                      .numberController
                                                      .text
                                                      .length
                                                      .toString() !=
                                                  box
                                                      .read("maxlength")
                                                      .toString()) {
                                            Fluttertoast.showToast(
                                              msg: languagesController.tr(
                                                "ENTER_CORRECT_NUMBER",
                                              ),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            // Stop further execution if permission is "no"
                                          } else {
                                            box.write(
                                              "bundleID",
                                              data.id.toString(),
                                            );

                                            showDialog(
                                              context: context,
                                              barrierColor: Colors.black
                                                  .withOpacity(0.6),
                                              builder: (context) {
                                                return AnimatedConfirmDialog(
                                                  data: data,
                                                  confirmPinController:
                                                      confirmPinController,
                                                  languagesController:
                                                      languagesController,
                                                  box: box,
                                                  screenWidth: screenWidth,
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 10,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              // Company Logo
                                              Container(
                                                height: 56,
                                                width: 56,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                          data
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),

                                              // Bundle Info (Left side)
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      data.bundleTitle
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black87,
                                                        fontFamily:
                                                            box
                                                                    .read(
                                                                      "language",
                                                                    )
                                                                    .toString() ==
                                                                "Fa"
                                                            ? Get.find<
                                                                    FontController
                                                                  >()
                                                                  .currentFont
                                                            : null,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Obx(
                                                      () => Text(
                                                        data.validityType
                                                                    .toString() ==
                                                                "unlimited"
                                                            ? languagesController
                                                                  .tr(
                                                                    "UNLIMITED",
                                                                  )
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "monthly"
                                                            ? languagesController
                                                                  .tr("MONTHLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "weekly"
                                                            ? languagesController
                                                                  .tr("WEEKLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "daily"
                                                            ? languagesController
                                                                  .tr("DAILY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "hourly"
                                                            ? languagesController
                                                                  .tr("HOURLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "nightly"
                                                            ? languagesController
                                                                  .tr("NIGHTLY")
                                                            : "",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              box
                                                                      .read(
                                                                        "language",
                                                                      )
                                                                      .toString() ==
                                                                  "Fa"
                                                              ? Get.find<
                                                                      FontController
                                                                    >()
                                                                    .currentFont
                                                              : null,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Price and Badge (Right side)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Sale/Badge
                                                  Obx(
                                                    () => Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            data.validityType
                                                                    .toString() ==
                                                                "weekly"
                                                            ? Color(0xFFFFF3CD)
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "monthly"
                                                            ? Color(0xFFD1E7FF)
                                                            : Color(0xFFFFF3CD),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        data.validityType
                                                                    .toString() ==
                                                                "weekly"
                                                            ? languagesController
                                                                  .tr("WEEKLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "monthly"
                                                            ? languagesController
                                                                  .tr("MONTHLY")
                                                            : languagesController
                                                                  .tr("SALE"),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 11,
                                                          color:
                                                              data.validityType
                                                                      .toString() ==
                                                                  "weekly"
                                                              ? Color(
                                                                  0xFF856404,
                                                                )
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "monthly"
                                                              ? Color(
                                                                  0xFF084298,
                                                                )
                                                              : Color(
                                                                  0xFF856404,
                                                                ),
                                                          fontFamily:
                                                              box
                                                                      .read(
                                                                        "language",
                                                                      )
                                                                      .toString() ==
                                                                  "Fa"
                                                              ? Get.find<
                                                                      FontController
                                                                    >()
                                                                    .currentFont
                                                              : null,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),

                                                  // Price
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .baseline,
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    children: [
                                                      PriceTextView(
                                                        price: data.sellingPrice
                                                            .toString(),
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        box.read(
                                                          "currency_code",
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey
                                                              .shade700,
                                                          fontFamily:
                                                              box
                                                                      .read(
                                                                        "language",
                                                                      )
                                                                      .toString() ==
                                                                  "Fa"
                                                              ? Get.find<
                                                                      FontController
                                                                    >()
                                                                    .currentFont
                                                              : null,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
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

//......................................................................................
