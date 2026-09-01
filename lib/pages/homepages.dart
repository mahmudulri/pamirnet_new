import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:pamirnet/controllers/bundle_controller.dart';
import 'package:pamirnet/controllers/confirm_pin_controller.dart';
import 'package:pamirnet/controllers/dashboard_controller.dart';
import 'package:pamirnet/controllers/history_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/screens/credit_transfer.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:pamirnet/widgets/ktext.dart';
import '../accounting/accounting_base.dart';
import '../controllers/categories_controller.dart';
import '../controllers/company_controller.dart';
import '../global_controller/conversation_controller.dart';
import '../controllers/country_list_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/slider_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/hawala_list_screen.dart';
import '../screens/order_details.dart';
import '../screens/top_up_screen.dart';
import '../screens/withdraw_screen.dart';
import '../widgets/animatedbutton.dart';

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
  final historyController = Get.find<HistoryController>();
  final ScrollController scrollController = ScrollController();

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
    super.initState();
    historyController.finalList.clear();

    historyController.initialpage = 1;
    historyController.fetchHistory();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      confirmPinController.numberController.clear();

      notificationController.fetchData();
      companyController.fetchCompany();
      sliderController.fetchSliderData();
      countrylistController.fetchCountryData();

      box.write("date", "");
      box.write("orderstatus", "");
      box.write("search_target", "");

      // orderlistController.finalList.clear();
      // orderlistController.initialpage = 1;
      // orderlistController.fetchOrderlistdata();
    });
  }

  Future<void> refresh() async {
    final int totalPages =
        historyController.allorderlist.value.payload?.pagination!.totalPages ??
        0;
    final int currentPage = historyController.initialpage;

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
      historyController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (historyController.initialpage <= totalPages) {
        print("Load More...................");
        historyController.fetchHistory();
      } else {
        historyController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  // OrderlistController orderlistController = Get.put(OrderlistController());

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

              SizedBox(height: 12),
              AnimatedBorderButton(
                label: languagesController.tr("AFGHAN_RECHARGE"),
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
                        print("object");
                        Get.to(() => AccountingBaseScreen());
                      },
                      child: Container(
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
                            GestureDetector(
                              onTap: () {},
                              child: KText(
                                text: languagesController.tr("ACCOUNTING"),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
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
                                          NText(
                                            text:
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
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade700,
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
                                          NText(
                                            text:
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
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade700,
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
              SizedBox(height: 10),
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
                                              NText(
                                                text:
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
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade700,
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
                                              NText(
                                                text:
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
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade700,
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
                                              NText(
                                                text:
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
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade700,
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
                                              NText(
                                                text:
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
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade700,
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
              SizedBox(height: 10),
              Row(
                children: [
                  KText(
                    text: languagesController.tr("HISTORY"),
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Obx(
                () => historyController.isLoading.value == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
              Obx(
                () => historyController.isLoading.value == false
                    ? Container(
                        child:
                            historyController
                                .allorderlist
                                .value
                                .data!
                                .orders
                                .isNotEmpty
                            ? SizedBox()
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/empty.png",
                                      height: 80,
                                    ),
                                    KText(
                                      text: languagesController.tr(
                                        "DATA_NOT_FOUND",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      )
                    : SizedBox(),
              ),
              Container(
                height: 400,
                width: screenWidth,
                child: Obx(
                  () =>
                      historyController.isLoading.value == false &&
                          historyController.finalList.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: refresh,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.separated(
                              padding: EdgeInsets.all(0.0),
                              shrinkWrap: false,
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: scrollController,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 5);
                              },
                              itemCount: historyController.finalList.length,
                              itemBuilder: (context, index) {
                                final data = historyController.finalList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetailsScreen(
                                              createDate: data.createdAt
                                                  .toString(),
                                              status: data.status.toString(),
                                              rejectReason: data.rejectReason
                                                  .toString(),
                                              companyName: data
                                                  .bundle!
                                                  .service!
                                                  .company!
                                                  .companyName
                                                  .toString(),
                                              bundleTitle: data
                                                  .bundle!
                                                  .bundleTitle!
                                                  .toString(),
                                              rechargebleAccount: data
                                                  .rechargebleAccount!
                                                  .toString(),
                                              validityType:
                                                  data.bundle?.validityType
                                                      ?.toString() ??
                                                  "",
                                              sellingPrice: data
                                                  .bundle!
                                                  .sellingPrice
                                                  .toString(),
                                              orderID: data.id!.toString(),
                                              resellerName: dashboardController
                                                  .alldashboardData
                                                  .value
                                                  .data!
                                                  .userInfo!
                                                  .contactName
                                                  .toString(),
                                              resellerPhone: dashboardController
                                                  .alldashboardData
                                                  .value
                                                  .data!
                                                  .userInfo!
                                                  .phone
                                                  .toString(),
                                              companyLogo: data
                                                  .bundle!
                                                  .service!
                                                  .company!
                                                  .companyLogo
                                                  .toString(),
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 60,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey.shade200,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.listbuilderboxColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image:
                                                    CachedNetworkImageProvider(
                                                      data
                                                          .bundle!
                                                          .service!
                                                          .company!
                                                          .companyLogo
                                                          .toString(),
                                                    ),
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: NText(
                                                      text: data
                                                          .bundle!
                                                          .bundleTitle
                                                          .toString(),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  NText(
                                                    text: data
                                                        .rechargebleAccount
                                                        .toString(),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                NText(
                                                  text:
                                                      NumberFormat.currency(
                                                        locale: 'en_US',
                                                        symbol: '',
                                                        decimalDigits: 2,
                                                      ).format(
                                                        double.parse(
                                                          data
                                                              .bundle!
                                                              .sellingPrice
                                                              .toString(),
                                                        ),
                                                      ),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                SizedBox(width: 2),
                                                Text(
                                                  " " +
                                                      box.read("currency_code"),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Expanded(
                                          //   flex: 2,
                                          //   child: Container(
                                          //     child: Column(
                                          //       mainAxisAlignment:
                                          //           MainAxisAlignment
                                          //               .center,
                                          //       children: [
                                          //         Text(
                                          //           data.status
                                          //                       .toString() ==
                                          //                   "0"
                                          //               ? languagesController.tr(
                                          //                   "PENDING",
                                          //                 )
                                          //               : data.status
                                          //                         .toString() ==
                                          //                     "1"
                                          //               ? languagesController.tr(
                                          //                   "CONFIRMED",
                                          //                 )
                                          //               : languagesController.tr(
                                          //                   "REJECTED",
                                          //                 ),
                                          //           style: TextStyle(
                                          //             fontSize: 12,
                                          //             color: Colors
                                          //                 .black,
                                          //             fontWeight:
                                          //                 FontWeight
                                          //                     .w600,
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                              child:
                                                  data.status.toString() == "0"
                                                  ? Lottie.asset(
                                                      "assets/loties/pending.json",
                                                      width: 45,
                                                      height: 45,
                                                      fit: BoxFit.contain,
                                                      repeat: true,
                                                    )
                                                  : Image.asset(
                                                      data.status.toString() ==
                                                              "1"
                                                          ? "assets/icons/confirmed.png"
                                                          : "assets/icons/rejected.png",
                                                      width: 32,
                                                      height: 32,
                                                      fit: BoxFit.contain,
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : historyController.finalList.isEmpty
                      ? SizedBox()
                      : RefreshIndicator(
                          onRefresh: refresh,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.separated(
                              padding: EdgeInsets.all(0.0),
                              shrinkWrap: false,
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: scrollController,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 5);
                              },
                              itemCount: historyController.finalList.length,
                              itemBuilder: (context, index) {
                                final data = historyController.finalList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetailsScreen(
                                              createDate: data.createdAt
                                                  .toString(),
                                              status: data.status.toString(),
                                              rejectReason: data.rejectReason
                                                  .toString(),
                                              companyName: data
                                                  .bundle!
                                                  .service!
                                                  .company!
                                                  .companyName
                                                  .toString(),
                                              bundleTitle: data
                                                  .bundle!
                                                  .bundleTitle!
                                                  .toString(),
                                              rechargebleAccount: data
                                                  .rechargebleAccount!
                                                  .toString(),
                                              validityType:
                                                  data.bundle?.validityType
                                                      ?.toString() ??
                                                  "",
                                              sellingPrice: data
                                                  .bundle!
                                                  .sellingPrice
                                                  .toString(),
                                              orderID: data.id!.toString(),
                                              resellerName: dashboardController
                                                  .alldashboardData
                                                  .value
                                                  .data!
                                                  .userInfo!
                                                  .contactName
                                                  .toString(),
                                              resellerPhone: dashboardController
                                                  .alldashboardData
                                                  .value
                                                  .data!
                                                  .userInfo!
                                                  .phone
                                                  .toString(),
                                              companyLogo: data
                                                  .bundle!
                                                  .service!
                                                  .company!
                                                  .companyLogo
                                                  .toString(),
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 60,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.grey.shade200,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.listbuilderboxColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image:
                                                    CachedNetworkImageProvider(
                                                      data
                                                          .bundle!
                                                          .service!
                                                          .company!
                                                          .companyLogo
                                                          .toString(),
                                                    ),
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: NText(
                                                      text: data
                                                          .bundle!
                                                          .bundleTitle
                                                          .toString(),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  NText(
                                                    text: data
                                                        .rechargebleAccount
                                                        .toString(),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                NText(
                                                  text:
                                                      NumberFormat.currency(
                                                        locale: 'en_US',
                                                        symbol: '',
                                                        decimalDigits: 2,
                                                      ).format(
                                                        double.parse(
                                                          data
                                                              .bundle!
                                                              .sellingPrice
                                                              .toString(),
                                                        ),
                                                      ),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                SizedBox(width: 2),
                                                Text(
                                                  " " +
                                                      box.read("currency_code"),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Expanded(
                                          //   flex: 2,
                                          //   child: Container(
                                          //     child: Column(
                                          //       mainAxisAlignment:
                                          //           MainAxisAlignment
                                          //               .center,
                                          //       children: [
                                          //         Text(
                                          //           data.status
                                          //                       .toString() ==
                                          //                   "0"
                                          //               ? languagesController.tr(
                                          //                   "PENDING",
                                          //                 )
                                          //               : data.status
                                          //                         .toString() ==
                                          //                     "1"
                                          //               ? languagesController.tr(
                                          //                   "CONFIRMED",
                                          //                 )
                                          //               : languagesController.tr(
                                          //                   "REJECTED",
                                          //                 ),
                                          //           style: TextStyle(
                                          //             fontSize: 12,
                                          //             color: Colors
                                          //                 .black,
                                          //             fontWeight:
                                          //                 FontWeight
                                          //                     .w600,
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          Expanded(
                                            flex: 2,
                                            child: Center(
                                              child:
                                                  data.status.toString() == "0"
                                                  ? Lottie.asset(
                                                      "assets/loties/pending.json",
                                                      width: 45,
                                                      height: 45,
                                                      fit: BoxFit.contain,
                                                      repeat: true,
                                                    )
                                                  : Image.asset(
                                                      data.status.toString() ==
                                                              "1"
                                                          ? "assets/icons/confirmed.png"
                                                          : "assets/icons/rejected.png",
                                                      width: 32,
                                                      height: 32,
                                                      fit: BoxFit.contain,
                                                    ),
                                            ),
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
            ],
          ),
        ),
      ),
    );
  }
}
