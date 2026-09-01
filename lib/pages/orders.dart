import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:pamirnet/controllers/order_list_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/helpers/localtime_helper.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:pamirnet/widgets/ktext.dart';

import '../controllers/dashboard_controller.dart';
import '../global_controller/font_controller.dart';
import '../helpers/capture_image_helper.dart';
import '../helpers/share_image_helper.dart';
import '../screens/order_details.dart';

class Orders extends StatefulWidget {
  Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String defaultValue = "";

  String secondDropDown = "";

  final orderlistController = Get.find<OrderlistController>();

  Future<void> _selectJalaliDate() async {
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1385, 8),
      lastDate: Jalali(1450, 9),
    );
    if (picked != null) {
      // এখানে আপনি কাস্টম ফরম্যাট দিতে পারেন
      final formatted = picked.formatFullDate();
      _controller.text = formatted;
      print(_controller.text.toString());
    }
  }

  TextEditingController searchController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  late LanguagesController languagesController;

  List orderStatus = [];

  String search = "";

  final box = GetStorage();

  final ScrollController scrollController = ScrollController();
  final dashboardController = Get.find<DashboardController>();

  Future<void> refresh() async {
    final int totalPages =
        orderlistController.allorderlist.value.payload?.pagination.totalPages ??
        0;
    final int currentPage = orderlistController.initialpage;

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
      orderlistController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (orderlistController.initialpage <= totalPages) {
        print("Load More...................");
        orderlistController.fetchOrderlistdata();
      } else {
        orderlistController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  final RxString selectedDate = ''.obs;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // default date
      firstDate: DateTime(2000), // earliest date
      lastDate: DateTime(2100), // latest date
    );

    if (picked != null) {
      // Format the selected date as yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      selectedDate.value = formattedDate;
      print(formattedDate); // Print to console
      box.write("date", "selected_date=" + formattedDate.toString());
      orderlistController.finalList.clear();
      orderlistController.initialpage = 1;
      orderlistController.fetchOrderlistdata();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    languagesController = Get.put(LanguagesController());

    orderStatus = [
      {"title": languagesController.tr("PENDING"), "value": "order_status=0"},
      {"title": languagesController.tr("CONFIRMED"), "value": "order_status=1"},
      {"title": languagesController.tr("REJECTED"), "value": "order_status=2"},
    ];
    box.write("date", "");
    box.write("orderstatus", "");
    box.write("search_target", "");
    orderlistController.finalList.clear();
    orderlistController.initialpage = 1;
    orderlistController.fetchOrderlistdata();
    scrollController.addListener(refresh);
  }

  Timer? _debounce;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Transform.rotate(
                      angle: 0.785398,
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
                        // box.write("orderstatus", "");
                        // orderlistController.initialpage = 1;
                        // orderlistController.finalList.clear();
                        // orderlistController.fetchOrderlistdata();
                      },
                      child: Obx(
                        () => Text(
                          languagesController.tr("ORDERS"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * 0.022,
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
              ),
              SizedBox(height: 10),
              Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Color(0xffEEF4FF),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
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
                                    child: Text(
                                      data['title'],
                                      style: TextStyle(
                                        fontFamily: Get.find<FontController>()
                                            .currentFont,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                              onChanged: (value) {
                                box.write("orderstatus", value);
                                orderlistController.finalList.clear();
                                orderlistController.initialpage = 1;
                                orderlistController.fetchOrderlistdata();
                                print("selected Value $value");
                                setState(() {
                                  defaultValue = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => KText(
                                  text: selectedDate.value == ""
                                      ? languagesController.tr("DATE")
                                      : selectedDate.value.toString(),
                                  fontSize: screenWidth * 0.040,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.search_sharp,
                                color: Colors.grey,
                                size: screenHeight * 0.040,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Obx(
                                  () => TextField(
                                    keyboardType: TextInputType.phone,
                                    onChanged: (value) {
                                      // আগের timer থাকলে cancel
                                      if (_debounce?.isActive ?? false)
                                        _debounce!.cancel();

                                      _debounce = Timer(
                                        const Duration(seconds: 1),
                                        () {
                                          orderlistController.finalList.clear();
                                          orderlistController.initialpage = 1;

                                          box.write("search_target", value);

                                          orderlistController
                                              .fetchOrderlistdata();
                                          print(value);
                                        },
                                      );
                                    },
                                    decoration: InputDecoration(
                                      hintText: languagesController.tr(
                                        "SEARCH_BY_PHOENUMBER",
                                      ),
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenWidth * 0.040,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 450,
                // color: Colors.white,
                child: Column(
                  children: [
                    Obx(
                      () => orderlistController.isLoading.value == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            )
                          : SizedBox(),
                    ),
                    Obx(
                      () => orderlistController.isLoading.value == false
                          ? Container(
                              child:
                                  orderlistController
                                      .allorderlist
                                      .value
                                      .data!
                                      .orders
                                      .isNotEmpty
                                  ? SizedBox()
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/empty.png",
                                            height: 80,
                                          ),
                                          Text(
                                            languagesController.tr(
                                              "NO_DATA_FOUND",
                                            ),
                                            style: TextStyle(
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
                                        ],
                                      ),
                                    ),
                            )
                          : SizedBox(),
                    ),
                    Expanded(
                      child: Obx(
                        () =>
                            orderlistController.isLoading.value == false &&
                                orderlistController.finalList.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 10);
                                  },
                                  shrinkWrap: false,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  itemCount:
                                      orderlistController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        orderlistController.finalList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderDetailsScreen(
                                                  createDate: data.createdAt
                                                      .toString(),
                                                  status: data.status
                                                      .toString(),
                                                  rejectReason: data
                                                      .rejectReason
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
                                                  validityType: data
                                                      .bundle!
                                                      .validityType!
                                                      .toString(),
                                                  sellingPrice: data
                                                      .bundle!
                                                      .sellingPrice
                                                      .toString(),
                                                  orderID: data.id!.toString(),
                                                  resellerName:
                                                      dashboardController
                                                          .alldashboardData
                                                          .value
                                                          .data!
                                                          .userInfo!
                                                          .contactName
                                                          .toString(),
                                                  resellerPhone:
                                                      dashboardController
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
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: data.status.toString() == "0"
                                                ? Color(0xffFFC107)
                                                : data.status.toString() == "1"
                                                ? Colors.green
                                                : Color(0xffFF4842),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    data.status.toString() ==
                                                        "0"
                                                    ? Color(0xffFFC107)
                                                    : data.status.toString() ==
                                                          "1"
                                                    ? Colors.green
                                                    : Color(0xffFF4842),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 8,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    NText(
                                                      text:
                                                          "${languagesController.tr("ORDER_ID")} (# ${data.id})",
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          screenHeight * 0.020,
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
                                                    NText(
                                                      text:
                                                          DateFormat(
                                                            'dd MMM yyyy',
                                                          ).format(
                                                            DateTime.parse(
                                                              data.createdAt
                                                                  .toString(),
                                                            ),
                                                          ),
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          screenHeight * 0.020,
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                    10,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    10,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 5),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Obx(
                                                          () => Text(
                                                            languagesController.tr(
                                                              "RECHARGEABLE_ACCOUNT",
                                                            ),
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
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
                                                        Expanded(
                                                          child: NText(
                                                            text: data
                                                                .rechargebleAccount
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.end,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                screenHeight *
                                                                0.018,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 3),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: Obx(
                                                      () => Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController.tr(
                                                              "TRANSACTION_STATUS",
                                                            ),
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
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
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  data.status
                                                                          .toString() ==
                                                                      "0"
                                                                  ? Colors.grey
                                                                        .withOpacity(
                                                                          0.12,
                                                                        )
                                                                  : data.status
                                                                            .toString() ==
                                                                        "1"
                                                                  ? Colors.green
                                                                        .withOpacity(
                                                                          0.12,
                                                                        )
                                                                  : Colors.red
                                                                        .withOpacity(
                                                                          0.12,
                                                                        ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    6,
                                                                  ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical: 6,
                                                                  ),
                                                              child: Text(
                                                                data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? languagesController.tr(
                                                                        "PENDING",
                                                                      )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? languagesController.tr(
                                                                        "CONFIRMED",
                                                                      )
                                                                    : languagesController.tr(
                                                                        "REJECTED",
                                                                      ),
                                                                style: TextStyle(
                                                                  color:
                                                                      data.status
                                                                              .toString() ==
                                                                          "0"
                                                                      ? Colors
                                                                            .grey
                                                                      : data.status.toString() ==
                                                                            "1"
                                                                      ? Colors
                                                                            .green
                                                                      : Colors
                                                                            .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.015,
                                                                  fontFamily:
                                                                      box.read("language").toString() ==
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
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 3),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              languagesController
                                                                  .tr("BUY"),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                                fontFamily:
                                                                    Get.find<
                                                                          FontController
                                                                        >()
                                                                        .currentFont,
                                                              ),
                                                            ),
                                                            Text(" : "),
                                                            NText(
                                                              text:
                                                                  NumberFormat.currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double.parse(
                                                                      data
                                                                          .bundle!
                                                                          .buyingPrice
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
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
                                                            SizedBox(width: 5),
                                                            Text(
                                                              box.read(
                                                                "currency_code",
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              languagesController
                                                                  .tr("SELL"),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
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
                                                            Text(" : "),
                                                            NText(
                                                              text:
                                                                  NumberFormat.currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double.parse(
                                                                      data
                                                                          .bundle!
                                                                          .sellingPrice
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
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
                                                            SizedBox(width: 5),
                                                            Text(
                                                              box.read(
                                                                "currency_code",
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : orderlistController.finalList.isEmpty
                            ? SizedBox()
                            : RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 10);
                                  },
                                  shrinkWrap: false,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  itemCount:
                                      orderlistController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        orderlistController.finalList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderDetailsScreen(
                                                  createDate: data.createdAt
                                                      .toString(),
                                                  status: data.status
                                                      .toString(),
                                                  rejectReason: data
                                                      .rejectReason
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
                                                  validityType: data
                                                      .bundle!
                                                      .validityType!
                                                      .toString(),
                                                  sellingPrice: data
                                                      .bundle!
                                                      .sellingPrice
                                                      .toString(),
                                                  orderID: data.id!.toString(),
                                                  resellerName:
                                                      dashboardController
                                                          .alldashboardData
                                                          .value
                                                          .data!
                                                          .userInfo!
                                                          .contactName
                                                          .toString(),
                                                  resellerPhone:
                                                      dashboardController
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
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: data.status.toString() == "0"
                                                ? Color(0xffFFC107)
                                                : data.status.toString() == "1"
                                                ? Colors.green
                                                : Color(0xffFF4842),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    data.status.toString() ==
                                                        "0"
                                                    ? Color(0xffFFC107)
                                                    : data.status.toString() ==
                                                          "1"
                                                    ? Colors.green
                                                    : Color(0xffFF4842),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 8,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    NText(
                                                      text:
                                                          "${languagesController.tr("ORDER_ID")} (# ${data.id})",
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          screenHeight * 0.020,
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
                                                    NText(
                                                      text:
                                                          DateFormat(
                                                            'dd MMM yyyy',
                                                          ).format(
                                                            DateTime.parse(
                                                              data.createdAt
                                                                  .toString(),
                                                            ),
                                                          ),
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize:
                                                          screenHeight * 0.020,
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                    10,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    10,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 5),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Obx(
                                                          () => Text(
                                                            languagesController.tr(
                                                              "RECHARGEABLE_ACCOUNT",
                                                            ),
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
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
                                                        Expanded(
                                                          child: NText(
                                                            text: data
                                                                .rechargebleAccount
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.end,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                screenHeight *
                                                                0.018,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 3),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: Obx(
                                                      () => Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController.tr(
                                                              "TRANSACTION_STATUS",
                                                            ),
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
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
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  data.status
                                                                          .toString() ==
                                                                      "0"
                                                                  ? Colors.grey
                                                                        .withOpacity(
                                                                          0.12,
                                                                        )
                                                                  : data.status
                                                                            .toString() ==
                                                                        "1"
                                                                  ? Colors.green
                                                                        .withOpacity(
                                                                          0.12,
                                                                        )
                                                                  : Colors.red
                                                                        .withOpacity(
                                                                          0.12,
                                                                        ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    6,
                                                                  ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical: 6,
                                                                  ),
                                                              child: Text(
                                                                data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? languagesController.tr(
                                                                        "PENDING",
                                                                      )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? languagesController.tr(
                                                                        "CONFIRMED",
                                                                      )
                                                                    : languagesController.tr(
                                                                        "REJECTED",
                                                                      ),
                                                                style: TextStyle(
                                                                  color:
                                                                      data.status
                                                                              .toString() ==
                                                                          "0"
                                                                      ? Colors
                                                                            .grey
                                                                      : data.status.toString() ==
                                                                            "1"
                                                                      ? Colors
                                                                            .green
                                                                      : Colors
                                                                            .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.015,
                                                                  fontFamily:
                                                                      box.read("language").toString() ==
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
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 3),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              languagesController
                                                                  .tr("BUY"),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                                fontFamily:
                                                                    Get.find<
                                                                          FontController
                                                                        >()
                                                                        .currentFont,
                                                              ),
                                                            ),
                                                            Text(" : "),
                                                            NText(
                                                              text:
                                                                  NumberFormat.currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double.parse(
                                                                      data
                                                                          .bundle!
                                                                          .buyingPrice
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
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
                                                            SizedBox(width: 5),
                                                            Text(
                                                              box.read(
                                                                "currency_code",
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              languagesController
                                                                  .tr("SELL"),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
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
                                                            Text(" : "),
                                                            NText(
                                                              text:
                                                                  NumberFormat.currency(
                                                                    locale:
                                                                        'en_US',
                                                                    symbol: '',
                                                                    decimalDigits:
                                                                        2,
                                                                  ).format(
                                                                    double.parse(
                                                                      data
                                                                          .bundle!
                                                                          .sellingPrice
                                                                          .toString(),
                                                                    ),
                                                                  ),
                                                              color: Colors
                                                                  .grey
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
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
                                                            SizedBox(width: 5),
                                                            Text(
                                                              box.read(
                                                                "currency_code",
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                ],
                                              ),
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

class DetailsDialog extends StatefulWidget {
  DetailsDialog({
    super.key,
    this.status,
    this.bundletitle,
    this.phoneNumber,
    this.sellingPrice,
    this.buyingPrice,
    this.orderId,
    this.imagelink,
    this.date,
    this.contactname,
  });

  String? status;
  String? bundletitle;
  String? phoneNumber;
  String? sellingPrice;
  String? buyingPrice;
  String? orderId;
  String? imagelink;
  String? date;
  String? contactname;

  @override
  State<DetailsDialog> createState() => _DetailsDialogState();
}

class _DetailsDialogState extends State<DetailsDialog> {
  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  bool showSelling = false;
  bool showBuying = false;
  final GlobalKey captureKey = GlobalKey();
  final GlobalKey shareKey = GlobalKey();

  Color get statusColor {
    if (widget.status.toString() == "0") return Color(0xffFFA726);
    if (widget.status.toString() == "1") return Color(0xff43A047);
    return Color(0xffE53935);
  }

  Color get statusBgColor {
    if (widget.status.toString() == "0") return Color(0xffFFF8E1);
    if (widget.status.toString() == "1") return Color(0xffF1F8F4);
    return Color(0xffFFF5F5);
  }

  String get statusText {
    if (widget.status.toString() == "0")
      return languagesController.tr("PENDING");
    if (widget.status.toString() == "1")
      return languagesController.tr("CONFIRMED");
    return languagesController.tr("REJECTED");
  }

  String get statusIcon {
    if (widget.status.toString() == "0") return "assets/icons/pending.png";
    if (widget.status.toString() == "1") return "assets/icons/successful.png";
    return "assets/icons/rejected.png";
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Capturable Content
                  RepaintBoundary(
                    key: captureKey,
                    child: RepaintBoundary(
                      key: shareKey,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Status Header
                            Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: statusBgColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          "assets/icons/logo.png",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.asset(
                                      statusIcon,
                                      height: 32,
                                      width: 32,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      fontFamily:
                                          box.read("language").toString() ==
                                              "Fa"
                                          ? Get.find<FontController>()
                                                .currentFont
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Order Details
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  _buildDetailRow(
                                    languagesController.tr("BUNDLE_TITLE"),
                                    widget.bundletitle.toString(),
                                  ),
                                  SizedBox(height: 14),
                                  _buildDetailRow(
                                    languagesController.tr("PHONENUMBER"),
                                    widget.phoneNumber.toString(),
                                  ),
                                  if (showSelling) ...[
                                    SizedBox(height: 14),
                                    _buildPriceRow(
                                      languagesController.tr("SELLING_PRICE"),
                                      widget.sellingPrice.toString(),
                                    ),
                                  ],
                                  if (showBuying) ...[
                                    SizedBox(height: 14),
                                    _buildPriceRow(
                                      languagesController.tr("BUYING_PRICE"),
                                      widget.buyingPrice.toString(),
                                    ),
                                  ],
                                  SizedBox(height: 14),
                                  _buildDetailRow(
                                    languagesController.tr("ORDER_ID"),
                                    widget.orderId.toString(),
                                  ),
                                  SizedBox(height: 20),

                                  // Contact Name Badge
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.person_outline,
                                          size: 18,
                                          color: Colors.grey.shade700,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          widget.contactname.toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w600,
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
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 16),

                                  // Date Time Card
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: statusBgColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: statusColor.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Image.network(
                                            widget.imagelink.toString(),
                                            height: 40,
                                            width: 40,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Icon(
                                                    Icons.image,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  );
                                                },
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
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
                                                      "DATE",
                                                    ),
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                    convertToDate(
                                                      widget.date.toString(),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.grey.shade800,
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
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    languagesController.tr(
                                                      "TIME",
                                                    ),
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                    convertToLocalTime(
                                                      widget.date.toString(),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.grey.shade800,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 0),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            capturePng(captureKey);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 2,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.download_rounded,
                                  color: AppColors.primaryColor,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  languagesController.tr("SAVE"),
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    fontFamily:
                                        box.read("language").toString() == "Fa"
                                        ? Get.find<FontController>().currentFont
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            captureImageFromWidgetAsFile(shareKey);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.share_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  languagesController.tr("SHARE"),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    fontFamily:
                                        box.read("language").toString() == "Fa"
                                        ? Get.find<FontController>().currentFont
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Price Visibility Toggles
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showBuying = !showBuying;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: showBuying
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    showBuying
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    size: 18,
                                    color: showBuying
                                        ? Colors.blue.shade700
                                        : Colors.grey.shade600,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    languagesController.tr("BUYING"),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: showBuying
                                          ? Colors.blue.shade700
                                          : Colors.grey.shade600,
                                      fontFamily:
                                          box.read("language").toString() ==
                                              "Fa"
                                          ? Get.find<FontController>()
                                                .currentFont
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showSelling = !showSelling;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: showSelling
                                    ? Colors.green.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    showSelling
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    size: 18,
                                    color: showSelling
                                        ? Colors.green.shade700
                                        : Colors.grey.shade600,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    languagesController.tr("SELLING"),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: showSelling
                                          ? Colors.green.shade700
                                          : Colors.grey.shade600,
                                      fontFamily:
                                          box.read("language").toString() ==
                                              "Fa"
                                          ? Get.find<FontController>()
                                                .currentFont
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            fontFamily: box.read("language").toString() == "Fa"
                ? Get.find<FontController>().currentFont
                : null,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
              fontFamily: box.read("language").toString() == "Fa"
                  ? Get.find<FontController>().currentFont
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
              fontFamily: box.read("language").toString() == "Fa"
                  ? Get.find<FontController>().currentFont
                  : null,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                ),
              ),
              SizedBox(width: 6),
              Text(
                box.read("currency_code"),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
