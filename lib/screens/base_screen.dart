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
import 'package:pamirnet/pages/notification_details_page.dart';
import 'package:pamirnet/screens/all_notifications_page.dart';
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

  final CurrencyController currrencyController = Get.put(CurrencyController());

  final ConversationController conversationController = Get.put(
    ConversationController(),
  );

  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());

  bool isNotificationOpen = false;
  final GlobalKey notificationKey = GlobalKey();

  int currentBottomIndex = 0;

  Widget _buildBottomLabel(String text, int index) {
    final bool isActive = currentBottomIndex == index;
    final double labelWidth = isActive ? 96 : 118;

    return SizedBox(
      height: 18,
      child: OverflowBox(
        minWidth: 0,
        maxWidth: labelWidth,
        minHeight: 18,
        maxHeight: 18,
        alignment: Alignment.center,
        child: SizedBox(
          width: labelWidth,
          height: 18,
          child: Text(
            text,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    notificationController.fetchData();

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

  NotificationController notificationController = Get.put(
    NotificationController(),
  );

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

                            Obx(() {
                              final unreadCount =
                                  notificationController.unreadlength.value;

                              return GestureDetector(
                                onTap: () {
                                  showNotificationPopup(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      const Icon(
                                        Icons.notifications_outlined,
                                        color: Colors.white,
                                        size: 29,
                                      ),

                                      if (unreadCount > 0)
                                        Positioned(
                                          right: -7,
                                          top: -7,
                                          child: Container(
                                            constraints: const BoxConstraints(
                                              minWidth: 19,
                                              minHeight: 19,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.5,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              unreadCount > 99
                                                  ? '99+'
                                                  : unreadCount.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),

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
                    () => _buildBottomLabel(languagesController.tr("HOME"), 0),
                  ),
                ),

                BottomBarItem(
                  inActiveItem: Image.asset("assets/icons/menulogo.png"),
                  activeItem: Image.asset("assets/icons/menulogo.png"),
                  itemLabelWidget: Obx(
                    () => _buildBottomLabel(
                      languagesController.tr("PRODUCTS"),
                      1,
                    ),
                  ),
                ),

                BottomBarItem(
                  inActiveItem: Image.asset("assets/icons/orders.png"),
                  activeItem: Image.asset("assets/icons/orders.png"),
                  itemLabelWidget: Obx(
                    () =>
                        _buildBottomLabel(languagesController.tr("ORDERS"), 2),
                  ),
                ),

                BottomBarItem(
                  inActiveItem: Image.asset("assets/icons/transactions.png"),
                  activeItem: Image.asset("assets/icons/transactions.png"),
                  itemLabelWidget: Obx(
                    () => _buildBottomLabel(
                      languagesController.tr("TRANSACTIONS"),
                      3,
                    ),
                  ),
                ),
              ],

              onTap: (index) {
                setState(() {
                  currentBottomIndex = index;
                });

                mypagecontroller.changePage(mypagecontroller.mainPages[index]);
              },

              kIconSize: 25,
              kBottomRadius: 20,
            ),
          ),
        ),
      ),
    );
  }

  void showNotificationPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (context) {
        return Dialog(
          alignment: Alignment.topRight,
          insetPadding: const EdgeInsets.only(
            top: 70,
            right: 15,
            left: 25,
            bottom: 30,
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(maxHeight: 480),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Obx(() {
              final isLoading = notificationController.isLoading.value;

              final notifications =
                  notificationController
                      .allnotificationlist
                      .value
                      .data
                      ?.notifications ??
                  [];

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 12, 12),
                    child: Row(
                      children: [
                        Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.primaryColor,
                            size: 23,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            languagesController.tr("NOTIFICATIONS"),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

                  if (isLoading)
                    const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (notifications.isEmpty)
                    SizedBox(
                      height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 55,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            languagesController.tr("NO_NOTIFICATIONS"),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,

                        // Popup-এ শুধু latest 10 notifications দেখাবে
                        itemCount: notifications.length > 10
                            ? 10
                            : notifications.length,

                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            color: Colors.grey.shade200,
                          );
                        },

                        itemBuilder: (context, index) {
                          final notification = notifications[index];

                          return InkWell(
                            onTap: () async {
                              Get.back();

                              await Get.to(
                                () => NotificationDetailsPage(
                                  notification: notification,
                                ),
                              );

                              await notificationController.fetchData();
                            },
                            child: Container(
                              color: notification.isRead == false
                                  ? AppColors.primaryColor.withOpacity(0.05)
                                  : Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 13,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 43,
                                        width: 43,
                                        decoration: BoxDecoration(
                                          color: notification.isRead == false
                                              ? AppColors.primaryColor
                                                    .withOpacity(0.13)
                                              : Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.notifications_rounded,
                                          size: 21,
                                          color: notification.isRead == false
                                              ? AppColors.primaryColor
                                              : Colors.grey,
                                        ),
                                      ),

                                      if (notification.isRead == false)
                                        Positioned(
                                          right: 1,
                                          top: 1,
                                          child: Container(
                                            height: 9,
                                            width: 9,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification.title ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                                notification.isRead == false
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          notification.message ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            height: 1.4,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          notification.createdAt == null
                                              ? ""
                                              : DateFormat(
                                                  "dd MMM yyyy, hh:mm a",
                                                ).format(
                                                  notification.createdAt!
                                                      .toLocal(),
                                                ),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
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

                  Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          Get.back();

                          await Get.to(() => const AllNotificationsPage());

                          await notificationController.fetchData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          languagesController.tr("VIEW_ALL"),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
