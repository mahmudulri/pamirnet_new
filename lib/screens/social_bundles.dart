import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:pamirnet/controllers/bundle_controller.dart';
import 'package:pamirnet/controllers/confirm_pin_controller.dart';
import 'package:pamirnet/controllers/country_list_controller.dart';
import 'package:pamirnet/controllers/service_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/global_controller/page_controller.dart';
import 'package:pamirnet/helpers/price.dart';
import 'package:pamirnet/utils/colors.dart';

import '../global_controller/font_controller.dart';

class SocialBundles extends StatefulWidget {
  SocialBundles({super.key});

  @override
  State<SocialBundles> createState() => _SocialBundlesState();
}

class _SocialBundlesState extends State<SocialBundles> {
  final serviceController = Get.find<ServiceController>();

  final bundleController = Get.find<BundleController>();
  LanguagesController languagesController = Get.put(LanguagesController());

  // final confirmPinController = Get.find<ConfirmPinController>();

  final ScrollController scrollController = ScrollController();

  String search = "";
  String inputNumber = "";

  int selectedIndex = -1;
  int duration_selectedIndex = -1;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    bundleController.finalList.clear();
    bundleController.initialpage = 1;
    scrollController.addListener(refresh);
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchservices();
      bundleController.fetchallbundles();
    });
  }

  Future<void> refresh() async {
    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination!.totalPages ??
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

  List countryCode = ["+93", "+880", "+91"];

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
        child: Column(
          children: [
            Container(
              height: 120,
              width: screenWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
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
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              // box.write("country_id", "");
                              // box.write("company_id", "");
                              // bundleController.finalList.clear();
                              // bundleController.initialpage = 1;
                              // bundleController.fetchallbundles();
                            },
                            child: Obx(
                              () => Text(
                                languagesController.tr("SOCIAL_BUNDLES"),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenHeight * 0.022,
                                  fontFamily:
                                      box.read("language").toString() == "Fa"
                                      ? Get.find<FontController>().currentFont
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: Colors.grey.shade300,
                            ),
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
                                return service.company?.companycodes?.any((
                                      code,
                                    ) {
                                      final reservedDigit =
                                          code.reservedDigit ?? '';
                                      return inputNumber.startsWith(
                                        reservedDigit,
                                      );
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
                                          box.write(
                                            "company_id",
                                            data.companyId,
                                          );
                                          bundleController.fetchallbundles();
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 65,
                                        decoration: BoxDecoration(
                                          color: selectedIndex == index
                                              ? Color(0xff34495e)
                                              : Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                                child:
                                                    CircularProgressIndicator(
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
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 2, color: Colors.white),
                    right: BorderSide(width: 1, color: Colors.white),
                    left: BorderSide(width: 1, color: Colors.white),
                  ),
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade600,
                              ),
                              border: InputBorder.none,
                              hintText: languagesController.tr("SEARCH"),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenHeight * 0.022,
                                fontFamily:
                                    box.read("language").toString() == "Fa"
                                    ? Get.find<FontController>().currentFont
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Obx(
                          () =>
                              bundleController.isLoading.value == false &&
                                  bundleController.finalList.isNotEmpty
                              ? RefreshIndicator(
                                  onRefresh: refresh,
                                  child: GridView.builder(
                                    shrinkWrap: false,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    controller: scrollController,
                                    itemCount:
                                        bundleController.finalList.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 5.0,
                                          mainAxisSpacing: 5.0,
                                          childAspectRatio: 0.7,
                                        ),
                                    itemBuilder: (context, index) {
                                      final data =
                                          bundleController.finalList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          box.write(
                                            "bundleID",
                                            data.id.toString(),
                                          );
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                contentPadding: EdgeInsets.all(
                                                  0,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(17),
                                                ),
                                                content: SocialdialogBox(
                                                  companyname: data
                                                      .service!
                                                      .company!
                                                      .companyName
                                                      .toString(),
                                                  title: data.bundleTitle,
                                                  validity: data.validityType,
                                                  buyingprice: data.buyingPrice,
                                                  sellingprice:
                                                      data.sellingPrice,
                                                  imagelink: data
                                                      .service!
                                                      .company!
                                                      .companyLogo
                                                      .toString(),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.20),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                data
                                                    .service!
                                                    .company!
                                                    .companyName
                                                    .toString(),
                                              ),
                                              Image.network(
                                                data
                                                    .service!
                                                    .company!
                                                    .companyLogo
                                                    .toString(),
                                                height: 50,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    data.bundleTitle.toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          screenHeight * 0.016,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                  // Text(
                                                  //   data.validityType
                                                  //       .toString(),
                                                  //   style: TextStyle(
                                                  //     color: AppColors
                                                  //         .primaryColor,
                                                  //     fontSize:
                                                  //         screenHeight * 0.012,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    languagesController.tr(
                                                      "SALE",
                                                    ),
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize:
                                                          screenHeight * 0.013,
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
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      PriceTextView(
                                                        price: data.sellingPrice
                                                            .toString(),
                                                        textStyle: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                      SizedBox(width: 2),
                                                      Text(
                                                        " ${box.read("currency_code")}",
                                                        style: TextStyle(
                                                          fontSize: 8,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                      );
                                    },
                                  ),
                                )
                              : bundleController.finalList.isEmpty
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey,
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: refresh,
                                  child: GridView.builder(
                                    shrinkWrap: false,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    controller: scrollController,
                                    itemCount:
                                        bundleController.finalList.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 5.0,
                                          mainAxisSpacing: 5.0,
                                          childAspectRatio: 0.7,
                                        ),
                                    itemBuilder: (context, index) {
                                      final data =
                                          bundleController.finalList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          box.write(
                                            "bundleID",
                                            data.id.toString(),
                                          );
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                contentPadding: EdgeInsets.all(
                                                  0,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(17),
                                                ),
                                                content: SocialdialogBox(
                                                  companyname: data
                                                      .service!
                                                      .company!
                                                      .companyName
                                                      .toString(),
                                                  title: data.bundleTitle,
                                                  validity: data.validityType,
                                                  buyingprice: data.buyingPrice,
                                                  sellingprice:
                                                      data.sellingPrice,
                                                  imagelink: data
                                                      .service!
                                                      .company!
                                                      .companyLogo
                                                      .toString(),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.20),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                data
                                                    .service!
                                                    .company!
                                                    .companyName
                                                    .toString(),
                                              ),
                                              Image.network(
                                                data
                                                    .service!
                                                    .company!
                                                    .companyLogo
                                                    .toString(),
                                                height: 50,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    data.bundleTitle.toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          screenHeight * 0.016,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                  // Text(
                                                  //   data.validityType
                                                  //       .toString(),
                                                  //   style: TextStyle(
                                                  //     color: AppColors
                                                  //         .primaryColor,
                                                  //     fontSize:
                                                  //         screenHeight * 0.012,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    languagesController.tr(
                                                      "SALE",
                                                    ),
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize:
                                                          screenHeight * 0.013,
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
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      PriceTextView(
                                                        price: data.sellingPrice
                                                            .toString(),
                                                        textStyle: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                      SizedBox(width: 2),
                                                      Text(
                                                        " ${box.read("currency_code")}",
                                                        style: TextStyle(
                                                          fontSize: 8,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                      );
                                    },
                                  ),
                                ),
                        ),
                      ),
                      Obx(
                        () => bundleController.isLoading.value == true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class SocialdialogBox extends StatefulWidget {
  SocialdialogBox({
    super.key,
    this.title,
    this.validity,
    this.buyingprice,
    this.sellingprice,
    this.imagelink,
    this.companyname,
  });

  String? companyname;
  String? title;
  String? validity;
  String? buyingprice;
  String? sellingprice;
  String? imagelink;

  @override
  State<SocialdialogBox> createState() => _SocialdialogBoxState();
}

class _SocialdialogBoxState extends State<SocialdialogBox> {
  String selectedCode = "+93";

  final countrylistController = Get.find<CountryListController>();

  final confirmPinController = Get.find<ConfirmPinController>();

  final box = GetStorage();

  final FocusNode _focusNode = FocusNode();

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 520,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Obx(
        () => confirmPinController.isLoading.value == false
            ? ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,

                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff1890FF).withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Company Logo
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Image.network(
                                widget.imagelink.toString(),
                                height: 60,
                              ),
                            ),
                            SizedBox(height: 8),

                            // Company Name
                            Text(
                              widget.companyname.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 5),

                            // Bundle Title
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    languagesController.tr("BUNDLE_TITLE"),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    widget.title.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),

                            // Pricing Info
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Color(0xff1890FF),
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        languagesController.tr("BUY"),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        widget.buyingprice.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        box.read("currency_code"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 5,
                                    color: Colors.grey.shade200,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.sell_outlined,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        languagesController.tr("SALE"),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        widget.sellingprice.toString(),
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        box.read("currency_code"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // ID Input Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_android,
                              color: Color(0xff1890FF),
                              size: 22,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller:
                                    confirmPinController.numberController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: languagesController.tr("ENTER_ID"),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    // PIN Input
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 50,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1.5,
                            color: Colors.grey.shade200,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              maxLength: 4,
                              controller: confirmPinController.pinController,
                              keyboardType: TextInputType.phone,
                              textAlign: TextAlign.center,
                              obscureText: true,
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: languagesController.tr("PIN"),
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () {
                              if (confirmPinController
                                  .numberController
                                  .text
                                  .isEmpty) {
                                Fluttertoast.showToast(
                                  msg: languagesController.tr("ENTER_ID"),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }

                              if (confirmPinController
                                  .pinController
                                  .text
                                  .isEmpty) {
                                Fluttertoast.showToast(
                                  msg: languagesController.tr("ENTER_YOUR_PIN"),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }

                              print("ready for recharge...");
                              confirmPinController.placeOrder(context);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    languagesController.tr("CONFIRMATION"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.grey.shade700,
                                    size: 20,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    languagesController.tr("CANCEL"),
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Center(
                child: Container(
                  height: 250,
                  width: 250,
                  child: Lottie.asset('assets/loties/recharge.json'),
                ),
              ),
      ),
    );
  }
}
