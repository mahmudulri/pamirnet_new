import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/controllers/bundle_controller.dart';
import 'package:pamirnet/controllers/confirm_pin_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/helpers/price.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pamirnet/widgets/number_textfield.dart';
import '../controllers/service_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/page_controller.dart';
import '../widgets/animated_card.dart';

class RechargeScreen extends StatefulWidget {
  String? catName;
  final bool enableOperatorLookup;
  RechargeScreen({super.key, this.catName, required this.enableOperatorLookup});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());
  void initializeDuration() {
    duration = [
      {"Name": languagesController.tr("All"), "Value": ""},
      {"Name": languagesController.tr("UNLIMITED"), "Value": "unlimited"},
      {"Name": languagesController.tr("MONTHLY"), "Value": "monthly"},
      {"Name": languagesController.tr("WEEKLY"), "Value": "weekly"},
      {"Name": languagesController.tr("DAILY"), "Value": "daily"},
      {"Name": languagesController.tr("HOURLY"), "Value": "hourly"},
      {"Name": languagesController.tr("NIGHTLY"), "Value": "nightly"},
    ];
  }

  int selectedIndex = -1;
  int duration_selectedIndex = 0;

  List<Map<String, String>> duration = [];

  String search = "";
  String inputNumber = "";
  bool isOperatorLookupConfirmed = false;

  Timer? _lookupDebounce;

  String? originalCompanyId;
  String? detectedCompanyId;

  final box = GetStorage();

  final FocusNode _focusNode = FocusNode();

  final confirmPinController = Get.find<ConfirmPinController>();

  final ScrollController scrollController = ScrollController();

  final serviceController = Get.find<ServiceController>();
  final bundleController = Get.find<BundleController>();

  int get _maximumPhoneLength {
    final dynamic storedLength = box.read("maxlength");

    return int.tryParse(storedLength?.toString() ?? "") ?? 0;
  }

  bool get isOperatorLookupEnabled {
    final dynamic storedValue = box.read("enable_operator_lookup");

    if (storedValue is bool) {
      return storedValue;
    }

    if (storedValue is int) {
      return storedValue == 1;
    }

    final String normalizedValue =
        storedValue?.toString().trim().toLowerCase() ?? "";

    if (normalizedValue == "true" ||
        normalizedValue == "1" ||
        normalizedValue == "yes") {
      return true;
    }

    if (normalizedValue == "false" ||
        normalizedValue == "0" ||
        normalizedValue == "no") {
      return false;
    }

    return widget.enableOperatorLookup;
  }

  Future<void> refresh() async {
    if (bundleController.isLoading.value ||
        bundleController.isLookupLoading.value) {
      return;
    }

    if (!scrollController.hasClients) {
      return;
    }

    final bool reachedBottom =
        scrollController.position.pixels >=
        scrollController.position.maxScrollExtent;

    if (!reachedBottom) return;

    if (isOperatorLookupEnabled) {
      return;
    }

    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination.totalPages ??
        0;

    if (bundleController.initialpage >= totalPages) {
      return;
    }

    bundleController.initialpage++;

    await bundleController.fetchallbundles();
  }

  void _onTextChanged() {
    if (!mounted) return;

    final String number = confirmPinController.numberController.text.trim();

    final int requiredLength = _maximumPhoneLength;

    final services =
        serviceController.allserviceslist.value.data?.services ?? [];

    String? matchedOriginalCompanyId;

    // Prefix অনুযায়ী original operator detect
    for (final service in services) {
      final companyCodes = service.company?.companycodes ?? [];

      for (final code in companyCodes) {
        final String reservedDigit =
            code.reservedDigit?.toString().trim() ?? "";

        if (reservedDigit.isEmpty) {
          continue;
        }

        final String normalizedNumber = number.startsWith("0")
            ? number.substring(1)
            : number;

        final String normalizedReservedDigit = reservedDigit.startsWith("0")
            ? reservedDigit.substring(1)
            : reservedDigit;

        final bool prefixMatched =
            number.startsWith(reservedDigit) ||
            normalizedNumber.startsWith(normalizedReservedDigit);

        if (prefixMatched) {
          matchedOriginalCompanyId = service.companyId?.toString();

          break;
        }
      }

      if (matchedOriginalCompanyId != null) {
        break;
      }
    }

    _lookupDebounce?.cancel();

    setState(() {
      inputNumber = number;
      originalCompanyId = matchedOriginalCompanyId;

      // নতুন number typing শুরু হলে পুরোনো lookup result reset
      detectedCompanyId = null;
      isOperatorLookupConfirmed = false;
    });

    print("Original company id: $originalCompanyId");

    if (!isOperatorLookupEnabled) {
      _handleNormalNumber(number);
      return;
    }

    // Number empty
    if (number.isEmpty) {
      setState(() {
        originalCompanyId = null;
        detectedCompanyId = null;
        isOperatorLookupConfirmed = false;
        selectedIndex = -1;
      });

      bundleController.initialpage = 1;
      bundleController.finalList.clear();

      bundleController.fetchallbundles();
      return;
    }

    /*
   * Full number না হওয়া পর্যন্ত lookup API call হবে না।
   * শুধু prefix অনুযায়ী original operator দেখা যাবে।
   */
    if (requiredLength <= 0 || number.length != requiredLength) {
      print(
        "Waiting for full number: "
        "${number.length}/$requiredLength",
      );

      return;
    }

    // Full number হলে lookup API call
    _lookupDebounce = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted) return;

      final String requestedNumber = confirmPinController.numberController.text
          .trim();

      if (requestedNumber.length != requiredLength) {
        return;
      }

      bundleController.initialpage = 1;
      bundleController.finalList.clear();

      try {
        await bundleController.fetchlookupbundles(requestedNumber);

        if (!mounted) return;

        final String latestNumber = confirmPinController.numberController.text
            .trim();

        // API response আসার আগে number change হলে ignore
        if (latestNumber != requestedNumber) {
          return;
        }

        String? lookupCompanyId;

        if (bundleController.finalList.isNotEmpty) {
          final firstBundle = bundleController.finalList.first;

          lookupCompanyId = firstBundle.service?.company?.id?.toString();
        }

        setState(() {
          detectedCompanyId = lookupCompanyId;

          // API response শেষ হওয়ার পরেই confirmed হবে
          isOperatorLookupConfirmed = lookupCompanyId != null;
        });

        final bool isPorted =
            isOperatorLookupConfirmed &&
            originalCompanyId != null &&
            detectedCompanyId != null &&
            originalCompanyId != detectedCompanyId;

        print("Full number lookup completed");

        print(
          "Original company id: "
          "$originalCompanyId",
        );

        print(
          "Detected company id: "
          "$detectedCompanyId",
        );

        print("Is ported number: $isPorted");
      } catch (e) {
        if (!mounted) return;

        setState(() {
          detectedCompanyId = null;
          isOperatorLookupConfirmed = false;
        });

        print("Operator lookup failed: $e");
      }
    });
  }

  void _handleNormalNumber(String number) {
    _lookupDebounce?.cancel();

    if (number.isEmpty) {
      box.write("company_id", "");

      selectedIndex = -1;

      bundleController.initialpage = 1;
      bundleController.finalList.clear();

      bundleController.fetchallbundles();

      return;
    }

    if (number.length != 3 && number.length != 4) {
      return;
    }

    final services =
        serviceController.allserviceslist.value.data?.services ?? [];

    bool matchFound = false;

    for (final service in services) {
      final companyCodes = service.company?.companycodes ?? [];

      for (final code in companyCodes) {
        final String reservedDigit = code.reservedDigit?.toString() ?? "";

        print(
          "Checking reservedDigit: "
          "$reservedDigit",
        );

        if (reservedDigit == number) {
          box.write("company_id", service.companyId);

          bundleController.initialpage = 1;
          bundleController.finalList.clear();

          bundleController.fetchallbundles();

          print(
            "Matched company_id: "
            "${service.companyId} "
            "with input: $number",
          );

          matchFound = true;
          break;
        }
      }

      if (matchFound) {
        break;
      }
    }

    if (!matchFound) {
      print(
        "No company matched for input: "
        "$number",
      );
    }
  }

  @override
  void initState() {
    super.initState();
    confirmPinController.numberController.clear();
    // bundleController.finalList.clear();
    bundleController.initialpage = 1;
    serviceController.fetchservices();
    bundleController.fetchallbundles();

    confirmPinController.numberController.addListener(_onTextChanged);
    initializeDuration();
    scrollController.addListener(refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    confirmPinController.numberController.removeListener(_onTextChanged);

    super.dispose();
  }

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
          padding: EdgeInsets.all(12.0),
          child: SafeArea(
            child: Column(
              children: [
                Row(
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
                    Text(
                      widget.catName.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.022,
                        fontFamily: box.read("language").toString() == "Fa"
                            ? Get.find<FontController>().currentFont
                            : null,
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
                SizedBox(height: 8),
                Obx(
                  () => CustomTextField(
                    confirmPinController: confirmPinController.numberController,
                    languageData: languagesController.tr("ENTER_PHONE_NUMBER"),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 62,
                  color: Colors.transparent,
                  width: screenWidth,
                  child: Obx(() {
                    // Check if the allserviceslist is not null and contains data
                    final services =
                        serviceController
                            .allserviceslist
                            .value
                            .data
                            ?.services ??
                        [];

                    final bool isFullNumber =
                        _maximumPhoneLength > 0 &&
                        inputNumber.length == _maximumPhoneLength;

                    final filteredServices = inputNumber.isEmpty
                        ? services
                        : isOperatorLookupEnabled
                        ? services.where((service) {
                            final String currentCompanyId =
                                service.companyId?.toString() ?? "";

                            final bool isOriginal =
                                originalCompanyId != null &&
                                currentCompanyId == originalCompanyId;

                            final bool isDetected =
                                isFullNumber &&
                                isOperatorLookupConfirmed &&
                                detectedCompanyId != null &&
                                currentCompanyId == detectedCompanyId;

                            return isOriginal || isDetected;
                          }).toList()
                        : services.where((service) {
                            return service.company?.companycodes?.any((code) {
                                  final String reservedDigit =
                                      code.reservedDigit?.toString() ?? "";

                                  return reservedDigit.isNotEmpty &&
                                      inputNumber.startsWith(reservedDigit);
                                }) ??
                                false;
                          }).toList();

                    return serviceController.isLoading.value == false
                        ? Center(
                            child: ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return SizedBox(width: 5);
                              },
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredServices.length,
                              itemBuilder: (context, index) {
                                final data = filteredServices[index];

                                final String currentCompanyId =
                                    data.companyId?.toString() ?? "";

                                final bool isDetectedOperator =
                                    isOperatorLookupEnabled &&
                                    isOperatorLookupConfirmed &&
                                    inputNumber.length == _maximumPhoneLength &&
                                    detectedCompanyId != null &&
                                    currentCompanyId == detectedCompanyId;
                                final bool isPorted =
                                    isOperatorLookupConfirmed &&
                                    inputNumber.length == _maximumPhoneLength &&
                                    originalCompanyId != null &&
                                    detectedCompanyId != null &&
                                    originalCompanyId != detectedCompanyId;

                                final bool showPortedBadge =
                                    isDetectedOperator && isPorted;
                                final bool isSelected =
                                    isOperatorLookupEnabled &&
                                        isOperatorLookupConfirmed &&
                                        inputNumber.length ==
                                            _maximumPhoneLength
                                    ? isDetectedOperator
                                    : selectedIndex == index;

                                return GestureDetector(
                                  onTap: () async {
                                    final bool isFullNumber =
                                        _maximumPhoneLength > 0 &&
                                        inputNumber.length ==
                                            _maximumPhoneLength;

                                    final bool shouldLockOperatorSelection =
                                        isOperatorLookupEnabled &&
                                        isFullNumber &&
                                        isOperatorLookupConfirmed;

                                    if (shouldLockOperatorSelection) {
                                      return;
                                    }

                                    setState(() {
                                      bundleController.initialpage = 1;
                                      bundleController.finalList.clear();

                                      selectedIndex = index;

                                      box.write("company_id", data.companyId);
                                    });

                                    await bundleController.fetchallbundles();
                                  },
                                  child: SizedBox(
                                    width: showPortedBadge ? 67 : 52,
                                    height: 62,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          left: 1,
                                          bottom: 1,
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? const Color(0xffFFFFFF)
                                                  : Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: showPortedBadge
                                                    ? Colors.orange
                                                    : Colors.transparent,
                                                width: showPortedBadge
                                                    ? 1.5
                                                    : 0,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(5),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  data.company?.companyLogo ??
                                                  "",
                                              fit: BoxFit.contain,
                                              placeholder: (_, __) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 1,
                                                      ),
                                                );
                                              },
                                              errorWidget: (_, __, ___) {
                                                return const Icon(
                                                  Icons.error_outline,
                                                  size: 20,
                                                );
                                              },
                                            ),
                                          ),
                                        ),

                                        if (showPortedBadge)
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.12),
                                                    blurRadius: 3,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: const Text(
                                                "PORTED",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                              strokeWidth: 1.0,
                            ),
                          );
                  }),
                ),

                SizedBox(height: 15),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: duration.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            duration_selectedIndex = index;
                            box.write(
                              "validity_type",
                              duration[index]["Value"],
                            );
                            bundleController.initialpage = 1;
                            bundleController.finalList.clear();
                            bundleController.fetchallbundles();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: duration_selectedIndex == index
                                  ? Colors.white.withOpacity(0.45)
                                  : Colors.white.withOpacity(0.45),
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: duration_selectedIndex == index
                                ? AppColors.primaryColor
                                : Colors.white.withOpacity(0.30),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              child: Text(
                                duration[index]["Name"]!,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: duration_selectedIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily:
                                      box.read("language").toString() == "Fa"
                                      ? Get.find<FontController>().currentFont
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Obx(
                  () => bundleController.isLoading.value == false
                      ? Container(
                          child: bundleController.finalList.isNotEmpty
                              ? SizedBox()
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/icons/empty.png",
                                        height: 80,
                                      ),
                                      Text("No Data found"),
                                    ],
                                  ),
                                ),
                        )
                      : SizedBox(),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white.withOpacity(0.30),
                      ),
                      color: Color(0xffCAE7F6).withOpacity(0.80),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Obx(
                        () =>
                            bundleController.isLoading.value == false &&
                                bundleController.finalList.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  itemCount: bundleController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        bundleController.finalList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (confirmPinController
                                            .numberController
                                            .text
                                            .isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: languagesController.tr(
                                              "ENTER_PHONE_NUMBER",
                                            ),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else {
                                          if (box.read("permission") == "no" ||
                                              confirmPinController
                                                      .numberController
                                                      .text
                                                      .length
                                                      .toString() !=
                                                  box
                                                      .read("maxlength")
                                                      .toString()) {
                                            Fluttertoast.showToast(
                                              msg: languagesController.tr(
                                                "ENTER_CORRECT_NUMBER",
                                              ),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            // Stop further execution if permission is "no"
                                          } else {
                                            box.write(
                                              "bundleID",
                                              data.id.toString(),
                                            );

                                            showDialog(
                                              context: context,
                                              barrierColor: Colors.black
                                                  .withOpacity(0.6),
                                              builder: (context) {
                                                return AnimatedConfirmDialog(
                                                  data: data,
                                                  confirmPinController:
                                                      confirmPinController,
                                                  languagesController:
                                                      languagesController,
                                                  box: box,
                                                  screenWidth: screenWidth,
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 10,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              // Company Logo
                                              Container(
                                                height: 56,
                                                width: 56,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                          data
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),

                                              // Bundle Info (Left side)
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      data.bundleTitle
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black87,
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
                                                    SizedBox(height: 4),
                                                    Obx(
                                                      () => Text(
                                                        data.validityType
                                                                    .toString() ==
                                                                "unlimited"
                                                            ? languagesController
                                                                  .tr(
                                                                    "UNLIMITED",
                                                                  )
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "monthly"
                                                            ? languagesController
                                                                  .tr("MONTHLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "weekly"
                                                            ? languagesController
                                                                  .tr("WEEKLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "daily"
                                                            ? languagesController
                                                                  .tr("DAILY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "hourly"
                                                            ? languagesController
                                                                  .tr("HOURLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "nightly"
                                                            ? languagesController
                                                                  .tr("NIGHTLY")
                                                            : "",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
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
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Price and Badge (Right side)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Sale/Badge
                                                  Obx(
                                                    () => Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            data.validityType
                                                                    .toString() ==
                                                                "weekly"
                                                            ? Color(0xFFFFF3CD)
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "monthly"
                                                            ? Color(0xFFD1E7FF)
                                                            : Color(0xFFFFF3CD),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        data.validityType
                                                                    .toString() ==
                                                                "weekly"
                                                            ? languagesController
                                                                  .tr("WEEKLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "monthly"
                                                            ? languagesController
                                                                  .tr("MONTHLY")
                                                            : languagesController
                                                                  .tr("SALE"),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 11,
                                                          color:
                                                              data.validityType
                                                                      .toString() ==
                                                                  "weekly"
                                                              ? Color(
                                                                  0xFF856404,
                                                                )
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "monthly"
                                                              ? Color(
                                                                  0xFF084298,
                                                                )
                                                              : Color(
                                                                  0xFF856404,
                                                                ),
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
                                                  SizedBox(height: 8),

                                                  // Price
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .baseline,
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    children: [
                                                      PriceTextView(
                                                        price: data.sellingPrice
                                                            .toString(),
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        box.read(
                                                          "currency_code",
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey
                                                              .shade700,
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : bundleController.finalList.isEmpty
                            ? Container(color: Colors.transparent)
                            : RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  controller: scrollController,
                                  itemCount: bundleController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        bundleController.finalList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (confirmPinController
                                            .numberController
                                            .text
                                            .isEmpty) {
                                          Fluttertoast.showToast(
                                            msg: languagesController.tr(
                                              "ENTER_PHONE_NUMBER",
                                            ),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        } else {
                                          if (box.read("permission") == "no" ||
                                              confirmPinController
                                                      .numberController
                                                      .text
                                                      .length
                                                      .toString() !=
                                                  box
                                                      .read("maxlength")
                                                      .toString()) {
                                            Fluttertoast.showToast(
                                              msg: languagesController.tr(
                                                "ENTER_CORRECT_NUMBER",
                                              ),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            // Stop further execution if permission is "no"
                                          } else {
                                            box.write(
                                              "bundleID",
                                              data.id.toString(),
                                            );

                                            showDialog(
                                              context: context,
                                              barrierColor: Colors.black
                                                  .withOpacity(0.6),
                                              builder: (context) {
                                                return AnimatedConfirmDialog(
                                                  data: data,
                                                  confirmPinController:
                                                      confirmPinController,
                                                  languagesController:
                                                      languagesController,
                                                  box: box,
                                                  screenWidth: screenWidth,
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 10,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              // Company Logo
                                              Container(
                                                height: 56,
                                                width: 56,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                          data
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),

                                              // Bundle Info (Left side)
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      data.bundleTitle
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black87,
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
                                                    SizedBox(height: 4),
                                                    Obx(
                                                      () => Text(
                                                        data.validityType
                                                                    .toString() ==
                                                                "unlimited"
                                                            ? languagesController
                                                                  .tr(
                                                                    "UNLIMITED",
                                                                  )
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "monthly"
                                                            ? languagesController
                                                                  .tr("MONTHLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "weekly"
                                                            ? languagesController
                                                                  .tr("WEEKLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "daily"
                                                            ? languagesController
                                                                  .tr("DAILY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "hourly"
                                                            ? languagesController
                                                                  .tr("HOURLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "nightly"
                                                            ? languagesController
                                                                  .tr("NIGHTLY")
                                                            : "",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 11,
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
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Price and Badge (Right side)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Sale/Badge
                                                  Obx(
                                                    () => Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            data.validityType
                                                                    .toString() ==
                                                                "weekly"
                                                            ? Color(0xFFFFF3CD)
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "monthly"
                                                            ? Color(0xFFD1E7FF)
                                                            : Color(0xFFFFF3CD),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        data.validityType
                                                                    .toString() ==
                                                                "weekly"
                                                            ? languagesController
                                                                  .tr("WEEKLY")
                                                            : data.validityType
                                                                      .toString() ==
                                                                  "monthly"
                                                            ? languagesController
                                                                  .tr("MONTHLY")
                                                            : languagesController
                                                                  .tr("SALE"),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 11,
                                                          color:
                                                              data.validityType
                                                                      .toString() ==
                                                                  "weekly"
                                                              ? Color(
                                                                  0xFF856404,
                                                                )
                                                              : data.validityType
                                                                        .toString() ==
                                                                    "monthly"
                                                              ? Color(
                                                                  0xFF084298,
                                                                )
                                                              : Color(
                                                                  0xFF856404,
                                                                ),
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
                                                  SizedBox(height: 8),

                                                  // Price
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .baseline,
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    children: [
                                                      PriceTextView(
                                                        price: data.sellingPrice
                                                            .toString(),
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        box.read(
                                                          "currency_code",
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey
                                                              .shade700,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
