import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pamirnet/controllers/transaction_controller.dart';
import 'package:pamirnet/global_controller/languages_controller.dart';
import 'package:pamirnet/utils/colors.dart';

import '../global_controller/font_controller.dart';
import '../helpers/localtime_helper.dart';

class Transactions extends StatefulWidget {
  Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  List orderStatus = [
    {"title": "Pending", "value": "order_status=0"},
    {"title": "Confirmed", "value": "order_status=1"},
    {"title": "Rejected", "value": "order_status=2"},
  ];

  final box = GetStorage();

  String defaultValue = "";

  String secondDropDown = "";

  final transactionController = Get.find<TransactionController>();
  LanguagesController languagesController = Get.put(LanguagesController());

  final TextEditingController dateController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // transactionController.initialpage = 1;
    transactionController.finalList.clear();
    transactionController.fetchTransactionData();
    // scrollController.addListener(refresh);
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        transactionController.fetchMore();
      }
    });
  }

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
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 10),
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
                    Obx(
                      () => Text(
                        languagesController.tr("TRANSACTIONS"),
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

                SizedBox(height: 10),
                Obx(
                  () => transactionController.isLoading.value == true
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
                  () => transactionController.isLoading.value == false
                      ? Container(
                          child:
                              transactionController
                                  .alltransactionlist
                                  .value
                                  .data!
                                  .resellerBalanceTransactions
                                  .isNotEmpty
                              ? SizedBox()
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/icons/empty.png",
                                        height: 80,
                                      ),
                                      Text("No Data found", style: TextStyle()),
                                    ],
                                  ),
                                ),
                        )
                      : SizedBox(),
                ),
                Expanded(
                  child: Obx(
                    () =>
                        transactionController.isLoading.value == false &&
                            transactionController.finalList.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              await transactionController
                                  .fetchTransactionData();
                            },
                            child: ListView.builder(
                              shrinkWrap: false,
                              controller: scrollController,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: transactionController.finalList.length,
                              itemBuilder: (context, index) {
                                final data =
                                    transactionController.finalList[index];
                                return _buildSmallTransactionCard(data);
                              },
                            ),
                          )
                        : transactionController.finalList.isEmpty
                        ? SizedBox()
                        : RefreshIndicator(
                            onRefresh: () async {
                              await transactionController
                                  .fetchTransactionData();
                            },
                            child: ListView.builder(
                              shrinkWrap: false,
                              controller: scrollController,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: transactionController.finalList.length,
                              itemBuilder: (context, index) {
                                final data =
                                    transactionController.finalList[index];
                                return _buildSmallTransactionCard(data);
                              },
                            ),
                          ),
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

  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: valueColor ?? Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Small Transaction Card Widget
  Widget _buildSmallTransactionCard(dynamic data) {
    final isDebit = data.status.toString() == "debit";
    final statusColor = isDebit ? Colors.red : Colors.green;

    return GestureDetector(
      onTap: () => _showTransactionDialog(data),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Colored status strip
                Container(width: 5, color: statusColor),

                // Compact content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Name + Date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.reseller!.contactName.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              convertToDate(data.createdAt.toString()),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),

                        // Amount + Type badge
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              NumberFormat.currency(
                                locale: 'en_US',
                                symbol: '',
                                decimalDigits: 2,
                              ).format(double.parse(data.amount.toString())),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                            SizedBox(height: 3),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isDebit
                                    ? languagesController.tr("DEBIT")
                                    : languagesController.tr("CREDIT"),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
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
    );
  }

  // Alert Dialog for full details
  void _showTransactionDialog(dynamic data) {
    final isDebit = data.status.toString() == "debit";
    final statusColor = isDebit ? Colors.red : Colors.green;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isDebit ? Icons.arrow_upward : Icons.arrow_downward,
                    color: statusColor,
                    size: 32,
                  ),
                  SizedBox(height: 6),
                  Text(
                    NumberFormat.currency(
                      locale: 'en_US',
                      symbol: '',
                      decimalDigits: 2,
                    ).format(double.parse(data.amount.toString())),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  Text(
                    box.read("currency_code"),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDialogRow(
                    icon: Icons.person_outline,
                    label: languagesController.tr("NAME"),
                    value: data.reseller!.contactName.toString(),
                  ),
                  Divider(height: 16, thickness: 0.5),
                  _buildDialogRow(
                    icon: Icons.calendar_today_outlined,
                    label: languagesController.tr("DATE"),
                    value: convertToDate(data.createdAt.toString()),
                  ),
                  SizedBox(height: 8),
                  _buildDialogRow(
                    icon: Icons.access_time_outlined,
                    label: languagesController.tr("TIME"),
                    value: convertToLocalTime(data.createdAt.toString()),
                  ),
                  Divider(height: 16, thickness: 0.5),
                  _buildDialogRow(
                    icon: Icons.swap_horiz,
                    label: languagesController.tr("TRANSACTIONS_TYPE"),
                    value: isDebit
                        ? languagesController.tr("DEBIT")
                        : languagesController.tr("CREDIT"),
                    valueColor: statusColor,
                  ),
                  if (data.transactionReason != null &&
                      data.transactionReason.toString().isNotEmpty) ...[
                    Divider(height: 16, thickness: 0.5),
                    _buildDialogRow(
                      icon: Icons.notes_outlined,
                      label: languagesController.tr("REASON"),
                      value: data.transactionReason.toString(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              languagesController.tr("CLOSE"),
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  // Helper row for dialog
  Widget _buildDialogRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        SizedBox(width: 8),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
