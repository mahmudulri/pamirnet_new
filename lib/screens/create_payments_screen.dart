import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/add_hawala_controller.dart';

import '../controllers/add_payment_controller.dart';
import '../controllers/branch_controller.dart';
import '../global_controller/conversation_controller.dart';
import '../controllers/currency_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import '../controllers/payment_method_controller.dart';
import '../controllers/payment_type_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../global_controller/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../models/currency_model.dart';
import '../models/payment_type_model.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';

import '../widgets/button_one.dart';
import '../widgets/ktext.dart';
import 'hawala_list_screen.dart';
import 'receipts_screen.dart';

class CreatePaymentsScreen extends StatefulWidget {
  CreatePaymentsScreen({super.key});

  @override
  State<CreatePaymentsScreen> createState() => _CreatePaymentsScreenState();
}

class _CreatePaymentsScreenState extends State<CreatePaymentsScreen> {
  final Mypagecontroller mypagecontroller = Get.find();

  SignInController signInController = Get.put(SignInController());

  CurrencyController currencyController = Get.put(CurrencyController());
  PaymentMethodController paymentMethodController = Get.put(
    PaymentMethodController(),
  );
  PaymentTypeController paymentTypeController = Get.put(
    PaymentTypeController(),
  );

  final box = GetStorage();

  List commissionpaidby = [];

  RxString person = "".obs;
  final pageController = Get.find<Mypagecontroller>();
  LanguagesController languagesController = Get.put(LanguagesController());

  AddPaymentController addPaymentController = Get.put(AddPaymentController());

  @override
  void initState() {
    super.initState();
    paymentMethodController.fetchmethods();
    currencyController.fetchCurrency();
    paymentTypeController.fetchtypes();
    _resetPaymentMethod();

    commissionpaidby = [
      languagesController.tr("SENDER"),
      languagesController.tr("RECEIVER"),
    ];
  }

  var selectedMethod = "".obs;
  var selectedType = "".obs;
  var selectedcurrency = "".obs;

  void _resetPaymentMethod() {
    addPaymentController.payment_method_id.value = '';
    selectedMethod.value = '';

    addPaymentController.amountController.clear();
    addPaymentController.trackingCodeController.clear();
    addPaymentController.noteController.clear();
    addPaymentController.payment_type_id.value = '';
    selectedType.value = '';
    addPaymentController.paymentDate.value = '';
    addPaymentController.selectedDate.value = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final pageController = Get.find<Mypagecontroller>();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: ListView(
          children: [
            SizedBox(height: 10),
            Container(
              height: 600,
              width: screenWidth,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    KText(
                      text: languagesController.tr("PAYMENT_METHOD"),
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.020,
                    ),
                    SizedBox(height: 5),
                    Obx(() {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: Get.context!,
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                insetPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                title: KText(
                                  text: languagesController.tr(
                                    "SELECT_PAYMENT_METHOD",
                                  ),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                content: PaymentMethodBox(
                                  selectedMethod: selectedMethod,
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 50,
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment:
                                      box.read("language").toString() != "Fa"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Text(
                                    selectedMethod.value.isEmpty
                                        ? 'Select payment method'
                                        : selectedMethod.value,
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.020,
                                      color: selectedMethod.value.isEmpty
                                          ? Colors.grey.shade500
                                          : Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.chevronDown,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: languagesController.tr("AMOUNT"),
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                        ),
                        KText(
                          text: languagesController.tr("CURRENCY"),
                          color: Colors.grey.shade600,
                          fontSize: screenHeight * 0.020,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 50,
                      width: screenWidth,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
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
                                  controller:
                                      addPaymentController.amountController,
                                  style: TextStyle(
                                    height: 1.1,
                                    fontFamily:
                                        box.read("language").toString() == "Fa"
                                        ? Get.find<FontController>().currentFont
                                        : null,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d{0,2}'),
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: screenHeight * 0.018,
                                      fontFamily:
                                          box.read("language").toString() ==
                                              "Fa"
                                          ? Get.find<FontController>()
                                                .currentFont
                                          : null,
                                    ),
                                  ),
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: Obx(() {
                              // 1) Strongly type the list to Currency
                              final List<Currency> currencies =
                                  (currencyController
                                              .allcurrency
                                              .value
                                              .data
                                              ?.currencies ??
                                          <dynamic>[])
                                      .cast<Currency>();

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                alignment:
                                    box.read("language").toString() == "Fa"
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Text(box.read("currency_code")),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    KText(
                      text: languagesController.tr("PAYMENT_DATE"),
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.020,
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 50,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => KText(
                                  text: addPaymentController.selectedDate.value,
                                  fontSize: screenHeight * 0.020,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  String formattedDate =
                                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                  addPaymentController.selectedDate.value =
                                      formattedDate;
                                }
                              },
                              child: Icon(
                                Icons.calendar_month,
                                size: 22,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    KText(
                      text: languagesController.tr("TRACKING_CODE"),
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.020,
                    ),
                    SizedBox(height: 5),
                    Authtextfield(
                      hinttext: "",
                      controller: addPaymentController.trackingCodeController,
                    ),
                    SizedBox(height: 10),
                    KText(
                      text: languagesController.tr("NOTES"),
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.020,
                    ),
                    SizedBox(height: 5),
                    Authtextfield(
                      hinttext: "",
                      controller: addPaymentController.noteController,
                    ),
                    SizedBox(height: 10),
                    KText(
                      text: languagesController.tr("PAYMENT_TYPE"),
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.020,
                    ),
                    SizedBox(height: 5),
                    Obx(() {
                      final List<PaymentType> types =
                          (paymentTypeController
                                      .alltypes
                                      .value
                                      .data
                                      ?.paymentTypes ??
                                  <dynamic>[])
                              .cast<PaymentType>();

                      return Container(
                        height: 50,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          alignment: box.read("language").toString() != "Fa"
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          value:
                              addPaymentController.payment_type_id.value.isEmpty
                              ? null
                              : addPaymentController.payment_type_id.value,
                          items: types.map((t) {
                            final String idStr = (t.id ?? '').toString();
                            final String name = t.name?.toString() ?? '';
                            return DropdownMenuItem<String>(
                              value: idStr,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            addPaymentController.payment_type_id.value = value;

                            String pickedName = '';
                            for (final t in types) {
                              final String idStr = (t.id ?? '').toString();
                              if (idStr == value) {
                                pickedName = t.name?.toString() ?? '';
                                break;
                              }
                            }
                            selectedType.value = pickedName;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          icon: Icon(
                            FontAwesomeIcons.chevronDown,
                            color: Colors.grey,
                            size: 20, // larger icon to match others
                          ),
                          hint: KText(
                            text: selectedType.value.isEmpty
                                ? ''
                                : selectedType.value,
                            fontSize: screenHeight * 0.020,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 10),
                    KText(
                      text: languagesController.tr("UPLOAD_IMAGES"),
                      color: Colors.grey.shade600,
                      fontSize: screenHeight * 0.020,
                    ),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildImageUploaderBox(
                            context,
                            languagesController.tr("IMAGE_ONE"),
                            addPaymentController.paymentImagePath,
                            () => addPaymentController.pickImage("payment"),
                          ),
                          SizedBox(width: 10),
                          buildImageUploaderBox(
                            context,
                            languagesController.tr("IMAGE_TOW"),
                            addPaymentController.extraImage1Path,
                            () => addPaymentController.pickImage("extra1"),
                          ),
                          SizedBox(width: 10),
                          buildImageUploaderBox(
                            context,
                            languagesController.tr("IMAGE_THREE"),
                            addPaymentController.extraImage2Path,
                            () => addPaymentController.pickImage("extra2"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Obx(
                      () => DefaultButton(
                        mycolor: Colors.green,
                        buttonName:
                            addPaymentController.isLoading.value == false
                            ? languagesController.tr("ADD_NOW")
                            : languagesController.tr("PLEASE_WAIT"),
                        onpressed: () {
                          if (addPaymentController.payment_method_id.value ==
                                  '' ||
                              addPaymentController
                                  .amountController
                                  .text
                                  .isEmpty ||
                              addPaymentController.selectedDate.value ==
                                  '' || // <-- FIXED
                              addPaymentController
                                  .trackingCodeController
                                  .text
                                  .isEmpty ||
                              addPaymentController
                                  .noteController
                                  .text
                                  .isEmpty) {
                            print(
                              addPaymentController.payment_method_id.value
                                  .toString(),
                            );
                            print(
                              addPaymentController.amountController.text
                                  .toString(),
                            );
                            print(addPaymentController.currencyID.toString());
                            // Fluttertoast.showToast(
                            //   msg:
                            //       languagesController.tr("FILL_DATA_CORRECTLY"),
                            //   toastLength: Toast.LENGTH_SHORT,
                            //   gravity: ToastGravity.BOTTOM,
                            //   timeInSecForIosWeb: 1,
                            //   backgroundColor: Colors.black,
                            //   textColor: Colors.white,
                            //   fontSize: 16.0,
                            // );
                          } else {
                            addPaymentController.addNow();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildImageUploaderBox(
  BuildContext context,
  String label,
  RxString imagePath,
  VoidCallback onPick,
) {
  return Obx(
    () => Stack(
      children: [
        GestureDetector(
          onTap: onPick,
          child: Container(
            width: 160,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: imagePath.value.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(imagePath.value),
                      width: 160,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: KText(
                        text: label,
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ),
        ),
        if (imagePath.value.isNotEmpty)
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                imagePath.value = '';
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
      ],
    ),
  );
}

class PaymentMethodBox extends StatelessWidget {
  PaymentMethodBox({super.key, required this.selectedMethod});

  PaymentMethodController paymentMethodController = Get.put(
    PaymentMethodController(),
  );

  AddPaymentController addPaymentController = Get.put(AddPaymentController());

  var selectedMethod = "".obs;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 450,
      width: screenWidth,
      decoration: BoxDecoration(color: Colors.white),
      child: Obx(
        () => paymentMethodController.isLoading.value == false
            ? ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: paymentMethodController
                    .allmethods
                    .value
                    .data!
                    .paymentMethods!
                    .length,
                itemBuilder: (context, index) {
                  final data = paymentMethodController
                      .allmethods
                      .value
                      .data!
                      .paymentMethods![index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () {
                        addPaymentController.payment_method_id.value = data.id
                            .toString();
                        selectedMethod.value =
                            data.methodName?.toString() ?? '';

                        // Close the bottom sheet or dialog
                        Get.back();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with Bank Name and Image
                              Row(
                                children: [
                                  // Bank Logo/Image
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child:
                                          data.accountImage != null &&
                                              data.accountImage
                                                  .toString()
                                                  .isNotEmpty &&
                                              data.accountImage.toString() !=
                                                  'null'
                                          ? Image.network(
                                              data.accountImage.toString(),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Icon(
                                                      Icons.account_balance,
                                                      color:
                                                          Colors.blue.shade700,
                                                      size: 28,
                                                    );
                                                  },
                                              loadingBuilder:
                                                  (
                                                    context,
                                                    child,
                                                    loadingProgress,
                                                  ) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(
                                                              Colors
                                                                  .blue
                                                                  .shade300,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                            )
                                          : Icon(
                                              Icons.account_balance,
                                              color: Colors.blue.shade700,
                                              size: 28,
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: data.bankName.toString(),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black87,
                                        ),
                                        SizedBox(height: 2),
                                        KText(
                                          text:
                                              data.methodName?.toString() ?? '',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Divider(height: 24, thickness: 1),

                              // Account Details
                              _buildInfoRow(
                                icon: Icons.person_outline,
                                label: languagesController.tr("ACCOUNT_HOLDER"),
                                value: data.accountHolderName.toString(),
                              ),
                              SizedBox(height: 10),

                              _buildInfoRow(
                                icon: Icons.credit_card,
                                label: languagesController.tr("CARD_NUMBER"),
                                value: data.cardNumber.toString(),
                              ),
                              SizedBox(height: 10),

                              // Account Number with Copy
                              _buildCopyableRow(
                                icon: Icons.numbers,
                                label: languagesController.tr(
                                  "ACCOUNT/CARD_NUMBER",
                                ),
                                value: data.accountNumber.toString(),
                                onCopy: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: data.accountNumber.toString(),
                                    ),
                                  );
                                  Get.snackbar(
                                    languagesController.tr("COPIED"),
                                    languagesController.tr(
                                      "ACCOUNT_NUMBER_COPIED_TO_CLIPBOARD",
                                    ),
                                    backgroundColor: Colors.white,
                                    colorText: Colors.black87,
                                    snackPosition: SnackPosition.TOP,
                                    duration: Duration(seconds: 2),
                                    margin: EdgeInsets.all(16),
                                    borderRadius: 8,
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                  );
                                },
                              ),

                              // Sheba Number (if available)
                              if (data.shebaNumber != null &&
                                  data.shebaNumber.toString().isNotEmpty) ...[
                                SizedBox(height: 10),
                                _buildInfoRow(
                                  icon: Icons.qr_code,
                                  label: languagesController.tr("SEBA_NUMBER"),
                                  value: data.shebaNumber.toString(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              KText(
                text: label,
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
              KText(
                text: " : ",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
              Expanded(
                child: KText(
                  text: value,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCopyableRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onCopy,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              KText(
                text: label,
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
              KText(
                text: " : ",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
              Expanded(
                child: KText(
                  text: value,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: onCopy,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200, width: 1),
                  ),
                  child: Icon(
                    Icons.copy,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
