import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

import '../controllers/transaction_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';

import '../screens/commission_transfer_screen.dart';
import '../screens/hawala_currency_screen.dart';
import '../screens/hawala_list_screen.dart';

import '../screens/loan_screen.dart';
import '../screens/receipts_screen.dart';

import '../utils/colors.dart';
import '../widgets/payment_button.dart';
import 'transactions.dart';

class TransactionsType extends StatefulWidget {
  TransactionsType({super.key});

  @override
  State<TransactionsType> createState() => _TransactionsTypeState();
}

class _TransactionsTypeState extends State<TransactionsType> {
  final Mypagecontroller mypagecontroller = Get.find();

  final transactionController = Get.find<TransactionController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();

    transactionController.fetchTransactionData();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr(
                          "PAYMENT_RECEIPT_REQUEST",
                        ),
                        imagelink: "assets/icons/wallet.png",
                        mycolor: Color(0xff04B75D),
                        onpressed: () {
                          mypagecontroller.changePage(
                            ReceiptsScreen(),
                            isMainPage: false,
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr(
                          "REQUES_LOAN_BALANCE",
                        ),
                        imagelink: "assets/icons/transactionsicon.png",
                        mycolor: Color(0xff3498db),
                        onpressed: () {
                          mypagecontroller.changePage(
                            RequestLoanScreen(),
                            isMainPage: false,
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr("HAWALA"),
                        imagelink: "assets/icons/exchange.png",
                        mycolor: Color(0xffFE8F2D),
                        onpressed: () {
                          mypagecontroller.changePage(
                            HawalaListScreen(),
                            isMainPage: false,
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr("HAWALA_RATES"),
                        imagelink: "assets/icons/exchange-rate.png",
                        mycolor: Color(0xff4B7AFC),
                        onpressed: () {
                          mypagecontroller.changePage(
                            HawalaCurrencyScreen(),
                            isMainPage: false,
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr(
                          "BALANCE_TRANSACTIONS",
                        ),
                        imagelink: "assets/icons/transactionsicon.png",
                        mycolor: Color(0xffDE4B5E),
                        onpressed: () {
                          mypagecontroller.changePage(
                            Transactions(),
                            isMainPage: false,
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      PaymentButton(
                        buttonName: languagesController.tr(
                          "TRANSFER_COMISSION_TO_BALANCE",
                        ),
                        imagelink: "assets/icons/transactionsicon.png",
                        mycolor: Color(0xff9b59b6),
                        onpressed: () {
                          mypagecontroller.changePage(
                            CommissionTransferScreen(),
                            isMainPage: false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
