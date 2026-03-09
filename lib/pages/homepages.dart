import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/controllers/bundle_controller.dart';
import 'package:pamirnet/controllers/confirm_pin_controller.dart';
import 'package:pamirnet/controllers/dashboard_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/screens/credit_transfer.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:pamirnet/widgets/button_one.dart';
import 'package:intl/intl.dart';
import 'package:pamirnet/widgets/ktext.dart';
import '../controllers/categories_controller.dart';
import '../controllers/company_controller.dart';
import '../global_controller/conversation_controller.dart';
import '../controllers/country_list_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/slider_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/hawala_list_screen.dart';
import '../screens/top_up_screen.dart';
import '../screens/withdraw_screen.dart';
import '../widgets/customrechargebutton.dart';

class Homepages extends StatefulWidget {
  Homepages({super.key});

  @override
  State<Homepages> createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  List myimages = [
    "assets/icons/internet_package.png",
    "assets/icons/social_bundles.png",
    "assets/icons/mobile_recharge.png",
    "assets/icons/conversation_package.png",
  ];

  final dashboardController = Get.find<DashboardController>();

  final categorisListController = Get.find<CategorisListController>();
  final notificationController = Get.find<NotificationController>();

  final ConversationController conversationController = Get.put(
    ConversationController(),
    permanent: true,
  );

  // ignore: prefer_final_fields
  PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
  );

  final box = GetStorage();

  var currentIndex = 0.obs;
  final sliderController = Get.find<SliderController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    notificationController.fetchData();
    companyController.fetchCompany();
    sliderController.fetchSliderData();
    countrylistController.fetchCountryData();
  }

  final confirmPinController = Get.find<ConfirmPinController>();

  final bundleController = Get.find<BundleController>();

  final companyController = Get.find<CompanyController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  final Mypagecontroller mypagecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    confirmPinController.numberController.clear();

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 10),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                height: 140,
                width: screenWidth,
                child: Obx(() {
                  var sliderItems =
                      sliderController
                          .allsliderlist
                          .value
                          .data
                          ?.advertisements ??
                      [];

                  if (sliderItems.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(""),
                    );
                  }

                  return PageView.builder(
                    controller: _pageController,
                    itemCount: sliderItems.length,
                    onPageChanged: (index) {
                      currentIndex.value = index;
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          sliderItems[index].adSliderImageUrl ?? "",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.image_not_supported),
                              ),
                        ),
                      );
                    },
                  );
                }),
              ),

              SizedBox(height: 8),

              GradientActionButton(
                text: languagesController.tr("AFGHAN_RECHARGE"),
                onTap: () {
                  if (countrylistController.finalCountryList.isNotEmpty) {
                    var afghanistan = countrylistController.finalCountryList
                        .firstWhere(
                          (country) => country['country_name'] == "Afghanistan",
                          orElse: () => null,
                        );

                    if (afghanistan != null) {
                      box.write("country_id", "${afghanistan['id']}");
                      box.write("maxlength", "10");
                    }
                  }
                  mypagecontroller.changePage(
                    CreditTransfer(),
                    isMainPage: false,
                  );
                },
              ),
              SizedBox(height: 10),
              Container(
                height: 85,
                width: screenWidth,
                // color: Colors.red,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        mypagecontroller.changePage(
                          TopUpScreen(),
                          isMainPage: false,
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.primaryColor,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(height: 5),
                          KText(
                            text: languagesController.tr("TOP_UP"),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        mypagecontroller.changePage(
                          HawalaListScreen(),
                          isMainPage: false,
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Image.asset("assets/icons/exchange.png"),
                            ),
                          ),
                          SizedBox(height: 5),
                          KText(
                            text: languagesController.tr("HAWALA"),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        mypagecontroller.changePage(
                          WithdrawScreen(),
                          isMainPage: false,
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Image.asset(
                                "assets/icons/empty-wallet-tick.png",
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          KText(
                            text: languagesController.tr("WITHDRAW"),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.blue.shade50,
                                      Colors.purple.shade50,
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Icon
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.2),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.rocket_launch_rounded,
                                        size: 48,
                                        color: Colors.blue.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Title
                                    KText(
                                      text: languagesController.tr(
                                        "COMING_SOON",
                                      ),

                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                    ),
                                    const SizedBox(height: 12),

                                    // Description
                                    KText(
                                      text: languagesController.tr(
                                        "COMING_SOON_TITLE",
                                      ),
                                      textAlign: TextAlign.center,

                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(height: 24),

                                    // Close Button
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade600,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: KText(
                                        text: languagesController.tr("CLOSE"),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Image.asset(
                                "assets/icons/wallet-money.png",
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          KText(
                            text: languagesController.tr("ACCOUNTING"),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              Container(
                height: 70,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.50),
                          borderRadius: BorderRadius.circular(10),
                          border: Border(
                            left: BorderSide(width: 3, color: Colors.green),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/balance.png",
                                    height: 30,
                                  ),
                                  SizedBox(width: 6),
                                  Obx(
                                    () => Text(
                                      languagesController.tr("BALANCE"),
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            box.read("language").toString() ==
                                                "Fa"
                                            ? Get.find<FontController>()
                                                  .currentFont
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Obx(
                                () =>
                                    dashboardController.isLoading.value == false
                                    ? Row(
                                        children: [
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'en_US',
                                              symbol: '',
                                              decimalDigits: 2,
                                            ).format(
                                              conversationController
                                                  .convertFromUsd(
                                                    double.parse(
                                                      dashboardController
                                                          .alldashboardData
                                                          .value
                                                          .data!
                                                          .balance
                                                          .toString(),
                                                    ),
                                                  ),
                                            ),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade700,
                                              fontFamily:
                                                  box
                                                          .read("language")
                                                          .toString() ==
                                                      "Fa"
                                                  ? Get.find<FontController>()
                                                        .currentFont
                                                  : null,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            conversationController
                                                .selectedCurrency
                                                .value,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.bold,
                                            ),
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

                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.50),
                          borderRadius: BorderRadius.circular(10),
                          border: Border(
                            left: BorderSide(width: 3, color: Colors.red),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/loan_balance.png",
                                    height: 30,
                                  ),
                                  SizedBox(width: 6),
                                  Obx(
                                    () => Text(
                                      languagesController.tr("LOAN_BALANCE"),
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            box.read("language").toString() ==
                                                "Fa"
                                            ? Get.find<FontController>()
                                                  .currentFont
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Obx(
                                () =>
                                    dashboardController.isLoading.value == false
                                    ? Row(
                                        children: [
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'en_US',
                                              symbol: '',
                                              decimalDigits: 2,
                                            ).format(
                                              conversationController
                                                  .convertFromUsd(
                                                    double.parse(
                                                      dashboardController
                                                          .alldashboardData
                                                          .value
                                                          .data!
                                                          .loanBalance
                                                          .toString(),
                                                    ),
                                                  ),
                                            ),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade700,
                                              fontFamily:
                                                  box
                                                          .read("language")
                                                          .toString() ==
                                                      "Fa"
                                                  ? Get.find<FontController>()
                                                        .currentFont
                                                  : null,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            conversationController
                                                .selectedCurrency
                                                .value,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.bold,
                                            ),
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
              SizedBox(height: 8),
              Container(
                height: 78,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.50),
                          borderRadius: BorderRadius.circular(10),
                          border: Border(
                            left: BorderSide(width: 3, color: Colors.yellow),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/profit.png",
                                    height: 20,
                                  ),
                                  SizedBox(width: 6),
                                  Obx(
                                    () => Text(
                                      languagesController.tr("PROFIT"),
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            box.read("language").toString() ==
                                                "Fa"
                                            ? Get.find<FontController>()
                                                  .currentFont
                                            : null,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Obx(
                                () =>
                                    dashboardController.isLoading.value == false
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                NumberFormat.currency(
                                                  locale: 'en_US',
                                                  symbol: '',
                                                  decimalDigits: 2,
                                                ).format(
                                                  conversationController
                                                      .convertFromUsd(
                                                        double.parse(
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .totalRevenue
                                                              .toString(),
                                                        ),
                                                      ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700,
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
                                                          "Fa"
                                                      ? Get.find<
                                                              FontController
                                                            >()
                                                            .currentFont
                                                      : null,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                conversationController
                                                    .selectedCurrency
                                                    .value,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                NumberFormat.currency(
                                                  locale: 'en_US',
                                                  symbol: '',
                                                  decimalDigits: 2,
                                                ).format(
                                                  conversationController
                                                      .convertFromUsd(
                                                        double.parse(
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .todayProfit
                                                              .toString(),
                                                        ),
                                                      ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700,
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
                                                          "Fa"
                                                      ? Get.find<
                                                              FontController
                                                            >()
                                                            .currentFont
                                                      : null,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                conversationController
                                                    .selectedCurrency
                                                    .value,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "(${languagesController.tr("TODAY")})",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
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
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.50),
                          borderRadius: BorderRadius.circular(10),
                          border: Border(
                            left: BorderSide(
                              width: 3,
                              color: Color(0xff1890FF),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/sale.png",
                                    height: 20,
                                  ),
                                  SizedBox(width: 6),
                                  Obx(
                                    () => Text(
                                      languagesController.tr("SALE"),
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            box.read("language").toString() ==
                                                "Fa"
                                            ? Get.find<FontController>()
                                                  .currentFont
                                            : null,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Obx(
                                () =>
                                    dashboardController.isLoading.value == false
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                NumberFormat.currency(
                                                  locale: 'en_US',
                                                  symbol: '',
                                                  decimalDigits: 2,
                                                ).format(
                                                  conversationController
                                                      .convertFromUsd(
                                                        double.parse(
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .totalSoldAmount
                                                              .toString(),
                                                        ),
                                                      ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700,
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
                                                          "Fa"
                                                      ? Get.find<
                                                              FontController
                                                            >()
                                                            .currentFont
                                                      : null,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                conversationController
                                                    .selectedCurrency
                                                    .value,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                NumberFormat.currency(
                                                  locale: 'en_US',
                                                  symbol: '',
                                                  decimalDigits: 2,
                                                ).format(
                                                  conversationController
                                                      .convertFromUsd(
                                                        double.parse(
                                                          dashboardController
                                                              .alldashboardData
                                                              .value
                                                              .data!
                                                              .todaySale
                                                              .toString(),
                                                        ),
                                                      ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade700,
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
                                                          "Fa"
                                                      ? Get.find<
                                                              FontController
                                                            >()
                                                            .currentFont
                                                      : null,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                conversationController
                                                    .selectedCurrency
                                                    .value,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "(${languagesController.tr("TODAY")})",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
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

              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
