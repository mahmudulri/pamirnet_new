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
import '../widgets/ktext.dart';
import '../widgets/social_animated_box.dart';

class SocialBundles extends StatefulWidget {
  SocialBundles({super.key});

  @override
  State<SocialBundles> createState() => _SocialBundlesState();
}

class _SocialBundlesState extends State<SocialBundles> {
  final serviceController = Get.find<ServiceController>();

  final bundleController = Get.find<BundleController>();

  final confirmPinController = Get.find<ConfirmPinController>();
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
    confirmPinController.numberController.clear();

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
              height: 50,
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
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: screenWidth,

                          child: Column(
                            children: [
                              Expanded(
                                child: Obx(
                                  () =>
                                      bundleController.isLoading.value ==
                                              false &&
                                          bundleController.finalList.isNotEmpty
                                      ? RefreshIndicator(
                                          onRefresh: refresh,
                                          child: ListView.separated(
                                            separatorBuilder: (context, index) {
                                              return SizedBox(height: 4);
                                            },
                                            shrinkWrap: false,
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            controller: scrollController,
                                            itemCount: bundleController
                                                .finalList
                                                .length,
                                            itemBuilder: (context, index) {
                                              final data = bundleController
                                                  .finalList[index];
                                              return bundleBoxName(
                                                companyName: data
                                                    .service!
                                                    .company!
                                                    .companyName
                                                    .toString(),
                                                imageLink: data
                                                    .service!
                                                    .company!
                                                    .companyLogo
                                                    .toString(),
                                                bundleTitle: data.bundleTitle
                                                    .toString(),
                                                buyingPrice: data.buyingPrice
                                                    .toString(),
                                                sellingPrice: data.sellingPrice
                                                    .toString(),
                                                bundleID: data.id.toString(),
                                              );
                                            },
                                          ),
                                        )
                                      : bundleController.finalList.isEmpty
                                      ? SizedBox()
                                      : RefreshIndicator(
                                          onRefresh: refresh,
                                          child: ListView.separated(
                                            separatorBuilder: (context, index) {
                                              return SizedBox(height: 4);
                                            },
                                            shrinkWrap: false,
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            controller: scrollController,
                                            itemCount: bundleController
                                                .finalList
                                                .length,
                                            itemBuilder: (context, index) {
                                              final data = bundleController
                                                  .finalList[index];
                                              return bundleBoxName(
                                                companyName: data
                                                    .service!
                                                    .company!
                                                    .companyName
                                                    .toString(),
                                                imageLink: data
                                                    .service!
                                                    .company!
                                                    .companyLogo
                                                    .toString(),
                                                bundleTitle: data.bundleTitle
                                                    .toString(),
                                                buyingPrice: data.buyingPrice
                                                    .toString(),
                                                sellingPrice: data.sellingPrice
                                                    .toString(),
                                                bundleID: data.id.toString(),
                                              );
                                            },
                                          ),
                                        ),
                                ),
                              ),
                              Obx(
                                () => bundleController.isLoading.value == true
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }
}

class bundleBoxName extends StatelessWidget {
  bundleBoxName({
    super.key,
    this.companyName,
    this.bundleID,
    this.bundleTitle,
    this.buyingPrice,
    this.sellingPrice,
    this.imageLink,
  });
  String? companyName;
  String? bundleID;
  String? bundleTitle;
  String? buyingPrice;
  String? sellingPrice;
  String? imageLink;
  final box = GetStorage();

  final languagesController = Get.find<LanguagesController>();
  final confirmPinController = Get.find<ConfirmPinController>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Color of the shadow
                spreadRadius: 2, // How much the shadow spreads
                blurRadius: 3, // The blur radius of the shadow
                offset: Offset(0, 2), // The offset of the shadow
              ),
            ],
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.all(2),
            title: Container(
              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    box.write("bundleID", bundleID.toString());
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.65),
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: SocialdialogBox(
                            companyname: companyName.toString(),
                            title: bundleTitle,
                            buyingprice: buyingPrice,
                            sellingprice: sellingPrice,
                            imagelink: imageLink.toString(),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              imageLink.toString(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      Column(
                        children: [
                          Text(bundleTitle.toString()),
                          Row(
                            children: [
                              Text(
                                languagesController.tr("SELLING_PRICE"),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "  :  ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                sellingPrice.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                " ${box.read("currency_code")}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
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
            ),
            // trailing: Icon(
            //   Icons.arrow_drop_down,
            // ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    languagesController.tr("BUYING_PRICE"),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "  :  ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    buyingPrice.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    " ${box.read("currency_code")}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
