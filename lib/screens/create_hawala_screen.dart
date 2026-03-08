import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/controllers/sign_in_controller.dart';
import 'package:pamirnet/utils/colors.dart';
import 'package:pamirnet/widgets/button_one.dart';

import '../controllers/add_hawala_controller.dart';
import '../controllers/branch_controller.dart';
import '../global_controller/conversation_controller.dart';
import '../controllers/currency_controller.dart';
import '../controllers/hawala_currency_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../widgets/authtextfield.dart';

class HawalaScreen extends StatefulWidget {
  HawalaScreen({super.key});

  @override
  State<HawalaScreen> createState() => _HawalaScreenState();
}

class _HawalaScreenState extends State<HawalaScreen> {
  final Mypagecontroller mypagecontroller = Get.find();

  final AddHawalaController addHawalaController = Get.put(
    AddHawalaController(),
  );

  SignInController signInController = Get.put(SignInController());

  final CurrencyController currencyController = Get.put(CurrencyController());
  final BranchController branchController = Get.put(BranchController());

  final box = GetStorage();

  List commissionpaidby = [];

  RxString person = "".obs;
  final pageController = Get.find<Mypagecontroller>();
  LanguagesController languagesController = Get.put(LanguagesController());

  HawalaCurrencyController hawalaCurrencyController = Get.put(
    HawalaCurrencyController(),
  );

  ConversationController conversationController = Get.put(
    ConversationController(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    addHawalaController.amountController.clear();
    addHawalaController.currency.value = '';
    addHawalaController.finalAmount.value = '';
    conversationController.selectedCurrency.value = "";
    addHawalaController.senderNameController.clear();
    addHawalaController.receiverNameController.clear();
    addHawalaController.fatherNameController.clear();
    addHawalaController.idcardController.clear();
    addHawalaController.currencyID.value == "";
    addHawalaController.paidbyreceiver.value = "";
    addHawalaController.paidbysender.value = "";
    addHawalaController.branchId.value = "";
    addHawalaController.currency.value = "";
    addHawalaController.currency2.value = "";
    addHawalaController.branch.value = "";

    hawalaCurrencyController.fetchcurrency();
    currencyController.fetchCurrency();
    branchController.fetchallbranch();
    commissionpaidby = [
      languagesController.tr("SENDER"),
      languagesController.tr("RECEIVER"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pageController = Get.find<Mypagecontroller>();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // ignore: unnecessary_null_comparison
        addHawalaController.selectedRate == null;
        return Future.value(true);
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Row(
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
                        // print(conversationController.exchangeRate.toString());
                        print(addHawalaController.currency.toString());
                      },
                      child: Text(
                        languagesController.tr("CREATE_HAWALA"),
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
                SizedBox(height: 12),
                Text(
                  languagesController.tr("SENDER_NAME"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
                SizedBox(height: 5),
                Authtextfield(
                  hinttext: "",
                  controller: addHawalaController.senderNameController,
                ),
                SizedBox(height: 5),
                Text(
                  languagesController.tr("RECEIVER_NAME"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
                SizedBox(height: 5),
                Authtextfield(
                  hinttext: "",
                  controller: addHawalaController.receiverNameController,
                ),
                SizedBox(height: 10),
                Text(
                  languagesController.tr("RECEIVER_FATHERS_NAME"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
                SizedBox(height: 5),
                Authtextfield(
                  hinttext: "",
                  controller: addHawalaController.fatherNameController,
                ),
                SizedBox(height: 5),
                Text(
                  languagesController.tr("RECEIVER_ID_CARD_NUMBER"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
                SizedBox(height: 5),
                Authtextfield(
                  hinttext: "",
                  controller: addHawalaController.idcardController,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      languagesController.tr("HAWALA_AMOUNT"),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: screenHeight * 0.020,
                        fontFamily: box.read("language").toString() == "Fa"
                            ? Get.find<FontController>().currentFont
                            : null,
                      ),
                    ),
                    Text(
                      languagesController.tr("CURRENCY"),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: screenHeight * 0.020,
                        fontFamily: box.read("language").toString() == "Fa"
                            ? Get.find<FontController>().currentFont
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: screenWidth,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: screenHeight * 0.065,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            color: Color(0xffF9FAFB),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: TextField(
                              style: TextStyle(height: 1.1),
                              keyboardType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'),
                                ),
                              ],
                              controller: addHawalaController.amountController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenHeight * 0.018,
                                  fontFamily:
                                      box.read("language").toString() == "Fa"
                                      ? Get.find<FontController>().currentFont
                                      : null,
                                ),
                              ),
                              onChanged: (value) {
                                final selected =
                                    addHawalaController.selectedRate.value;

                                // যদি কোন currency সিলেক্ট না করা হয় (selected null হয়) তাহলে হিসাব না করো
                                if (selected == null ||
                                    addHawalaController
                                        .currency
                                        .value
                                        .isEmpty) {
                                  addHawalaController.finalAmount.value =
                                      "0.00";
                                  return;
                                }

                                double input =
                                    double.tryParse(
                                      addHawalaController.amountController.text
                                          .trim(),
                                    ) ??
                                    0;
                                double dAmount =
                                    double.tryParse(
                                      selected.amount?.toString() ?? "0",
                                    ) ??
                                    0;
                                double sRate =
                                    double.tryParse(
                                      selected.sellRate?.toString() ?? "0",
                                    ) ??
                                    0;

                                double result = 0;
                                if (dAmount > 0 && sRate > 0) {
                                  result = (input / dAmount) * sRate;
                                }

                                addHawalaController.finalAmount.value = result
                                    .toStringAsFixed(2);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),

                      Expanded(
                        flex: 1,
                        child: Obx(() {
                          // rates আনছি (dynamic list)
                          final List<dynamic> rates =
                              (hawalaCurrencyController
                                      .hawalafilteredcurrency
                                      .value
                                      .data
                                      ?.rates
                                  as List?) ??
                              <dynamic>[];

                          // helper: নিরাপদে double parse
                          double _toDouble(dynamic v) {
                            if (v == null) return 0;
                            return double.tryParse(v.toString()) ?? 0;
                          }

                          final bool langIsFa =
                              box.read("language").toString() == "Fa";

                          // 1) ডুপ্লিকেট toCurrency.id বাদ দিয়ে প্রথম occurrence রাখি
                          final Map<String, dynamic> uniqueByToId = {};
                          for (final r in rates) {
                            final String toId = ((r?.toCurrency?.id) ?? '')
                                .toString();
                            if (toId.isEmpty) continue;
                            // আগে রাখা না থাকলে রাখি (প্রথমটাই থাকবে)
                            uniqueByToId.putIfAbsent(toId, () => r);
                          }

                          // 2) Dropdown items তৈরি
                          final dropdownItems = uniqueByToId.entries
                              .map<DropdownMenuItem<String>>((e) {
                                final symbol =
                                    ((e.value?.toCurrency?.symbol) ?? '')
                                        .toString();
                                return DropdownMenuItem<String>(
                                  value: e.key, // toCurrency.id
                                  child: Text(symbol),
                                );
                              })
                              .toList();

                          // 3) বর্তমান value dropdown-এ আছে কিনা
                          final currentValue =
                              addHawalaController.currencyID.value;
                          final bool valueExists =
                              currentValue.isNotEmpty &&
                              uniqueByToId.containsKey(currentValue);

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              alignment: !langIsFa
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,

                              // dropdown-এ না থাকলে null
                              value: valueExists ? currentValue : null,

                              items: dropdownItems,

                              onChanged: (value) {
                                if (value == null) return;

                                // 4) নির্বাচিত rate (ডুপ্লিকেট ফ্রি map থেকে)
                                final selectedRate = uniqueByToId[value];

                                // 5) controller আপডেট
                                addHawalaController.currencyID.value = value;
                                addHawalaController.currency.value =
                                    ((selectedRate?.toCurrency?.symbol) ?? '')
                                        .toString();
                                addHawalaController.selectedRate.value =
                                    selectedRate;

                                // 6) হিসাব
                                final input = _toDouble(
                                  addHawalaController.amountController.text
                                      .trim(),
                                );
                                final dAmount = _toDouble(selectedRate?.amount);
                                final sRate = _toDouble(selectedRate?.sellRate);

                                double result = 0;
                                if (dAmount > 0 && sRate > 0) {
                                  result = (input / dAmount) * sRate;
                                }
                                addHawalaController.finalAmount.value = result
                                    .toStringAsFixed(2);
                              },

                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              icon: const Icon(
                                FontAwesomeIcons.chevronDown,
                                color: Colors.grey,
                                size: 20,
                              ),
                              hint: Text(
                                addHawalaController.currency.value.isEmpty
                                    ? ''
                                    : addHawalaController.currency.value,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  languagesController.tr("COMMISSION_PAID_BY"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    alignment: box.read("language").toString() != "Fa"
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    value: person.value.isEmpty ? null : person.value,
                    items: commissionpaidby.map((p) {
                      return DropdownMenuItem<String>(
                        value: p,
                        child: Text(p, style: const TextStyle(fontSize: 16)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      person.value = value;

                      if (value == "sender") {
                        addHawalaController.paidbysender.value = "1";
                        addHawalaController.paidbyreceiver.value = "0";
                      } else {
                        addHawalaController.paidbysender.value = "0";
                        addHawalaController.paidbyreceiver.value = "1";
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      FontAwesomeIcons.chevronDown,
                      color: Colors.grey,
                      size: 20, // larger like the other dropdowns
                    ),
                    hint: Text(
                      person.value.isEmpty ? '' : person.value,
                      style: TextStyle(
                        fontSize: screenHeight * 0.020,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Color(0xff352B73),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            addHawalaController.finalAmount.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Text(
                          box.read("currency_code"),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  languagesController.tr(
                    "FINAL_AMOUNT_DEDUCTED_FROM_YOUR_BALANCE",
                  ),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: screenHeight * 0.015,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  languagesController.tr("BRANCH"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Obx(() {
                    // Use dynamic since model name isn't specified; cast to list safely
                    final List<dynamic> branches =
                        (branchController.allbranch.value.data?.hawalabranches
                            as List?) ??
                        <dynamic>[];

                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      alignment: box.read("language").toString() != "Fa"
                          ? Alignment.centerLeft
                          : Alignment.centerRight,

                      // value is the selected branch id (String)
                      value: addHawalaController.branchId.value.isEmpty
                          ? null
                          : addHawalaController.branchId.value,

                      items: branches.map<DropdownMenuItem<String>>((b) {
                        final String idStr = ((b?.id) ?? '').toString();
                        final String name = ((b?.name) ?? '').toString();
                        return DropdownMenuItem<String>(
                          value: idStr,
                          child: Text(
                            name,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),

                      onChanged: (value) {
                        if (value == null) return;

                        // find selected branch
                        dynamic picked;
                        for (final b in branches) {
                          if (((b?.id) ?? '').toString() == value) {
                            picked = b;
                            break;
                          }
                        }
                        picked ??= branches.isNotEmpty ? branches.first : null;

                        // update controllers
                        addHawalaController.branchId.value = value;
                        addHawalaController.branch.value =
                            ((picked?.name) ?? '').toString();
                      },

                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),

                      icon: const Icon(
                        FontAwesomeIcons.chevronDown,
                        color: Colors.grey,
                        size: 20,
                      ),

                      // show current branch text like before
                      hint: Text(
                        addHawalaController.branch.value.isEmpty
                            ? ''
                            : addHawalaController.branch.value,
                        style: TextStyle(
                          fontSize: screenHeight * 0.020,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 10),
                Obx(
                  () => DefaultButton(
                    buttonName: addHawalaController.isLoading.value == false
                        ? languagesController.tr("CONFIRM_AND_SUBMIT")
                        : languagesController.tr("PLEASE_WAIT"),
                    mycolor: Colors.green,
                    onpressed: () async {
                      if (addHawalaController
                              .senderNameController
                              .text
                              .isNotEmpty &&
                          addHawalaController
                              .receiverNameController
                              .text
                              .isNotEmpty &&
                          addHawalaController
                              .amountController
                              .text
                              .isNotEmpty &&
                          addHawalaController
                              .fatherNameController
                              .text
                              .isNotEmpty &&
                          addHawalaController
                              .idcardController
                              .text
                              .isNotEmpty &&
                          addHawalaController.currencyID.value != "" &&
                          addHawalaController.paidbyreceiver.value != "" &&
                          addHawalaController.branchId.value != "") {
                        print("All is ok............");

                        bool success = await addHawalaController.createhawala();
                        if (success) {
                          Get.find<Mypagecontroller>().goBack();
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "Enter All data",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
