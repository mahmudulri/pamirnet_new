import 'package:get/get.dart';
import '../models/allaccount_model.dart';
import '../services/all_accountlist_service.dart';

class AllAccountListController extends GetxController {
  int initialpage = 1;
  var isLoading = false.obs;

  RxList<Account> finalList = <Account>[].obs;

  var accountlist = AllAccountsModel().obs;

  Future fetchaccount() async {
    try {
      isLoading(true);
      await AllAccountlistApi().fetchaccountlist(initialpage).then((value) {
        accountlist.value = value;

        if (accountlist.value.data != null) {
          finalList.addAll(accountlist.value.data!.accounts!);
        }

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
