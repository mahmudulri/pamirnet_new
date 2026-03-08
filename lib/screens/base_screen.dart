import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pamirnet/controllers/currency_controller.dart';
import 'package:pamirnet/controllers/dashboard_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/global_controller/page_controller.dart';
import 'package:pamirnet/pages/homepages.dart';
import 'package:pamirnet/pages/network.dart';
import 'package:pamirnet/pages/orders.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:pamirnet/widgets/drawer.dart';
import 'package:pamirnet/widgets/ktext.dart';
import 'package:badges/badges.dart' as badges;
import '../controllers/categories_controller.dart';
import '../global_controller/conversation_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/service_controller.dart';
import '../global_controller/font_controller.dart';
import '../helpers/persian_date_helper.dart';
import '../models/currency_model.dart';
import '../pages/transaction_type.dart';
import '../pages/transactions.dart';
import 'notification_screen.dart';
import 'product_screen.dart';

class NewBaseScreen extends StatefulWidget {
  NewBaseScreen({super.key});

  @override
  State<NewBaseScreen> createState() => _NewBaseScreenState();
}

class _NewBaseScreenState extends State<NewBaseScreen> {
  final dashboardController = Get.find<DashboardController>();

  final notificationController = Get.find<NotificationController>();

  final CurrencyController currrencyController = Get.put(CurrencyController());

  final ConversationController conversationController = Get.put(
    ConversationController(),
  );

  int _selectedIndex = 0;
  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final ValueNotifier<String> _timeNotifier = ValueNotifier(
    PersianDateHelper.currentTime(),
  );

  late Timer _timer;

  bool isNotificationOpen = false;
  final GlobalKey notificationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _timeNotifier.value = PersianDateHelper.currentTime();
    });
    serviceController.fetchservices();
    dashboardController.fetchDashboardData();
    mypagecontroller.setUpdateIndexCallback(_onItemTapped);
  }

  @override
  void dispose() {
    _timer.cancel();
    _timeNotifier.dispose();
    super.dispose();
  }

  CategorisListController categorisListController = Get.put(
    CategorisListController(),
  );
  final serviceController = Get.find<ServiceController>();

  Future<bool> showExitPopup() async {
    final shouldExit = mypagecontroller.goBack();
    if (shouldExit) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(languagesController.tr("EXIT_APP")),
              content: Text(languagesController.tr("DO_YOU_WANT_TO_EXIT_APP")),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(languagesController.tr("NO")),
                ),
                ElevatedButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: Text(languagesController.tr("YES")),
                ),
              ],
            ),
          ) ??
          false;
    }
    setState(() {}); // Rebuild screen after popping
    return false;
  }

  final box = GetStorage();
  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: DrawerWidget(),
        appBar: mypagecontroller.isHomeRoot
            ? AppBar(
                backgroundColor: Colors.transparent,
                toolbarHeight: 130,
                automaticallyImplyLeading: false,
                elevation: 0.0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 12, right: 12, top: 5),
                      child: GestureDetector(
                        onTap: () {
                          notificationController.fetchData();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppColors.primaryColor,
                            border: Border.all(
                              width: 2,
                              color: Colors.white.withOpacity(0.60),
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,

                                    child: Container(
                                      // color: Colors.red,
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _scaffoldKey.currentState
                                                      ?.openDrawer();
                                                },
                                                child: Icon(
                                                  Icons.menu,
                                                  color: Colors.white,
                                                  size: screenHeight * 0.033,
                                                ),
                                              ),
                                              SizedBox(width: 4),

                                              SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () {
                                                  dashboardController
                                                      .fetchDashboardData();
                                                },
                                                child: Icon(
                                                  FontAwesomeIcons.refresh,
                                                  color: Colors.white,
                                                  size: screenHeight * 0.0230,
                                                ),
                                              ),
                                            ],
                                          ),

                                          Spacer(),

                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              ValueListenableBuilder<String>(
                                                valueListenable: _timeNotifier,
                                                builder: (context, time, _) {
                                                  return Text(
                                                    time,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      // color: Colors.yellow,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Obx(
                                                () =>
                                                    dashboardController
                                                            .isLoading
                                                            .value ==
                                                        false
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                dashboardController
                                                                    .alldashboardData
                                                                    .value
                                                                    .data!
                                                                    .userInfo!
                                                                    .resellerName
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      MediaQuery.of(
                                                                        context,
                                                                      ).size.height *
                                                                      0.018,
                                                                  fontFamily:
                                                                      box.read("language").toString() ==
                                                                          "Fa"
                                                                      ? "Btitrbold"
                                                                      : null,
                                                                ),
                                                              ),
                                                              Text(
                                                                "کاربر عادی",
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .yellow,
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(width: 8),

                                                          Obx(
                                                            () => Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    2,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                  color: AppColors
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                        0.50,
                                                                      ),
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child:
                                                                  dashboardController
                                                                          .isLoading
                                                                          .value ==
                                                                      false
                                                                  ? CircleAvatar(
                                                                      radius:
                                                                          24,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey,
                                                                      child: ClipOval(
                                                                        child:
                                                                            dashboardController.alldashboardData.value.data!.userInfo!.profileImageUrl !=
                                                                                    null &&
                                                                                dashboardController.alldashboardData.value.data!.userInfo!.profileImageUrl !=
                                                                                    "null"
                                                                            ? Image.network(
                                                                                dashboardController.alldashboardData.value.data!.userInfo!.profileImageUrl!,
                                                                                width: 40,
                                                                                height: 40,
                                                                                fit: BoxFit.cover,
                                                                                errorBuilder:
                                                                                    (
                                                                                      context,
                                                                                      error,
                                                                                      stackTrace,
                                                                                    ) {
                                                                                      // 👇 fallback when 404 / broken image
                                                                                      return Icon(
                                                                                        Icons.person,
                                                                                        color: Colors.white,
                                                                                        size: 24,
                                                                                      );
                                                                                    },
                                                                              )
                                                                            : Icon(
                                                                                Icons.person,
                                                                                color: Colors.white,
                                                                                size: 24,
                                                                              ),
                                                                      ),
                                                                    )
                                                                  : SizedBox(),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : SizedBox(),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Spacer(),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                PersianDateHelper.formatFromDateTime(
                                                  DateTime.now(),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : AppBar(
                backgroundColor: Colors.transparent,
                toolbarHeight: 65,
                automaticallyImplyLeading: false,
                elevation: 0.0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 12, right: 12, top: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white.withOpacity(0.30),
                          border: Border.all(
                            width: 2,
                            color: Colors.white.withOpacity(0.30),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    _scaffoldKey.currentState?.openDrawer();
                                  },
                                  child: Icon(
                                    Icons.menu,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Obx(
                                  () => KText(
                                    text: languagesController.tr("MENU"),
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenHeight * 0.020,
                                    color: AppColors.primaryColor,
                                    // fontFamily: "Btitrbold",
                                  ),
                                ),
                                Spacer(),
                                SizedBox(width: 5),
                                Obx(
                                  () =>
                                      dashboardController.isLoading.value ==
                                          false
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              dashboardController
                                                  .alldashboardData
                                                  .value
                                                  .data!
                                                  .userInfo!
                                                  .resellerName
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.018,
                                                fontFamily:
                                                    box
                                                            .read("language")
                                                            .toString() ==
                                                        "Fa"
                                                    ? "Btitrbold"
                                                    : null,
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  box
                                                          .read("language")
                                                          .toString() ==
                                                      "Fa"
                                                  ? 8
                                                  : 0,
                                            ),
                                            Visibility(
                                              visible:
                                                  dashboardController
                                                          .alldashboardData
                                                          .value
                                                          .data
                                                          ?.resellerGroup !=
                                                      null &&
                                                  dashboardController
                                                          .alldashboardData
                                                          .value
                                                          .data!
                                                          .resellerGroup !=
                                                      "null",
                                              child: Text(
                                                dashboardController
                                                        .alldashboardData
                                                        .value
                                                        .data
                                                        ?.resellerGroup ??
                                                    '',
                                                style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.016,
                                                  fontFamily:
                                                      box
                                                              .read("language")
                                                              .toString() ==
                                                          "Fa"
                                                      ? "Btitrbold"
                                                      : null,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                ),
                                SizedBox(width: 1),
                                Obx(
                                  () => Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.50),
                                          width: 1,
                                        ),
                                      ),
                                      child:
                                          dashboardController.isLoading.value ==
                                              false
                                          ? CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.grey,
                                              child: ClipOval(
                                                child:
                                                    dashboardController
                                                                .alldashboardData
                                                                .value
                                                                .data!
                                                                .userInfo!
                                                                .profileImageUrl !=
                                                            null &&
                                                        dashboardController
                                                                .alldashboardData
                                                                .value
                                                                .data!
                                                                .userInfo!
                                                                .profileImageUrl !=
                                                            "null"
                                                    ? Image.network(
                                                        dashboardController
                                                            .alldashboardData
                                                            .value
                                                            .data!
                                                            .userInfo!
                                                            .profileImageUrl!,
                                                        width: 40,
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) {
                                                              // 👇 fallback when 404 / broken image
                                                              return Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .white,
                                                                size: 24,
                                                              );
                                                            },
                                                      )
                                                    : Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                        size: 24,
                                                      ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

        body: SafeArea(
          child: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE0BCF3), // Left side color
                  Color(0xFF7EE7EE), // Right side color
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Obx(() => mypagecontroller.pageStack.last),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 80,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      border: Border(
                        top: BorderSide(
                          width: 3,
                          color: Colors.white.withOpacity(0.50),
                        ),
                        left: BorderSide(
                          width: 1,
                          color: Colors.white.withOpacity(0.50),
                        ),
                        right: BorderSide(
                          width: 1,
                          color: Colors.white.withOpacity(0.50),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(
                            () => Expanded(
                              flex: 2,
                              child: _menuItem(
                                iconPath: "assets/icons/home.png",
                                label: languagesController.tr("HOME"),
                                index: 0,
                                onpressed: () {
                                  mypagecontroller.changePage(Homepages());
                                },
                              ),
                            ),
                          ),
                          Obx(
                            () => Expanded(
                              flex: 2,
                              child: _menuItem(
                                iconPath: "assets/icons/transactions.png",
                                label: languagesController.tr("TRANSACTIONS"),
                                index: 1,
                                onpressed: () {
                                  mypagecontroller.changePage(Transactions());
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Transform.translate(
                              offset: Offset(0, -0),

                              child: GestureDetector(
                                onTap: () {
                                  categorisListController.fetchcategories();

                                  mypagecontroller.changePage(
                                    NewServiceScreen(),
                                    isMainPage: false,
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // CircleAvatar(
                                    //   backgroundColor: Colors.transparent,
                                    //   radius: 25,
                                    //   backgroundImage: AssetImage(
                                    //     "assets/icons/logo.png",
                                    //   ),
                                    // ),
                                    Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/icons/logo.png",
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Image.asset(
                                    //   "assets/icons/logo.png",
                                    //   height: 48,
                                    // ),
                                    KText(
                                      text: languagesController.tr(
                                        "BUY_PRODUCT",
                                      ),
                                      color: Color(0xff2AE9FC),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(height: 6),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => Expanded(
                              flex: 2,
                              child: _menuItem(
                                iconPath: "assets/icons/orders.png",
                                label: languagesController.tr("ORDERS"),
                                index: 2,
                                onpressed: () {
                                  mypagecontroller.changePage(Orders());
                                },
                              ),
                            ),
                          ),
                          Obx(
                            () => Expanded(
                              flex: 2,
                              child: _menuItem(
                                iconPath: "assets/icons/subreseller.png",
                                label: languagesController.tr("NETWORK"),
                                index: 3,
                                onpressed: () {
                                  mypagecontroller.changePage(Network());
                                },
                              ),
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
        ),
      ),
    );
  }

  Widget _menuItem({
    required String iconPath,
    required String label,
    required int index,
    required VoidCallback onpressed,
  }) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: onpressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(iconPath, height: 28),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w700,
              fontSize: 11,
              fontFamily: Get.find<FontController>().currentFont,
            ),
          ),
          SizedBox(height: 6),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
