import 'dart:io';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pamirnet/helpers/capture_image_helper.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import '../controllers/dashboard_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/time_zone_controller.dart';
import '../helpers/localtime_helper.dart';
import '../helpers/share_image_helper.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderDetailsScreen({
    super.key,
    this.createDate,
    this.status,
    this.rejectReason,
    this.companyName,
    this.bundleTitle,
    this.rechargebleAccount,
    this.validityType,
    this.sellingPrice,
    this.orderID,
    this.resellerName,
    this.resellerPhone,
    this.companyLogo,
  });
  String? createDate;
  String? status;
  String? rejectReason;
  String? companyName;
  String? bundleTitle;
  String? rechargebleAccount;
  String? validityType;
  String? sellingPrice;
  String? orderID;
  String? resellerName;
  String? resellerPhone;
  String? companyLogo;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final DashboardController dashboardController = Get.put(
    DashboardController(),
  );

  LanguagesController languagesController = Get.put(LanguagesController());

  final box = GetStorage();
  final TimeZoneController timeZoneController = Get.put(TimeZoneController());

  GlobalKey catpureKey = GlobalKey();

  final GlobalKey shareKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              RepaintBoundary(
                key: catpureKey,
                child: RepaintBoundary(
                  key: shareKey,
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          height: 55,
                                          width: 55,
                                          decoration: BoxDecoration(
                                            // border: Border.all(
                                            //   width: 2,
                                            //   color: Colors.black.withOpacity(0.2),
                                            // ),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                "assets/icons/logo.png",
                                              ),
                                            ),
                                            // color: Colors.red,
                                          ),
                                        ),
                                        Text(
                                          "Pamir Net",
                                          style: GoogleFonts.aBeeZee(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                convertToLocalTime(
                                  widget.createDate.toString(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      languagesController.tr("ORDER_STATUS"),
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      widget.status.toString() == "0"
                                          ? languagesController.tr("PENDING")
                                          : widget.status.toString() == "1"
                                          ? languagesController.tr("CONFIRMED")
                                          : languagesController.tr("REJECTED"),
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                        color: widget.status.toString() == "0"
                                            ? Colors.grey
                                            : widget.status.toString() == "1"
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Visibility(
                                  visible: widget.status.toString() == "2",
                                  child: Text(
                                    widget.rejectReason.toString(),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Container(
                                  height: 1,
                                  color: AppColors.primaryColor.withOpacity(
                                    0.5,
                                  ),
                                  width: screenWidth,
                                ),
                                SizedBox(height: 5),
                                Container(
                                  // color: Colors.red,
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        languagesController.tr("NETWORK_TYPE"),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        widget.companyName.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                dotline(),
                                Visibility(
                                  visible: widget.bundleTitle.toString() != "",
                                  child: Container(
                                    // color: Colors.cyan,
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr("BUNDLE_TYPE"),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          widget.bundleTitle.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                dotline(),
                                Container(
                                  // color: Colors.red,
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        languagesController.tr("PHONE_NUMBER"),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        widget.rechargebleAccount.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                dotline(),
                                Visibility(
                                  visible: widget.validityType.toString() != "",
                                  child: Container(
                                    // color: Colors.yellow,
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr(
                                            "VALIDITY_TYPE",
                                          ),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          widget.validityType.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                dotline(),
                                Container(
                                  // color: Colors.cyanAccent,
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        languagesController.tr("SELLING_PRICE"),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            box.read("currency_code"),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            NumberFormat.currency(
                                              locale: 'en_US',
                                              symbol: '',
                                              decimalDigits: 2,
                                            ).format(
                                              double.parse(
                                                widget.sellingPrice.toString(),
                                              ),
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                dotline(),
                                Container(
                                  // color: Colors.blue,
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        languagesController.tr("ORDER_ID"),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "PN#- " + widget.orderID.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 1,
                                  color: AppColors.primaryColor.withOpacity(
                                    0.5,
                                  ),
                                  width: screenWidth,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.resellerName.toString(),
                                style: GoogleFonts.oswald(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                widget.resellerPhone.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Container(
                            height: 95,
                            width: 95,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  widget.companyLogo.toString(),
                                ),
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 50,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                            ),
                            child: Center(
                              child: Text(
                                "Best Telecom and Social Packages provider",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () async {
                          captureImageFromWidgetAsFile(shareKey);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                child: Center(
                                  child: Text(
                                    languagesController.tr("SHARE"),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () async {
                          capturePng(catpureKey);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                child: Center(
                                  child: Text(
                                    languagesController.tr("SAVE"),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                child: Center(
                                  child: Text(
                                    languagesController.tr("CLOSE"),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class dotline extends StatelessWidget {
  const dotline({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedLine(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      lineLength: double.infinity,
      lineThickness: 1.0,
      dashLength: 4.0,
      dashColor: AppColors.primaryColor.withOpacity(0.3),
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.white,
      dashGapRadius: 0.0,
    );
  }
}
