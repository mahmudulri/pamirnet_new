import 'dart:async';
import 'dart:io';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pamirnet/controllers/currency_controller.dart';
import 'package:pamirnet/controllers/dashboard_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/global_controller/page_controller.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:pamirnet/widgets/drawer.dart';
import 'package:pamirnet/widgets/ktext.dart';
import '../controllers/categories_controller.dart';
import '../controllers/order_list_controller.dart';
import '../global_controller/conversation_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/service_controller.dart';

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

  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());

  bool isNotificationOpen = false;
  final GlobalKey notificationKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    serviceController.fetchservices();
    dashboardController.fetchDashboardData();
  }

  CategorisListController categorisListController = Get.put(
    CategorisListController(),
  );

  OrderlistController orderlistController = Get.put(OrderlistController());

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

    setState(() {});
    return false;
  }

  final box = GetStorage();
  LanguagesController languagesController = Get.put(LanguagesController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final _controller = NotchBottomBarController();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: showExitPopup,
      child: SafeArea(
        top: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          drawer: DrawerWidget(),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 65,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: AppColors.primaryGradient),
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
                              () => dashboardController.isLoading.value == false
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
                                              box.read("language").toString() ==
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
                                      color: AppColors.primaryColor.withOpacity(
                                        0.50,
                                      ),
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

          /// BODY
          body: SafeArea(
            child: SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: Obx(() {
                return mypagecontroller.pageStack.last;
              }),
            ),
          ),

          /// BOTTOM NAV
          bottomNavigationBar: Container(
            height: 95,
            child: AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: AppColors.primaryColor,
              notchColor: AppColors.primaryColor,
              showLabel: true,
              removeMargins: false,
              durationInMilliSeconds: 300,

              bottomBarItems: [
                BottomBarItem(
                  inActiveItem: Image.asset("assets/icons/home.png"),
                  activeItem: Image.asset("assets/icons/home.png"),
                  itemLabelWidget: Obx(
                    () => Text(
                      languagesController.tr("HOME"),
                      style: const TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),

                BottomBarItem(
                  inActiveItem: Image.asset("assets/icons/menulogo.png"),
                  activeItem: Image.asset("assets/icons/menulogo.png"),
                  itemLabelWidget: Obx(
                    () => Text(
                      languagesController.tr("PRODUCTS"),
                      style: const TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),

                BottomBarItem(
                  inActiveItem: Image.asset("assets/icons/orders.png"),
                  activeItem: Image.asset("assets/icons/orders.png"),
                  itemLabelWidget: Obx(
                    () => Text(
                      languagesController.tr("ORDERS"),
                      style: const TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),

                BottomBarItem(
                  inActiveItem: Image.asset("assets/icons/transactions.png"),
                  activeItem: Image.asset("assets/icons/transactions.png"),
                  itemLabelWidget: Obx(
                    () => Text(
                      languagesController.tr("TRANSACTIONS"),
                      style: const TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
              ],

              /// 🔥 IMPORTANT FIX
              onTap: (index) {
                mypagecontroller.changePage(mypagecontroller.mainPages[index]);
              },

              kIconSize: 20,
              kBottomRadius: 20,
            ),
          ),
        ),
      ),
    );
  }
}
