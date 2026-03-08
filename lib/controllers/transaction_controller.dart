import 'package:get/get.dart';

import '../models/dashboard_data_model.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionController extends GetxController {
  RxList<ResellerBalanceTransaction> finalList =
      <ResellerBalanceTransaction>[].obs;

  RxBool isLoading = false.obs; // First page loading
  RxBool isFetchingMore = false.obs; // Pagination loading
  RxBool isLastPage = false.obs; // No more pages

  int currentPage = 1;
  int totalPages = 1;

  Rx<TransactionModel> alltransactionlist = TransactionModel().obs;

  /// ********** Fetch First Page **********
  Future<void> fetchTransactionData() async {
    try {
      isLoading(true);

      currentPage = 1;
      isLastPage(false);
      finalList.clear();

      final value = await TransactionApi().fetchTransaction(currentPage);

      alltransactionlist.value = value;

      totalPages = value.payload?.pagination?.lastPage ?? 1;

      if (value.data != null) {
        finalList.addAll(value.data!.resellerBalanceTransactions);
      }
    } catch (e) {
      print("ERROR: $e");
    } finally {
      isLoading(false);
    }
  }

  /// ********** Pagination (Load More) **********
  Future<void> fetchMore() async {
    if (isFetchingMore.value || isLastPage.value) return;

    if (currentPage >= totalPages) {
      isLastPage(true);
      print("End.........................................End");
      return;
    }

    try {
      isFetchingMore(true);
      currentPage++;

      print("Loading Page: $currentPage");

      final value = await TransactionApi().fetchTransaction(currentPage);

      if (value.data != null) {
        finalList.addAll(value.data!.resellerBalanceTransactions);
      }

      if (currentPage >= totalPages) {
        isLastPage(true);
        print("End.........................................End");
      }
    } catch (e) {
      print("ERROR: $e");
    } finally {
      isFetchingMore(false);
    }
  }
}
