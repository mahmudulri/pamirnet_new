import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:pamirnet/controllers/country_list_controller.dart';
import 'package:pamirnet/controllers/custom_history_controller.dart';
import 'package:pamirnet/controllers/custom_recharge_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/global_controller/page_controller.dart';
import 'package:pamirnet/pages/homepages.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:pamirnet/widgets/button_one.dart';

import '../controllers/company_controller.dart';
import '../global_controller/conversation_controller.dart';
import '../controllers/currency_controller.dart';
import '../controllers/recharge_config_controller.dart';
import '../global_controller/font_controller.dart';
import '../widgets/ktext.dart';

class CreditTransfer extends StatefulWidget {
  CreditTransfer({super.key});

  @override
  State<CreditTransfer> createState() => _CreditTransferState();
}

class _CreditTransferState extends State<CreditTransfer> {
  final customhistoryController = Get.find<CustomHistoryController>();

  final countryListController = Get.find<CountryListController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  CustomRechargeController customRechargeController = Get.put(
    CustomRechargeController(),
  );

  ConversationController conversationController = Get.put(
    ConversationController(),
  );
  final box = GetStorage();
  int selectedIndex = 0;

  final FocusNode _focusNode = FocusNode();

  RxList<bool> expandedIndices = <bool>[].obs;

  final ScrollController scrollController = ScrollController();

  final companyController = Get.find<CompanyController>();

  RechargeConfigController configController = Get.put(
    RechargeConfigController(),
  );

  CurrencyController currencyController = Get.put(CurrencyController());

  Future<void> refresh() async {
    final int totalPages =
        customhistoryController
            .allorderlist
            .value
            .payload
            ?.pagination!
            .totalPages ??
        0;
    final int currentPage = customhistoryController.initialpage;

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
      customhistoryController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (customhistoryController.initialpage <= totalPages) {
        print("Load More...................");
        customhistoryController.fetchHistory();
      } else {
        customhistoryController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  List orderStatus = [];

  String defaultValue = "";

  String secondDropDown = "";
  @override
  void initState() {
    orderStatus = [
      {"title": languagesController.tr("PENDING"), "value": "order_status=0"},
      {"title": languagesController.tr("CONFIRMED"), "value": "order_status=1"},
      {"title": languagesController.tr("REJECTED"), "value": "order_status=2"},
    ];
    // TODO: implement initState
    super.initState();
    conversationController.resetConversion();
    customRechargeController.amountController.clear();
    customRechargeController.numberController.clear();
    currencyController.fetchCurrency();
    customRechargeController.numberController.addListener(() {
      final text = customRechargeController.numberController.text;
      companyController.matchCompanyByPhoneNumber(text);
    });
    customhistoryController.finalList.clear();
    customhistoryController.initialpage = 1;
    customhistoryController.fetchHistory();
    scrollController.addListener(refresh);
  }

  @override
  Widget build(BuildContext context) {
    // final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 8),
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
                      child: Container(height: 1, color: Colors.grey.shade300),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        companyController.fetchCompany();
                        // customhistoryController.finalList.clear();
                        // customhistoryController.initialpage = 1;
                        // customhistoryController.fetchHistory();
                      },
                      child: Text(
                        languagesController.tr("CREDIT_TRANSFER"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.022,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
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
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          countryListController.flagimageurl.toString(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: AppColors.primaryColor.withOpacity(0.20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            controller:
                                customRechargeController.numberController,
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: languagesController.tr("PHONENUMBER"),
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontFamily:
                                    box.read("language").toString() == "Fa"
                                    ? Get.find<FontController>().currentFont
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      final company = companyController.matchedCompany.value;
                      return Container(
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: company == null ? Colors.transparent : null,
                          image: company != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    company.companyLogo ?? '',
                                  ),
                                  fit: BoxFit.contain,
                                )
                              : null,
                        ),
                        child: company == null
                            ? Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.transparent,
                                ),
                              )
                            : null,
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 5),

              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            conversationController.inputAmount.value =
                                double.tryParse(value) ?? 0.0;
                          },
                          controller: customRechargeController.amountController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: languagesController.tr("AMOUNT"),
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                      KText(
                        text: "AFN",
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryColor.withOpacity(0.08),
                      Colors.white,
                      Colors.grey[50]!,
                    ],
                  ),
                  border: Border.all(
                    width: 2,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.12),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                height: 80,
                child: Obx(() {
                  final convertedList = conversationController
                      .getConvertedValues();

                  double buyingPrice = 0.0;
                  double sellingPrice = 0.0;
                  String symbol = "";

                  if (convertedList.isNotEmpty) {
                    final item = convertedList.first;
                    symbol = item['symbol'];
                    double baseValue = item['value'];

                    final configData = configController.allsettings.value.data;

                    double adjustPercent =
                        double.tryParse(configData?.adjustValue ?? "0") ?? 0;

                    bool isIncrease = configData?.adjustType == "increase";

                    buyingPrice = baseValue;

                    double adjustedPrice = isIncrease
                        ? baseValue + (baseValue * adjustPercent / 100)
                        : baseValue - (baseValue * adjustPercent / 100);

                    final sellingType = configData?.sellingAdjustType;
                    final sellingValueStr = configData?.sellingAdjustValue;

                    if (sellingValueStr == null || sellingValueStr.isEmpty) {
                      sellingPrice = adjustedPrice + (adjustedPrice * 5 / 100);
                    } else {
                      double sellingPercent =
                          double.tryParse(sellingValueStr) ?? 0;
                      bool sellingIncrease = sellingType == "increase";

                      sellingPrice = sellingIncrease
                          ? adjustedPrice +
                                (adjustedPrice * sellingPercent / 100)
                          : adjustedPrice -
                                (adjustedPrice * sellingPercent / 100);
                    }
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Row(
                      children: [
                        // Buying Price
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.orange[50]!,
                                  Colors.orange[50]!.withOpacity(0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.orange[200]!,
                                width: 1.5,
                              ),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[100],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.arrow_downward_rounded,
                                        size: 12,
                                        color: Colors.orange[700],
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Buying",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.orange[700],
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${symbol}",
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.orange[400],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  buyingPrice.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.orange[800],
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 12),

                        // Selling Price
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.green[50]!,
                                  Colors.green[50]!.withOpacity(0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green[200]!,
                                width: 1.5,
                              ),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        Icons.arrow_upward_rounded,
                                        size: 12,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Selling",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${symbol}",
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.green[400],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  sellingPrice.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.green[800],
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              SizedBox(height: 10),
              DefaultButton(
                buttonName: languagesController.tr("SEND_TO_DESTINATION"),
                mycolor: Color(0xff00AB55),
                onpressed: () {
                  if (customRechargeController.numberController.text.isEmpty ||
                      customRechargeController.amountController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Enter required data",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                          contentPadding: EdgeInsets.zero,
                          content: StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  color: Colors.white,
                                ),
                                height: 220,
                                width: screenWidth,
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Obx(
                                    () =>
                                        customRechargeController
                                                .isLoading
                                                .value ==
                                            false
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(height: 8),

                                              Text(
                                                languagesController.tr(
                                                  "ARE_YOU_SURE_TO_TRANSFER",
                                                ),
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 50,
                                                width: screenWidth,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          customRechargeController
                                                              .placeOrder(
                                                                context,
                                                              );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              languagesController
                                                                  .tr(
                                                                    "CONFIRMATION",
                                                                  ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                      flex: 2,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                            border: Border.all(
                                                              width: 1,
                                                              color: Colors
                                                                  .grey
                                                                  .shade300,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              languagesController
                                                                  .tr("CANCEL"),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(
                                            height: 250,
                                            width: 250,
                                            child: Lottie.asset(
                                              'assets/loties/recharge.json',
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              Container(
                height: 800,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Text(
                        languagesController.tr("TRANSFER_HISTORY"),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                          fontWeight: FontWeight.w600,
                          fontFamily: box.read("language").toString() == "Fa"
                              ? Get.find<FontController>().currentFont
                              : null,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: Icon(
                                FontAwesomeIcons.chevronDown,
                                color: Colors.grey,
                              ),
                              isDense: true,
                              value: defaultValue,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  value: "",
                                  child: Text(
                                    languagesController.tr("ALL"),
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.020,
                                      fontFamily:
                                          box.read("language").toString() ==
                                              "Fa"
                                          ? Get.find<FontController>()
                                                .currentFont
                                          : null,
                                    ),
                                  ),
                                ),
                                ...orderStatus.map<DropdownMenuItem<String>>((
                                  data,
                                ) {
                                  return DropdownMenuItem(
                                    value: data['value'],
                                    child: Text(data['title']),
                                  );
                                }).toList(),
                              ],
                              onChanged: (value) {
                                box.write("orderstatus", value);

                                print("selected Value $value");
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 50,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: AppColors.primaryColor.withOpacity(0.20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Text(
                                languagesController.tr("DATE"),
                                style: TextStyle(
                                  fontFamily:
                                      box.read("language").toString() == "Fa"
                                      ? Get.find<FontController>().currentFont
                                      : null,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.calendar_month,
                                color: Colors.grey.shade600,
                                size: screenHeight * 0.018,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 50,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: AppColors.primaryColor.withOpacity(0.20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey.shade600),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: languagesController.tr(
                                      "SEARCH_BY_PHOENUMBER",
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontFamily:
                                          box.read("language").toString() ==
                                              "Fa"
                                          ? Get.find<FontController>()
                                                .currentFont
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: DefaultButton(
                              buttonName: languagesController.tr(
                                "APPLY_FILTER",
                              ),
                              mycolor: AppColors.primaryColor,
                              onpressed: () {
                                customhistoryController.finalList.clear();
                                customhistoryController.initialpage = 1;
                                customhistoryController.fetchHistory();
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: screenHeight * 0.065,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(width: 1, color: Colors.red),
                              ),
                              child: Center(
                                child: Text(
                                  languagesController.tr("REMOVE_FILTER"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                    fontSize: screenHeight * 0.016,
                                    fontFamily:
                                        box.read("language").toString() == "Fa"
                                        ? Get.find<FontController>().currentFont
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: Obx(() {
                          // Ensure expandedIndices matches the length of finalList
                          if (expandedIndices.length !=
                              customhistoryController.finalList.length) {
                            expandedIndices.assignAll(
                              List.generate(
                                customhistoryController.finalList.length,
                                (index) => false,
                              ),
                            );
                          }

                          return customhistoryController.isLoading.value ==
                                      false &&
                                  customhistoryController.finalList.isNotEmpty
                              ? RefreshIndicator(
                                  onRefresh: refresh,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: customhistoryController
                                        .finalList
                                        .length,
                                    itemBuilder: (context, index) {
                                      final data = customhistoryController
                                          .finalList[index];

                                      return Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            ExpansionTile(
                                              key: Key(
                                                index.toString(),
                                              ), // Ensure state retention
                                              initiallyExpanded:
                                                  expandedIndices[index],
                                              onExpansionChanged: (isExpanded) {
                                                expandedIndices[index] =
                                                    isExpanded;
                                              },
                                              tilePadding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              title: Row(
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.bundle!.bundleTitle
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
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
                                                      Text(
                                                        data.rechargebleAccount
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
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
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing: expandedIndices[index]
                                                  ? null
                                                  : GestureDetector(
                                                      onTap: () {
                                                        expandedIndices[index] =
                                                            true;
                                                      },
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          SizedBox(width: 5),
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .chevronDown,
                                                            size:
                                                                screenHeight *
                                                                0.022,
                                                            color: Color(
                                                              0xff1890FF,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController.tr(
                                                              "TRANSFER_STATUS",
                                                            ),
                                                          ),
                                                          Text(
                                                            data.status
                                                                        .toString() ==
                                                                    "0"
                                                                ? languagesController
                                                                      .tr(
                                                                        "PENDING",
                                                                      )
                                                                : data.status
                                                                          .toString() ==
                                                                      "1"
                                                                ? languagesController
                                                                      .tr(
                                                                        "SUCCESS",
                                                                      )
                                                                : languagesController
                                                                      .tr(
                                                                        "REJECTED",
                                                                      ),
                                                            style: TextStyle(
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
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController
                                                                .tr("AMOUNT"),
                                                          ),
                                                          Text(
                                                            "${data.bundle.amount} ${box.read("currency_code")}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController
                                                                .tr("DATE"),
                                                            style: TextStyle(
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
                                                          Text(
                                                            DateFormat(
                                                              'yyyy-MM-dd',
                                                            ).format(
                                                              DateTime.parse(
                                                                data.createdAt
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController
                                                                .tr("TIME"),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                                          Text(
                                                            DateFormat(
                                                              'hh:mm a',
                                                            ).format(
                                                              DateTime.parse(
                                                                data.createdAt
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : customhistoryController.finalList.isEmpty
                              ? SizedBox()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                      customhistoryController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data = customhistoryController
                                        .finalList[index];

                                    return Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          ExpansionTile(
                                            key: Key(
                                              index.toString(),
                                            ), // Ensure state retention
                                            initiallyExpanded:
                                                expandedIndices[index],
                                            onExpansionChanged: (isExpanded) {
                                              expandedIndices[index] =
                                                  isExpanded;
                                            },
                                            tilePadding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            title: Row(
                                              children: [
                                                Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        data
                                                            .bundle!
                                                            .service!
                                                            .company!
                                                            .companyLogo
                                                            .toString(),
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.bundle!.bundleTitle
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      data.rechargebleAccount
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            trailing: expandedIndices[index]
                                                ? null
                                                : GestureDetector(
                                                    onTap: () {
                                                      expandedIndices[index] =
                                                          true;
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(width: 5),
                                                        Icon(
                                                          FontAwesomeIcons
                                                              .chevronDown,
                                                          size:
                                                              screenHeight *
                                                              0.022,
                                                          color: Color(
                                                            0xff1890FF,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          languagesController.tr(
                                                            "TRANSFER_STATUS",
                                                          ),
                                                        ),
                                                        Text(
                                                          data.status
                                                                      .toString() ==
                                                                  "0"
                                                              ? languagesController
                                                                    .tr(
                                                                      "PENDING",
                                                                    )
                                                              : data.status
                                                                        .toString() ==
                                                                    "1"
                                                              ? languagesController
                                                                    .tr(
                                                                      "SUCCESS",
                                                                    )
                                                              : languagesController
                                                                    .tr(
                                                                      "REJECTED",
                                                                    ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          languagesController
                                                              .tr("AMOUNT"),
                                                        ),
                                                        Text(
                                                          "${data.bundle.amount} ${box.read("currency_code")}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          languagesController
                                                              .tr("DATE"),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                            'yyyy-MM-dd',
                                                          ).format(
                                                            DateTime.parse(
                                                              data.createdAt
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          languagesController
                                                              .tr("TIME"),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat(
                                                            'hh:mm a',
                                                          ).format(
                                                            DateTime.parse(
                                                              data.createdAt
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Container(height: 60, width: screenWidth),
            ],
          ),
        ),
      ),
    );
  }
}
