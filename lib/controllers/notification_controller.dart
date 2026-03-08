import 'package:get/get.dart';

import '../models/country_list_model.dart';
import '../models/loan_balance_model.dart';
import '../models/notifications_model.dart';
import '../services/loan_balance_service.dart';
import '../services/notification_service.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  RxInt unreadlength = 0.obs;

  var allnotificationlist = NotificationModel().obs;

  void fetchData() async {
    try {
      isLoading(true);

      final value = await NotificationApi().fetchnotificationData();
      allnotificationlist.value = value;

      // ✅ calculate unread count safely
      final notifications = allnotificationlist.value.data?.notifications ?? [];

      unreadlength.value = notifications.where((n) => n.isRead == false).length;
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
