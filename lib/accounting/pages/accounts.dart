import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pamirnet/helpers/language_changer.dart';
import '../../global_controller/languages_controller.dart';
import '../../utils/colors.dart';
import '../controllers/accounting_currency_controller.dart';
import '../controllers/allaccount_list_controller.dart';
import '../controllers/office_list_controller.dart';
import '../create_account_screen.dart';
import '../models/allaccount_model.dart';
import '../screens/account_details_screen.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final LanguagesController languagesController =
      Get.find<LanguagesController>();

  final AllAccountListController accountListController =
      Get.isRegistered<AllAccountListController>()
      ? Get.find<AllAccountListController>()
      : Get.put(AllAccountListController());

  final OfficeListController officeListController =
      Get.isRegistered<OfficeListController>()
      ? Get.find<OfficeListController>()
      : Get.put(OfficeListController());

  final AccountingCurrencyController currencyController =
      Get.isRegistered<AccountingCurrencyController>()
      ? Get.find<AccountingCurrencyController>()
      : Get.put(AccountingCurrencyController());

  @override
  void initState() {
    super.initState();
    accountListController.initialpage = 1;
    accountListController.finalList.clear();
    accountListController.fetchaccount();
    scrollController.addListener(_onScroll);
  }

  /// Load and refresh more
  Future<void> _refreshCounterParties() async {
    if (_isRefreshing) return;

    _isRefreshing = true;

    try {
      accountListController.initialpage = 1;
      accountListController.finalList.clear();

      await accountListController.fetchaccount();
    } catch (e) {
      debugPrint("Counterparty refresh error: $e");
    } finally {
      _isRefreshing = false;
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final position = scrollController.position;

    // Bottom-এর একটু আগে next page load হবে
    if (position.extentAfter < 250) {
      _loadMoreCounterParties();
    }
  }

  Future<void> _loadMoreCounterParties() async {
    if (_isLoadingMore) return;

    final int totalPages =
        accountListController
            .accountlist
            .value
            .payload
            ?.pagination
            ?.totalPages ??
        0;

    final int currentPage = accountListController.initialpage;

    if (totalPages <= 0) return;

    // Last page
    if (currentPage >= totalPages) {
      debugPrint("Counterparty: Last page reached");
      return;
    }

    final int nextPage = currentPage + 1;

    if (mounted) {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      accountListController.initialpage = nextPage;

      await accountListController.fetchaccount();
    } catch (e) {
      // Error হলে আগের page-এ ফিরে যাবে
      accountListController.initialpage = currentPage;

      debugPrint("Counterparty load more error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  final ScrollController scrollController = ScrollController();

  /// Load and refresh more

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  bool _isLoadingMore = false;
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.listbuilderboxColor,

        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.listbuilderboxColor,
          surfaceTintColor: AppColors.listbuilderboxColor,
          titleSpacing: 15,

          title: Row(
            children: [
              Text(
                languagesController.tr("ACCOUNTS"),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.fontColor,
                  child: Image.asset("assets/icons/telecom.png", height: 25),
                ),
              ),
              SizedBox(width: 5),

              const LanguageSelectorButton(size: 42, iconSize: 25),
            ],
          ),
        ),

        body: Container(
          width: double.infinity,
          height: double.infinity,

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.secondaryColor, AppColors.primarycolor2],
            ),
          ),

          child: Obx(() {
            final bool isLoading = accountListController.isLoading.value;

            final List<Account> accounts =
                accountListController.accountlist.value.data?.accounts ?? [];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: screenWidth,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 30,
                                      color: Colors.grey.shade500,
                                    ),

                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: languagesController.tr(
                                            "NAME",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Image.asset("assets/icons/filter.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),

                  Expanded(
                    child: Obx(() {
                      final bool isLoading =
                          accountListController.isLoading.value;

                      final bool hasData =
                          accountListController.finalList.isNotEmpty;

                      /// প্রথমবার loading
                      if (isLoading && !hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }

                      /// Empty data
                      if (!hasData) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: AppColors.listbuilderboxColor,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 34,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                languagesController.tr("NO_ACCOUNTS_FOUND"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      /// Account List
                      return ListView.builder(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(top: 2, bottom: 8),
                        itemCount:
                            accountListController.finalList.length +
                            (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          /// Pagination loader
                          if (index == accountListController.finalList.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Center(
                                child: SizedBox(
                                  height: 23,
                                  width: 23,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            );
                          }

                          final Account account =
                              accountListController.finalList[index];

                          final double balanceValue =
                              double.tryParse(
                                account.currentBalance?.toString() ?? "0",
                              ) ??
                              0;

                          final bool isBalanceSettled = balanceValue == 0;
                          final bool heOwes = balanceValue < 0;

                          final String balanceRelationText = isBalanceSettled
                              ? languagesController.tr("BALANCE_SETTLED")
                              : heOwes
                              ? languagesController.tr("HE_OWE")
                              : languagesController.tr("HE_OWED");

                          final Color balanceColor = isBalanceSettled
                              ? const Color(0xFF667085)
                              : heOwes
                              ? const Color(0xFFD92D20)
                              : AppColors.greenColor;

                          final IconData balanceRelationIcon = isBalanceSettled
                              ? Icons.check_circle_outline_rounded
                              : heOwes
                              ? Icons.south_west_rounded
                              : Icons.north_east_rounded;

                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => AccountDetailsScreen(
                                  accountID: account.id.toString(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.listbuilderboxColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.secondaryColor,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryColor,
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: Text(
                                      account.currencyCode ?? "--",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 11),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          account.name ?? "---",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        Row(
                                          children: [
                                            Icon(
                                              Icons.currency_exchange_rounded,
                                              size: 14,
                                              color: Colors.grey.shade500,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              account.currencyCode ?? "---",
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _formatAmount(account.currentBalance),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: balanceColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            balanceRelationIcon,
                                            size: 12,
                                            color: balanceColor,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            balanceRelationText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: balanceColor,
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const SizedBox(width: 4),

                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 21,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => CreateAccountScreen());
                    },
                    child: Container(
                      height: 55,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          languagesController.tr("ADD_NEW_ACCOUNT"),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // String _formatAmount(String? value) {
  //   final double amount = double.tryParse(value ?? "0") ?? 0;

  //   return amount.toStringAsFixed(2);
  // }

  String _formatAmount(String? value) {
    final double amount = double.tryParse(value ?? "0") ?? 0;

    return NumberFormat('#,##0.00').format(amount);
  }
}
