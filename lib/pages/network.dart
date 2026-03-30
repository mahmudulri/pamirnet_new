import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/controllers/change_status_controller.dart';
import 'package:pamirnet/controllers/delete_sub_resellercontroller.dart';
import 'package:pamirnet/controllers/subreseller_details_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/global_controller/page_controller.dart';
import 'package:pamirnet/screens/add_new_user.dart';
import 'package:pamirnet/screens/change_balance.dart';
import 'package:pamirnet/screens/set_password.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:pamirnet/widgets/ktext.dart';

import '../controllers/commission_group_controller.dart';
import '../controllers/set_commission_group_controller.dart';
import '../controllers/sub_reseller_controller.dart';
import '../global_controller/font_controller.dart';
import '../models/commision_group_model.dart';
import '../screens/set_subreseller_pin.dart';

class Network extends StatefulWidget {
  const Network({super.key});

  @override
  State<Network> createState() => _NetworkState();
}

final Mypagecontroller mypagecontroller = Get.find();

final subresellercontroller = Get.find<SubresellerController>();
LanguagesController languagesController = Get.put(LanguagesController());
final detailsController = Get.find<SubresellerDetailsController>();

final DeleteSubResellerController deleteSubResellerController = Get.put(
  DeleteSubResellerController(),
);

final ChangeStatusController changeStatusController = Get.put(
  ChangeStatusController(),
);

SetCommissionGroupController controller = Get.put(
  SetCommissionGroupController(),
);

final commissionlistController = Get.find<CommissionGroupController>();

class _NetworkState extends State<Network> {
  Set<int> expandedIndices = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subresellercontroller.fetchSubReseller();
  }

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Container(
                height: 130,
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
                            Obx(
                              () => Text(
                                languagesController.tr("NETWORK"),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenHeight * 0.022,
                                  fontFamily:
                                      Get.find<FontController>().currentFont,
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
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: screenWidth,
                        child: Obx(
                          () => Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: languagesController.tr(
                                          "SEARCH",
                                        ),
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: screenHeight * 0.020,
                                          fontFamily: Get.find<FontController>()
                                              .currentFont,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    mypagecontroller.changePage(
                                      AddNewUser(),
                                      isMainPage: false,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add, color: Colors.white),
                                          SizedBox(width: 5),
                                          Text(
                                            languagesController.tr("ADD_USER"),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: screenHeight * 0.015,
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
              Expanded(
                child: Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 2, color: Colors.white),
                      right: BorderSide(width: 1, color: Colors.white),
                      left: BorderSide(width: 1, color: Colors.white),
                    ),

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Obx(
                      () => subresellercontroller.isLoading.value == false
                          ? ListView.separated(
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 8);
                              },
                              itemCount: subresellercontroller
                                  .allsubresellerData
                                  .value
                                  .data!
                                  .resellers
                                  .length,
                              itemBuilder: (context, index) {
                                final data = subresellercontroller
                                    .allsubresellerData
                                    .value
                                    .data!
                                    .resellers[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.30),
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.white.withOpacity(0.20),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                          0.2,
                                        ), // Color of the shadow
                                        spreadRadius:
                                            4, // How much the shadow spreads
                                        blurRadius:
                                            5, // The blur radius of the shadow
                                        offset: Offset(
                                          0,
                                          2,
                                        ), // The offset of the shadow
                                      ),
                                    ],
                                  ),
                                  child: ExpansionTile(
                                    onExpansionChanged: (isExpanded) {
                                      setState(() {
                                        if (isExpanded) {
                                          expandedIndices.add(
                                            index,
                                          ); // Add the expanded index

                                          detailsController
                                              .fetchSubResellerDetails(
                                                data.id.toString(),
                                              );
                                        } else {
                                          expandedIndices.remove(
                                            index,
                                          ); // Remove the collapsed index
                                        }
                                      });
                                    },
                                    title: Row(
                                      children: [
                                        data.profileImageUrl != null
                                            ? Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      data.profileImageUrl
                                                          .toString(),
                                                    ),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                              )
                                            : Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Icon(Icons.person),
                                                ),
                                              ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.contactName.toString(),
                                              style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontSize: screenHeight * 0.020,
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
                                            SizedBox(height: 3),
                                            Text(
                                              data.phone.toString(),
                                              style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontSize: screenHeight * 0.020,
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
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            expandedIndices.contains(index)
                                                ? "assets/icons/visible.png"
                                                : "assets/icons/invisible.png",
                                            height: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    tilePadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              contentPadding: EdgeInsets.all(0),
                                              content: Container(
                                                height: 400,
                                                width: screenWidth,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    15.0,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          mypagecontroller
                                                              .changePage(
                                                                ChangeBalance(
                                                                  subID: data.id
                                                                      .toString(),
                                                                ),
                                                                isMainPage:
                                                                    false,
                                                              );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/icons/usdicon.png",
                                                              height: 30,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              languagesController.tr(
                                                                "CHANGE_BALANCE",
                                                              ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.020,
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
                                                      ),
                                                      SizedBox(height: 25),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            backgroundColor:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.vertical(
                                                                    top:
                                                                        Radius.circular(
                                                                          20,
                                                                        ),
                                                                  ),
                                                            ),
                                                            builder: (context) {
                                                              return Obx(() {
                                                                if (commissionlistController
                                                                    .isLoading
                                                                    .value) {
                                                                  return Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  );
                                                                }

                                                                final groups =
                                                                    commissionlistController
                                                                        .allgrouplist
                                                                        .value
                                                                        .data
                                                                        ?.groups ??
                                                                    [];

                                                                return ListView.builder(
                                                                  itemCount:
                                                                      groups
                                                                          .length,
                                                                  itemBuilder:
                                                                      (
                                                                        context,
                                                                        index,
                                                                      ) {
                                                                        final group =
                                                                            groups[index];
                                                                        return ListTile(
                                                                          title: Text(
                                                                            group.groupName ??
                                                                                '',
                                                                          ),
                                                                          subtitle: Text(
                                                                            "${group.amount} ${group.commissionType == 'percentage' ? '%' : ''}",
                                                                          ),
                                                                          trailing:
                                                                              data.subResellerCommissionGroupId.toString() ==
                                                                                  group.id.toString()
                                                                              ? Icon(
                                                                                  Icons.check,
                                                                                  color: Colors.green,
                                                                                )
                                                                              : null,
                                                                          onTap: () async {
                                                                            Navigator.pop(
                                                                              context,
                                                                            ); // বন্ধ করে দেই BottomSheet
                                                                            await controller.setgroup(
                                                                              data.id.toString(),
                                                                              group.id.toString(),
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                );
                                                              });
                                                            },
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/icons/discount.png",
                                                              height: 30,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              languagesController.tr(
                                                                "SET_COMMISSION_GROUP",
                                                              ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.020,
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
                                                      ),
                                                      SizedBox(height: 25),
                                                      GestureDetector(
                                                        onTap: () {
                                                          mypagecontroller
                                                              .changePage(
                                                                SetSubresellerPin(
                                                                  subID: data.id
                                                                      .toString(),
                                                                ),
                                                                isMainPage:
                                                                    false,
                                                              );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/icons/key.png",
                                                              height: 30,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              languagesController
                                                                  .tr(
                                                                    "SET_PIN",
                                                                  ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.020,
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
                                                      ),
                                                      SizedBox(height: 25),
                                                      GestureDetector(
                                                        onTap: () {
                                                          mypagecontroller
                                                              .changePage(
                                                                SetPassword(
                                                                  subID: data.id
                                                                      .toString(),
                                                                ),
                                                                isMainPage:
                                                                    false,
                                                              );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/icons/padlock.png",
                                                              height: 30,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              languagesController
                                                                  .tr(
                                                                    "SET_PASSWORD",
                                                                  ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.020,
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
                                                      ),
                                                      SizedBox(height: 25),
                                                      GestureDetector(
                                                        onTap: () {
                                                          changeStatusController
                                                              .channgestatus(
                                                                data.id
                                                                    .toString(),
                                                              );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              data.status.toString() ==
                                                                      "1"
                                                                  ? "assets/icons/pause.png"
                                                                  : "assets/icons/active.png",
                                                              height: 30,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              data.status
                                                                          .toString() ==
                                                                      "1"
                                                                  ? languagesController.tr(
                                                                      "DEACTIVE",
                                                                    )
                                                                  : languagesController
                                                                        .tr(
                                                                          "ACTIVE",
                                                                        ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.020,
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
                                                      ),
                                                      SizedBox(height: 25),
                                                      GestureDetector(
                                                        onTap: () {
                                                          deleteSubResellerController
                                                              .deletesub(
                                                                data.id
                                                                    .toString(),
                                                              );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/icons/delete.png",
                                                              height: 30,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              languagesController
                                                                  .tr("DELETE"),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.020,
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
                                                      ),
                                                      Spacer(),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: Container(
                                                          height:
                                                              screenHeight *
                                                              0.065,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              width: 1,
                                                              color: Colors
                                                                  .grey
                                                                  .shade300,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              languagesController
                                                                  .tr("CLOSE"),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Image.asset(
                                        "assets/icons/edit.png",
                                        height: 25,
                                      ),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        child: Container(
                                          height: 180,
                                          width: screenWidth,
                                          child: Obx(
                                            () =>
                                                detailsController
                                                        .isLoading
                                                        .value ==
                                                    false
                                                ? Column(
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                // color: Colors.red,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      languagesController.tr(
                                                                        "TODAY_ORDER",
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
                                                                        fontSize:
                                                                            box.read(
                                                                                  "language",
                                                                                ) ==
                                                                                "Fa"
                                                                            ? 11
                                                                            : 14,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors
                                                                            .secondaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              3,
                                                                            ),
                                                                      ),
                                                                      child: Center(
                                                                        child: Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                8,
                                                                          ),
                                                                          child: Text(
                                                                            detailsController.allsubresellerDetailsData.value.data!.reseller!.todayOrders
                                                                                    .toString() +
                                                                                "  " +
                                                                                box.read(
                                                                                  "currency_code",
                                                                                ),
                                                                            style: TextStyle(
                                                                              fontSize: 12,
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
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      languagesController.tr(
                                                                        "TOTAL_ORDER",
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
                                                                        fontSize:
                                                                            box.read(
                                                                                  "language",
                                                                                ) ==
                                                                                "Fa"
                                                                            ? 11
                                                                            : 14,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors
                                                                            .secondaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              3,
                                                                            ),
                                                                      ),
                                                                      child: Center(
                                                                        child: Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                8,
                                                                          ),
                                                                          child: Text(
                                                                            detailsController.allsubresellerDetailsData.value.data!.reseller!.totalOrders
                                                                                    .toString() +
                                                                                "  " +
                                                                                box.read(
                                                                                  "currency_code",
                                                                                ),
                                                                            style: TextStyle(
                                                                              fontSize: 12,
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
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                // color: Colors.red,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      languagesController.tr(
                                                                        "TOTAL_SALE",
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
                                                                        fontSize:
                                                                            box.read(
                                                                                  "language",
                                                                                ) ==
                                                                                "Fa"
                                                                            ? 11
                                                                            : 14,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors
                                                                            .secondaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              3,
                                                                            ),
                                                                      ),
                                                                      child: Center(
                                                                        child: Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                8,
                                                                          ),
                                                                          child: Text(
                                                                            detailsController.allsubresellerDetailsData.value.data!.reseller!.totalSale
                                                                                    .toString() +
                                                                                "  " +
                                                                                box.read(
                                                                                  "currency_code",
                                                                                ),
                                                                            style: TextStyle(
                                                                              fontSize: 12,
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
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      languagesController.tr(
                                                                        "TOTAL_PROFIT",
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
                                                                        fontSize:
                                                                            box.read(
                                                                                  "language",
                                                                                ) ==
                                                                                "Fa"
                                                                            ? 11
                                                                            : 14,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors
                                                                            .secondaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              3,
                                                                            ),
                                                                      ),
                                                                      child: Center(
                                                                        child: Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                8,
                                                                          ),
                                                                          child: Text(
                                                                            detailsController.allsubresellerDetailsData.value.data!.reseller!.totalProfit
                                                                                    .toString() +
                                                                                "  " +
                                                                                box.read(
                                                                                  "currency_code",
                                                                                ),
                                                                            style: TextStyle(
                                                                              fontSize: 12,
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
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Container(
                                                                // color: Colors.red,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      languagesController.tr(
                                                                        "TODAY_SALE",
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
                                                                        fontSize:
                                                                            box.read(
                                                                                  "language",
                                                                                ) ==
                                                                                "Fa"
                                                                            ? 11
                                                                            : 14,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors
                                                                            .secondaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              3,
                                                                            ),
                                                                      ),
                                                                      child: Center(
                                                                        child: Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                8,
                                                                          ),
                                                                          child: Text(
                                                                            detailsController.allsubresellerDetailsData.value.data!.reseller!.todaySale
                                                                                    .toString() +
                                                                                "  " +
                                                                                box.read(
                                                                                  "currency_code",
                                                                                ),
                                                                            style: TextStyle(
                                                                              fontSize: 12,
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
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      languagesController.tr(
                                                                        "TODAY_PROFIT",
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
                                                                        fontSize:
                                                                            box.read(
                                                                                  "language",
                                                                                ) ==
                                                                                "Fa"
                                                                            ? 11
                                                                            : 14,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppColors
                                                                            .secondaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              3,
                                                                            ),
                                                                      ),
                                                                      child: Center(
                                                                        child: Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                8,
                                                                          ),
                                                                          child: Text(
                                                                            detailsController.allsubresellerDetailsData.value.data!.reseller!.todayProfit
                                                                                    .toString() +
                                                                                "  " +
                                                                                box.read(
                                                                                  "currency_code",
                                                                                ),
                                                                            style: TextStyle(
                                                                              fontSize: 12,
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
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          KText(
                                                            text: languagesController.tr(
                                                              "COMMISSION_GROUP",
                                                            ),
                                                          ),
                                                          KText(
                                                            text: commissionlistController
                                                                .allgrouplist
                                                                .value
                                                                .data!
                                                                .groups!
                                                                .firstWhere(
                                                                  (group) =>
                                                                      group.id
                                                                          .toString() ==
                                                                      data.subResellerCommissionGroupId
                                                                          .toString(),
                                                                  orElse: () => Group(
                                                                    groupName:
                                                                        "Not Found",
                                                                  ), // fallback if not found
                                                                )
                                                                .groupName
                                                                .toString(),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      Container(
                                                        height: 40,
                                                        width: screenWidth,
                                                        decoration: BoxDecoration(
                                                          color: AppColors
                                                              .secondaryColor,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                              ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                languagesController.tr(
                                                                  "ACCOUNT_BALANCE",
                                                                ),
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.020,
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
                                                              Text(
                                                                detailsController
                                                                        .allsubresellerDetailsData
                                                                        .value
                                                                        .data!
                                                                        .reseller!
                                                                        .balance
                                                                        .toString() +
                                                                    " " +
                                                                    box.read(
                                                                      "currency_code",
                                                                    ),
                                                                style: TextStyle(
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
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(child: CircularProgressIndicator()),
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
